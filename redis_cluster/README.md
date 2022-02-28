# 分布式redis


#### 步骤执行
```shell
  #创建6个redis 3主3从
    make start  
    #查看容器列表
    make ps 
    # 查看ip
	docker inspect -f "{{.Name}} - {{.NetworkSettings.Networks.redis_cluster_redisNetwork.IPAddress }} - {{.NetworkSettings.Ports}}" $(docker ps -aq)
     #进入redis-node-1 容器（可随意进入任意redis容器，举例为redis-node-1）
    make bash  
    # 分槽 建立主从关系
    redis-cli --cluster create 192.18.0.2:6361 192.18.0.3:6362 192.18.0.4:6363 192.18.0.5:6364 192.18.0.6:6365 192.18.0.7:6366 --cluster-replicas 1
    
```
#### redis命令

