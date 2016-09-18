
all:
	@echo "up      - start up devenv"
	@echo "down    - shutdown devenv"
	@echo "rebuild - rebuild devenv containers"

down:
	docker-compose down
up: 
	docker-compose up --abort-on-container-exit
rebuild:
	docker-compose build --force-rm --pull

