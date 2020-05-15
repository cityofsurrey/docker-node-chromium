FROM node:14-alpine

ENV NPM_CONFIG_LOGLEVEL error

# Install development packages
RUN apk add --no-cache --update bash curl git openssh tzdata chromium
RUN apk update && apk upgrade && rm -rf /var/cache/apk/*

RUN yarn config set ignore-engines true
