# 分布式redis


#### 步骤执行
```shell
  #创建6个redis 3主3从
    make start  
    #查看容器列表
    make ps 
     #进入redis-node-1 容器（可随意进入任意redis容器，举例为redis-node-1）
    make bash  
    # 分槽 建立主从关系
    redis-cli --cluster create 10.96.65.220:6361 10.96.65.220:6362 10.96.65.220:6363 10.96.65.220:6364 10.96.65.220:6365 10.96.65.220:6366 --cluster-replicas 1
    
```
#### redis命令

