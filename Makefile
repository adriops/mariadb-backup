build:
	bin/docker-build.sh

push:
	bin/docker-build.sh
	bin/push-sevenops.sh
