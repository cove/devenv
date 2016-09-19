
all: help

.PHONY: down
down:
	@docker-compose down

.PHONY: up
up: 
	@docker-compose up

.PHONY: rebuild
rebuild:
	@docker-compose build --pull

.PHONY: tests
tests: test-h test-client test-browser-extension

.PHONY: link
link:
	@docker exec -t devenv_client_1 /bin/sh -c "npm link"
	@docker exec -t devenv_h_1 /bin/sh -c "npm link hypothesis"

.PHONY: clean
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

# Self documenting Makefile
.PHONY: help
help:
	@echo "The following targets are available:"
	@echo " up         Run the development server and client locally"
	@echo " down       Shutdown the development server and client"
	@echo " rebuild    Rebuild the develoment environment containers"
	@echo " link       Link the server and client"
	@echo " tests      Run the test suites (-j to paralleize)"
	@echo " clean      Clean up runtime artifacts (orphen docker images)"

