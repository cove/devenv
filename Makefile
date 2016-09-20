
DOCKER_RUN := docker run --network=devenv_default --env-file devenv.env

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
	@$(DOCKER_RUN) --volume `pwd`/../client:/client -t devenv_client /bin/sh -c "npm link"
	@$(DOCKER_RUN) --volume `pwd`/../h:/h -t devenv_h /bin/sh -c "npm link hypothesis"

.PHONY: unlink
unlink:
	@$(DOCKER_RUN) --volume `pwd`/../h:/h -t devenv_h /bin/sh -c "npm unlink -g hypothesis; make clean"

.PHONY: clean
clean:
	@docker rmi `docker images -q` ; exit 0

.PHONY: clobber
clobber:
	@docker rmi -f `docker images -q`; exit 0
	@docker rm -f `docker ps -aq`; exit 0
	@cd ../h && sudo make clean
	@cd ../client && sudo make clean
	@cd ../browser-extension && sudo make clean

################################################################################

test-h::
	@$(DOCKER_RUN) -t --volume `pwd`/../h:/h devenv_h /bin/sh -c "make test"

test-client::
	@$(DOCKER_RUN) -t --volume `pwd`/../client:/client devenv_client /bin/sh -c "make test"

test-browser-extension::
	@$(DOCKER_RUN) -t --volume `pwd`/../browser-extension:/browser-extension devenv_browser-extension /bin/sh -c "make test"

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
	@echo " clobber    Delete all docker and build data"

