FROM ubuntu:20.04 as build
LABEL maintainer="Yino <m15829090357@163.com>"

RUN sed -i 's/snapshot.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    apt-get update

RUN apt-get install -y libpcre3-dev libssl-dev perl make build-essential curl wget

RUN cd ~/ && wget https://openresty.org/download/openresty-1.19.9.1.tar.gz && tar -xzvf openresty-1.19.9.1.tar.gz && cd openresty-1.19.9.1 && ./configure --without-http_gzip_module && make && make install

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime


## 工作目录
WORKDIR /root/nginx
