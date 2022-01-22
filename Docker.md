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
