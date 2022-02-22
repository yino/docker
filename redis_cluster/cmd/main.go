package main

import (
	"context"
	"fmt"
	"time"

	redis "github.com/go-redis/redis/v8"
)

type Cache interface {
	Get(key string) (string, error)
	Set(key string, value interface{}, expireTime time.Duration) (string, error)
}

type Redis struct {
	Cluster *redis.ClusterClient
	Ctx     context.Context
}

func (r *Redis) Get(key string) (string, error) {
	return r.Cluster.Get(r.Ctx, key).Result()
}

func (r *Redis) Set(key string, value interface{}, expireTime time.Duration) (string, error) {
	return r.Cluster.Set(r.Ctx, key, value, expireTime).Result()
}

func NewRedisCluster() *Redis {
	Cluster := redis.NewClusterClient(&redis.ClusterOptions{
		Addrs: []string{
			"127.0.0.1:6361",
			"127.0.0.1:6362",
			"127.0.0.1:6363",
			"127.0.0.1:6364",
			"127.0.0.1:6365",
			"127.0.0.1:6366",
		},
		DialTimeout:  100 * time.Microsecond,
		ReadTimeout:  100 * time.Microsecond,
		WriteTimeout: 100 * time.Microsecond,
	})

	ctx := context.Background()
	return &Redis{
		Cluster: Cluster,
		Ctx:     ctx,
	}
}

func main(){
	redisClu := NewRedisCluster()
	fmt.Println(redisClu.Set("test_key","1008",100))
	fmt.Println(redisClu.Get("test_key"))
}