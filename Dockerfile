FROM node:14

ENV NPM_CONFIG_LOGLEVEL error

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV CHROMIUM_PATH /usr/bin/chromium-browser

# Install development packages
RUN apt-get update && apt-get install build-essential chromium curl -y

# Fix Debian vulnerabilities
RUN DEBIAN_FRONTEND=noninteractive && \
  DEBIAN_PRIORITY=critical && \
  apt-get -q -y -o "Dpkg::Options::=--force-confold" dist-upgrade

RUN yarn config set ignore-engines true