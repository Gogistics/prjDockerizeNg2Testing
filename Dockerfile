# Grep base image of Debian Jessie
FROM  debian:jessie

# maintainer
MAINTAINER  Alan Tai <alan.tai@riverbed.com>

# general env. variables
ENV NG_CLI_VERSION="1.0.0-rc.4"
ENV USER_HOME_DIR="/app/"
ENV NPM_CONFIG_LOGLEVEL warn
ENV LANG C.UTF-8

# env. variables reladted to java
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV JAVA_VERSION 8u121
ENV JAVA_DEBIAN_VERSION 8u121-b13-1~bpo8+1
ENV CA_CERTIFICATES_JAVA_VERSION 20161107~bpo8+1

# add xvfb
ADD xvfb-chromium /usr/bin/xvfb-chromium

# Commands
RUN apt-get update && \
    set -xe && \
    apt-get -y install apt-utils curl nano git sudo build-essential chromium xvfb bzip2 unzip xz-utils && \
    curl -sL https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 > /usr/bin/dumb-init && \
    chmod +x /usr/bin/dumb-init && \
    curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash - && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs && \
    apt-get update && \
    npm install @angular/cli@${NG_CLI_VERSION} -g && \
    ln -s /usr/bin/xvfb-chromium /usr/bin/google-chrome && \
    ln -s /usr/bin/xvfb-chromium /usr/bin/chromium-browser && \
    rm -rf /var/lib/apt/lists/*

RUN echo 'deb http://deb.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list

# for e2e
RUN { echo '#!/bin/sh'; \
      echo 'set -e'; \
      echo; \
      echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
    } > /usr/local/bin/docker-java-home \
    && chmod +x /usr/local/bin/docker-java-home

RUN set -x \
    && apt-get update \
    && apt-get install -y \
      openjdk-8-jdk="$JAVA_DEBIAN_VERSION" \
      ca-certificates-java="$CA_CERTIFICATES_JAVA_VERSION" \
    && rm -rf /var/lib/apt/lists/* \
    && [ "$JAVA_HOME" = "$(docker-java-home)" ]

RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure


# work dir
WORKDIR ${USER_HOME_DIR}

# set dumb-init as entrypoint
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
