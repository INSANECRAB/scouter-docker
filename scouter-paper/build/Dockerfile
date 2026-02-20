FROM nginx:1.17.0-alpine
## url setting
LABEL maintainer="sypark90@gmail.com"
ARG PAPER_VERSION=${PAPER_VERSION:-2.6.4}
ARG INSTALL_URL=https://github.com/scouter-contrib/scouter-paper/releases/download/${PAPER_VERSION}/scouter-paper-v${PAPER_VERSION}.zip
RUN mkdir -p /var/www;
COPY default.conf /etc/nginx/conf.d/default.conf
## install
WORKDIR /var/www
RUN apk add -U tzdata wget unzip;cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime; wget ${INSTALL_URL};unzip scouter-paper-v${PAPER_VERSION}.zip;rm -f scouter-paper-v${PAPER_VERSION}.zip
