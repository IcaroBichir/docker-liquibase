#!/bin/sh -e

VERSION=${1}

docker build \
	--build-arg http_proxy \
	--build-arg https_proxy \
	--build-arg no_proxy \
	--build-arg LIQUIBASE_VERSION=${VERSION} \
	--tag aetheric/liquibase:${VERSION} \
	--tag aetheric/liquibase:latest \
	.
