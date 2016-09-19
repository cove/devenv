
all:
	@echo "up      - start up devenv"
	@echo "down    - shutdown devenv"
	@echo "rebuild - rebuild devenv containers"
	@echo "tests   - run tests in projects"

down:
	docker-compose down
up: 
	docker-compose up --abort-on-container-exit
rebuild:
	docker-compose build --pull
tests:
	docker exec -t devenv_h_1 /bin/sh -c "make test"
	docker exec -t devenv_client_1 /bin/sh -c "make test"
