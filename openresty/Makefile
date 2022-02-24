TARGETS := openresty
default:
	@echo "$(TARGETS)"
up:
	docker-compose up
start:
	docker-compose up -d --force-recreate --build
stop:
	docker-compose stop
restart:
	docker-compose restart
ps:
	docker-compose ps
bash:
	docker-compose exec openresty bash
build:
	docker build -t yino/openresty .
log:
	docker-compose logs
