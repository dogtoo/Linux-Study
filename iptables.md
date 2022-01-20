iptables -vL INPUT -n --line-numbers
iptables -t filter -vL -n --line-numbers

--verbose     -v              verbose mode
--list        -L              [chain [rulenum]]
--numeric     -n              numeric output of addresses and ports
--line-numbers                print line numbers when listing
--table       -t table        table to manipulate (default: `filter')

INPUT | OUTPUT | ... <-- filter

del one line number
iptables -D [filter name] [x] 

顯示連進32769 port的資訊
```
sudo tcpdump -nS dst port 32769
```

將某個port 開給某網段使用
```
sudo iptables -A INPUT -p tcp --dport 2375 -s 192.168.1.0/24 -j ACCEPT
```
# 這是打開讓自己網域可以方便連結，也就是該網域不設防
```
iptables -A INPUT -p all -s 192.168.0.0/255.255.255.0 -j ACCEPT
```

# 防止別人用ACK、SYN、FIN等等的封包來掃瞄 Linux
```
iptables -A INPUT -i eth0 -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
```

# NAT
```
iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -j MASQUERADE
```
不過此時 ftp 會無法正常運作,必須另外再加上
```
modprobe ip_conntrack_ftp
modprobe ip_nat_ftp
```
另外可以配合 proxy server,強制每台 client 端均透過 proxy 連線
```
iptables -t nat -I PREROUTING -i eth0 -p tcp -s 192.168.0.0/255.255.255.0 -d 192.168.0.113 --dport 80 -j ACCEPT
iptables -t nat -A PREROUTING -i eth0 -p tcp -s 192.168.0.0/24 --dport 80 -j REDIRECT --to-port 3128
```

# 限制連線條件
```
iptables -A FORWARD -p TCP -s 11.22.33.44 -d 44.33.22.11 -j DROP
```
從 11.22.33.44 的 port 1024-65535 連線到 44.33.22.11 的 port 80 ,一律檔掉!!
```
iptables -A FORWARD -p TCP -s 11.22.33.44 --sport 1024:65535 -d 44.33.22.11 --dport www -j DROP
```

# 防止 port scan
```
## NMAP FIN/URG/PSH
iptables -A INPUT -i eth0 -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP
## Xmas Tree
iptables -A INPUT -i eth0 -p tcp --tcp-flags ALL ALL -j DROP
## Another Xmas Tree
iptables -A INPUT -i eth0 -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
## Null Scan(possibly)
iptables -A INPUT -i eth0 -p tcp --tcp-flags ALL NONE -j DROP
## SYN/RST
iptables -A INPUT -i eth0 -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
## SYN/FIN -- Scan(possibly)
iptables -A INPUT -i eth0 -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
```

# 防止 sync flood 攻擊的設定:
```
iptables -N synfoold
iptables -A synfoold -p tcp --syn -m limit --limit 1/s -j RETURN
iptables -A synfoold -p tcp -j REJECT --reject-with tcp-reset
iptables -A INPUT -p tcp -m state --state NEW -j synfoold
```
不過流量一大就不太好了!!
所以可以調整時間與次數的觸發值
```
iptables -N ping
iptables -A ping -p icmp --icmp-type echo-request -m limit --limit 1/second -j RETURN
iptables -A ping -p icmp -j REJECT
iptables -I INPUT -p icmp --icmp-type echo-request -m state --state NEW -j ping
```

# 將 WWW Server 藏到 192.168.0.1 , 但是希望 Internet 的其他 user ,輸入 http://11.22.33.44/ 能夠看到 192.168.0.1 的網頁內容

```
#!/bin/sh
# Dec,11,2002 Wed Anderson add for testing

# load modules if necessary
modprobe ip_tables
modprobe ip_conntrack
modprobe ip_conntrack_ftp
modprobe ip_conntrack_irc

# disable all chains
iptables -F
iptables -t nat -F
iptables -t mangle -F

# disable forward chain
# iptables -P FORWARD DROPecho "1" > /proc/sys/net/ipv4/ip_forward
iptables -P FORWARD ACCEPT
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT

# alloe all localhost
iptables -A INPUT -i lo -j ACCEPT

# allow specical IP
# iptables -A INPUT -p tcp -d 192.168.0.1 -j ACCEPT

# allow ssh
iptables -A INPUT -i eth0 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -i eth1 -p tcp --dport 22 -j ACCEPT

# allow http
iptables -A INPUT -i eth0 -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -i eth1 -p tcp --dport 80 -j ACCEPT

# allow old connection and deny new connection
iptables -A INPUT -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -m state --state NEW,INVALID -j DROP
iptables -A INPUT -i eth1 -m state --state NEW,INVALID -j DROP

# setup DMZ -- DNAT
iptables -A PREROUTING -t nat -i eth0 -p tcp -d 11.22.33.44 --dport 80 -j DNAT --to-destination 192.168.0.1:80

# open DMZ goto Internet
iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -j MASQUERADE
```
