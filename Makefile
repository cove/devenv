
all:
	@echo "up      - start up devenv"
	@echo "down    - shutdown devenv"
	@echo "rebuild - rebuild devenv containers"
	@echo "tests   - run tests in projects"
	@echo "link    - link client and server"
	@echo "clean   - clean up old dev docker images"

down:
	@docker-compose down
up: 
	@docker-compose up --abort-on-container-exit
rebuild:
	@docker-compose build --pull
tests:
	@docker exec -t devenv_h_1 /bin/sh -c "make test"
	@docker exec -t devenv_client_1 /bin/sh -c "make test"
	@docker exec -t devenv_browser-extension_1 /bin/sh -c "make test"
link:
	@docker exec -t devenv_client_1 /bin/sh -c "npm link"
	@docker exec -t devenv_h_1 /bin/sh -c "npm link hypothesis"
clean:
	@docker rmi `docker images -q` ; exit 0

