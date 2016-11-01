FROM java:8-jre-alpine

# Install packages only needed for build
RUN apk --no-cache add --virtual .build-dependencies \
	curl

# Pick a version, any version.
ARG LIQUIBASE_VERSION

# These aren't really arguments. More like variables.
ARG LIQUIBASE_HOST=https://github.com
ARG LIQUIBASE_PATH=${LIQUIBASE_HOST}/liquibase/liquibase/releases/download
ARG LIQUIBASE_PARENT=${LIQUIBASE_PATH}/liquibase-parent-${LIQUIBASE_VERSION}
ARG LIQUIBASE_NAME=liquibase-${LIQUIBASE_VERSION}-bin
ARG LIQUIBASE_FILE=${LIQUIBASE_NAME}.tar.gz

WORKDIR ~

# Install liquibase
RUN pwd \
	&& curl -fo ${LIQUIBASE_FILE} ${LIQUIBASE_PARENT}/${LIQUIBASE_FILE} \
	&& tar -xzf ${LIQUIBASE_FILE} \
	&& rm -f ${LIQUIBASE_FILE} \
	&& mv ${LIQUIBASE_NAME} /opt/liquibase \
	&& chmod +x /opt/liquibase/liquibase
	&& ln -s /opt/liquibase/liquibase /usr/local/bin/

# Version for postgres required.
ARG POSTGRES_VERSION

# These aren't really arguments. More like variables.
ARG POSTGRES_DIST_HOST=http://jdbc.postgresql.org
ARG POSTGRES_DIST_PATH=${POSTGRES_HOST}/download
ARG POSTGRES_DIST_NAME=postgresql-${POSTGRES_VERSION}
ARG POSTGRES_DIST_FILE=${POSTGRES_NAME}.jar

# Install postgres driver
RUN pwd \
	&& mkdir /opt/jdbc_drivers \
	&& curl -fO ${POSTGRES_DIST_PATH}/${POSTGRES_DIST_FILE} \
	&& mv ${POSTGRES_DIST_FILE} /opt/jdbc_drivers/
	&& ln -s /opt/jdbc_drivers/${POSTGRES_DIST_FILE} /usr/local/bin/

# Clean up build dependencies.
RUN apk del .build-dependencies

# Where the liquibase changes get written
VOLUME [ "~/changelogs" ]

# Set up default commands
CMD [ "liquibase", "--version" ]
ENTRYPOINT [ "liquibase" ]

# This container works when liquibase is available
HEALTHCHECK --interval=5m --timeout=3s \
		CMD which liquibase || exit 1

