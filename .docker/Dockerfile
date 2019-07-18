FROM ruby:2.6-slim-stretch
ENV DEBIAN_FRONTEND=noninteractive
ENV SUDO="gosu postal"

RUN \
    # Install Packages via apt
    apt-get -y update \
	&& apt-get -y install \
        nodejs \
        mysql-client  \
        git-core \
        libcap2-bin \
        gosu \
        bash \
        build-essential \
        default-libmysqlclient-dev \
    # Install Gems
    && gem install \
        bundler \
	    procodile \
	# Add User
    && useradd -r -d /opt/postal -s /bin/bash postal \
	# Clone postal repository
    && git clone https://github.com/atech/postal.git /opt/postal/app \
    # Add symbolic link for path variable
    && ln -s /opt/postal/app/bin/postal /usr/bin/postal \
    # Adjust permissions
    && setcap 'cap_net_bind_service=+ep' /usr/local/bin/ruby \
    # # Add Postal dependencies from own repository
    && /opt/postal/app/bin/postal bundle /opt/postal/app/vendor/bundle \
    # Adjust user permissions
    && chown -R postal:postal /opt/postal/ \
    # Clean Up
    && apt-get -y purge \
        python-dev  \
        #git-core \
        build-essential \
	    && apt-get -y autoremove \
	    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 
    

## Stick in required files
COPY files/docker-entrypoint.sh /docker-entrypoint.sh
COPY files/update_postal_config /usr/local/bin/

## Workdir
WORKDIR /opt/postal

## User Change
#USER postal

## Expose
EXPOSE 5000 25

## Startup
#ENTRYPOINT ["/docker-entrypoint.sh"]


#### Labels
ARG VCS_REF="$TRAVIS_COMMIT" 
ARG GIT_REPO="https://github.com/$TRAVIS_REPO_SLUG" 
ARG BUILD_DATE="$(date -u +"%Y-%m-%d")"
ARG NAME="Postal-in-Docker"
ARG VENDOR="Postal Mainainer"
ENV BUILD_DATE=${BUILD_DATE}

LABEL org.label-schema.build-date="${BUILD_DATE}" \
        org.label-schema.name="${NAME}" \
        org.label-schema.vcs-ref="${VCS_REF}" \
        org.label-schema.vcs-url="${GIT_REPO}" \
        org.label-schema.url="${GIT_REPO}" \
        org.label-schema.vendor="${VENDOR}" \
        org.label-schema.version="${VCS_REF}" \
        org.label-schema.schema-version="1.0.0-rc1"

LABEL   org.opencontainers.image.created="${BUILD_DATE}" \
        org.opencontainers.image.url="${GIT_REPO}" \
        org.opencontainers.image.source="${GIT_REPO}" \
        org.opencontainers.image.version="${VCS_REF}" \
        org.opencontainers.image.revision="${VCS_REF}" \
        org.opencontainers.image.vendor="${VENDOR}" \
        org.opencontainers.image.title="${NAME}"
