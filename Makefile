
all:
	@echo "up      - start up devenv"
	@echo "down    - shutdown devenv"
	@echo "rebuild - rebuild devenv containers"
	@echo "tests   - run tests in projects, -j to parallelize"
	@echo "link    - link client and server"
	@echo "clean   - clean up old dev docker images"

down:
	@docker-compose down
up: 
	@docker-compose up
rebuild:
	@docker-compose build --pull

tests: test-h test-client test-browser-extension

link:
	@docker exec -t devenv_client_1 /bin/sh -c "npm link"
	@docker exec -t devenv_h_1 /bin/sh -c "npm link hypothesis"
clean:
	@docker rmi `docker images -q` ; exit 0

################################################################################

test-h::
	@docker exec -t devenv_h_1 /bin/sh -c "make test"

test-client::
	@docker exec -t devenv_client_1 /bin/sh -c "make test"

test-browser-extension::
	@cd ../browser-extension && \
          docker run -t --volume `pwd`:/browser-extension devenv_browser-extension /bin/sh -c "make test"

