FROM node:18.2.0

ENV NPM_CONFIG_LOGLEVEL error

# Install development packages
RUN apt-get update && apt-get install build-essential curl -y

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN apt-get update \
  && apt-get install -y wget gnupg \
  && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
  && apt-get update \
  && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
  && apt-get install -y build-essential chrpath libssl-dev libxft-dev \
  && apt-get install -y libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev \
  && wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
  && tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/ \
  && ln -sf /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin

RUN line="openssl_conf = default_conf"; sed -i "/^$line/ c#$line" /etc/ssl/openssl.cnf

# Fix Debian vulnerabilities
RUN DEBIAN_FRONTEND=noninteractive && \
  DEBIAN_PRIORITY=critical && \
  apt-get -q -y -o "Dpkg::Options::=--force-confold" dist-upgrade

RUN yarn config set ignore-engines true
