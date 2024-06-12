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
```
生成CA证书时，需要提供一些公司信息。
C表示国家，中国为CN。
ST表示省，比如Sichuan。
L表示城市，比如Chengdu。
O表示公司，比如Ghostcloud Co.,Ltd。
OU表示部门名字，比如Laboratory。
CN表示公司域名，比如www.ghostcloud.cn。
```


run openssl : gen ca key, cert
```
openssl req -x509 -new -nodes -sha256 -utf8 -days 3650 -newkey rsa:2048 -keyout server.key -out server.cert -config ssl.conf
```

4. 在本機手動加ca.crt( ca.cert,ca.pem 是相同的，指的是 BEGIN CERTIFICATE那段)
將對方server的憑證先放到 /usr/local/share/ca-certificates
執行 sudo update-ca-certificates
檢核 /etc/ssl/certs/ca-certificates.crt 是不是有加入新ca

 
==========================================
gca 憑證

1. 產生請求檔
```
openssl genrsa -des3 -out server.key 2048 
openssl req -new -key server.key -out certreq.txt -config ssl.conf
```
2. 交由gca申請人將 certreq.txt (CSR) 上傳，並告知簽章的domain
3. 申請成功後取得 server.cer (CER)
4. 將 cer 轉成 crt
```
openssl x509 -in server.cer -out server.cert -inform der
```
5. 與gca的中間憑證合併，中間憑證要放後面
```
cat server.cert ../eCA1_GTLSCA.crt > server.pem
```
