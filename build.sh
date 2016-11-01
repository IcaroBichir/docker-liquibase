#!/bin/sh -e

LIQUIBASE=${1}
POSTGRES=${2}

docker build \
	--build-arg http_proxy \
	--build-arg https_proxy \
	--build-arg no_proxy \
	--build-arg LIQUIBASE_VERSION=${LIQUIBASE} \
	--build-arg POSTGRES_VERSION=${POSTGRES} \
	--tag aetheric/liquibase:${LIQUIBASE}-postgres-${POSTGRES} \
	--tag aetheric/liquibase:${LIQUIBASE}-postgres \
	--tag aetheric/liquibase:postgres-${POSTGRES} \
	--tag aetheric/liquibase:postgres \
	.

