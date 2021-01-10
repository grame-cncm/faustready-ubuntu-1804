build:
	docker build --squash -t grame/faust .

push:
	docker push grame/faust

test:
	docker run grame/faust

help:
	@echo " 'build' : builds the docker image"
	@echo " 'test'  : run the docker image, equivalent to faust -v"
	@echo " 'push'  : push the docker image to docker repository"
 