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
sudo dockerd -H unix:///var/run/docker.sock -H tcp://192.168.59.106 &
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
