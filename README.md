# canal-helm


# 已知问题

开启HA 模式 需要手动重启集群，即重新保存主配置，不然 canal server 会不停自动重启 canal admin 并报
```
connect to ip:canal-server-0.canal-server-headless.canal,port:11110,user:admin,password:******, failed
```