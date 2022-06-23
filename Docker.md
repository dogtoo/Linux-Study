## 修改Docker本地映象與容器的儲存位置的方法

預設 Docker 的存放位置
```
docker info | grep "Docker Root Dir"
> /var/lib/docker
```

```
systemctl  stop  docker
```

移動整個/var/lib/docker目錄到目的路徑
```
mv   /var/lib/docker   /home/data/docker   // /root/data/docke 是掛載好的磁碟
ln  -s  /home/data/docker  /var/lib/docker  // 軟連線指向
```

```
systemctl start docker
```

## 開啟 Docker RESTful API 2375

```
sudo service docker stop # docker要先停，起完dockerd時會自動啟
sudo dockerd -H unix:///var/run/docker.sock -H tcp://192.168.59.106 &
```

```
docker 因為會固定連socket，如果沒有0.0.0.0 就要設 export DOCKER_HOST="tcp://192.168.59.124:2375"
```

## 開啟2375後如何刪除
```
sudo kill ${dockerd sudo pid}
or 刪除在背景程式
sudo kill --SIGHUP ${dockerd pid}
```

# 2376 還沒測過

server 端
```
openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem   -CAcreateserial -out cert.pem -extfile extfile-client.cnf
chmod -v 0400 ca-key.pem key.pem server-key.pem
sudo dockerd --tlsverify --tlscacert=ca.pem --tlscert=server-cert.pem --tlskey=server-key.pem -H=0.0.0.0:2376
```

client 端
???


1.生成CA私钥ca-key.pem，使用该私钥对CA证书签名。
ca-key.pem是一个临时文件，最后可以删除。
```
openssl genrsa -out ~/docker/ca-key.pem 4096
```

2.使用CA私钥生成自签名CA证书ca.pem。生成证书时，通过-days 365设置证书的有效期。单位为天，默认情况下为30天。ssl.conf = -subj
```
openssl req -x509 -sha256 -batch -new -days 365 -key ~/docker/ca-key.pem -out ~/docker/ca.pem -config ssl.conf
```

3.生成服务器私钥server-key.pem和CSR(Certificate Signing Request)server-csr.pem。CN为DockerDaemon。
server-csr.pem是一个临时文件，生成server-cert.pem以后，可以删除。
```
openssl genrsa -out ~/docker/server-key.pem 4096
openssl req -subj '/CN=DockerDaemon' -sha256 -new -key ~/docker/server-key.pem -out ~/docker/server-csr.pem
```

4.使用CA证书生成服务器证书server-cert.pem。TLS连接时，需要限制客户端的IP列表或者域名列表。只有在列表中的客户端才能通过客户端证书访问Docker Daemon。在本例中，只允许127.0.0.1和192.168.1.100的客户端访问。如果添加0.0.0.0，则所有客户端都可以通过证书访问Docker Daemon。
allow.list是一个临时文件，生成server-cert.pem以后，可以删除。
```
echo subjectAltName = IP:127.0.0.1,IP:192.168.1.100 > ~/docker/allow.list
openssl x509 -req -days 365 -sha256 -in ~/docker/server-csr.pem -CA ~/docker/ca.pem -CAkey ~/docker/ca-key.pem -CAcreat eserial -out ~/docker/server-cert.pem -extfile ~/docker/allow.list
```

5.生成客户端私钥client-key.pem和CSRclient-csr.pem。CN为DockerClient。
client-csr.pem是一个临时文件，生成client-cert.pem以后，可以删除。
```
openssl genrsa -out ~/docker/client-key.pem 4096
openssl req -subj '/CN=DockerClient' -new -key ~/docker/client-key.pem -out ~/docker/client-csr.pem
```

6.使用CA证书生成客户端证书client-cert.pem。需要加入extendedKeyUsage选项。
```
echo extendedKeyUsage = clientAuth > ~/docker/options.list
openssl x509 -req -days 365 -sha256 -in ~/docker/client-csr.pem -CA ~/docker/ca.pem -CAkey ~/docker/ca-key.pem -CAcreat eserial -out ~/docker/client-cert.pem -extfile ~/docker/options.list
```

7.成功生成了需要的证书和秘钥，可以删除临时文件。
```
rm -f ~/docker/server-csr.pem ~/docker/client-csr.pem ~/docker/allow.list ~/docker/options.list
```

8.为了保证证书和私钥的安全，需要修改文件的访问权限。
```
chmod 0444 ~/docker/ca.pem ~/docker/server-cert.pem ~/docker/client-cert.pem
chmod 0400 ~/docker/ca-key.pem ~/docker/server-key.pem ~/docker/client-key.pem
```

9.重启Docker Daemon，加入ca.pem、server-cert.pem和server-key.pem。-H=0.0.0.0:2376表示Docker Daemon监听在2376端口。 
```
docker daemon –tlsverify –tlscacert=~/docker/ca.pem –tlscert=~/docker/server-cert.pem –tlskey=~/docker/server-key.pem -H=0.0.0.0:2376
```

10.在客户端，运行docker命令时，加入ca.pem、client-cert.pem和client-key.pem。本例中，只有127.0.0.1和192.168.1.100的客户端可以访问Docker Daemon。
```
docker --tlsverify --tlscacert=~/docker/ca.pem --tlscert=~/docker/client-cert.pem --tlskey=~/docker/client-key.pem -H=tcp:// 127.0.0.1:2376 info
```
```
Containers: 41 Running: 16 Paused: 0 Stopped: 25 Images: 821 Server Version: 1.10.3
```
