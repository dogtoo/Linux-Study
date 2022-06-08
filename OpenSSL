https://www.imnobby.com/2017/09/20/%E6%96%BC-ubuntu-%E8%A8%AD%E5%AE%9A-lets-encrypt-%E5%85%8D%E8%B2%BB-ssl-%E7%B6%B2%E7%AB%99%E8%AD%89%E6%9B%B8/
1. 安裝 certbot
  sudo add-apt-repository ppa:certbot/certbot
  sudo apt-get update
  sudo apt-get install python-certbot-apache
2. 網域申請及建立 SSL 證書
  sudo certbot --apache -d dogtoo.mynetgear.com
  開始問問題
    email
    
3. ssl ca create
ca data setting file ssl.conf
```
[req]
prompt = no
default_md = sha256
default_bits = 2048
distinguished_name = dn
x509_extensions = v3_req

[dn]
C = TW
ST = Taiwan
L = Taipei
O = dgoc.
OU = IT Department
emailAddress = dgoc@example.com
CN = localhost

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.localhost
DNS.2 = localhost
IP.1 = 192.168.59.109
```

run openssl : gen ca key, cert
```
openssl req -x509 -new -nodes -sha256 -utf8 -days 3650 -newkey rsa:2048 -keyout server.key -out server.cert -config ssl.conf
```
