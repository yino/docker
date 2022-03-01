TARGETS := redis-cluster
default:
	@echo "$(TARGETS)"
up:
	docker-compose up
run:
	rm -r ./node-1/data/ ./node-2/data/ ./node-3/data/ ./node-4/data/ ./node-5/data/ ./node-6/data/ && docker-compose up -d --force-recreate
start:
	docker-compose up -d
stop:
	docker-compose stop
restart:
	docker-compose restart
ps:
	docker-compose ps
bash:
	docker-compose exec redis-node-1 bash

log:
	docker-compose logs

clearConf:
	rm -r ./node-1/data/ ./node-2/data/ ./node-3/data/ ./node-4/data/ ./node-5/data/ ./node-6/data/

network:
	docker inspect -f "{{.Name}} - {{.NetworkSettings.Networks.redis_cluster_redisNetwork.IPAddress }}" $(docker ps -aq)
