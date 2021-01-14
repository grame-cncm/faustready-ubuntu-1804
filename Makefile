REPO = "grame/faustready-ubuntu-1804"

build:
	docker build -t $(REPO) .

push:
	docker push $(REPO)

test:
	docker run -it $(REPO) bash

help:
	@echo " 'build' : builds the docker image"
	@echo " 'test'  : run the docker image, equivalent to faust -v"
	@echo " 'push'  : push the docker image to docker repository"
 