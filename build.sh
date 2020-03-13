#!/bin/sh

NGINX_VERSION=1.17.9
NODE_VERSION=v12.16.1

NGINX=nginx-${NGINX_VERSION}
NODE=node-${NODE_VERSION}-linux-x64
NGINX_PACKAGE=${NGINX}.tar.gz
NODE_PACKAGE=${NODE}.tar.xz

yum -y update
yum -y install wget gcc pcre pcre-devel openssl openssl-devel libxml2-devel libxslt-devel

# install node.js
#if [ ! -f ${NODE_PACKAGE} ]; then
#    wget https://nodejs.org/dist/${NODE_VERSION}/${NODE_PACKAGE}
#fi

#tar -vxf ${NODE_PACKAGE}
#mv ${NODE}/ node/

#export PATH=$PATH/app/node/bin


if [ ! -d build ]; then
    mkdir build
fi

# 
cd build

if [ ! -f ${NGINX_PACKAGE} ]; then
    wget http://nginx.org/download/${NGINX_PACKAGE}
fi


if [ ! -d v1.2.1.zip ]; then
    wget https://github.com/arut/nginx-rtmp-module/archive/v1.2.1.zip
fi

tar -xvf ${NGINX_PACKAGE}
tar -xvf v1.2.1.zip

# build openresty
cd ${NGINX}

./configure --prefix=/usr/local/nginx --add-module=../nginx-rtmp-module-1.2.1 --with-http_ssl_module

make
make install

cd ..

cd ..

# copy config files
cp ./conf/nginx.conf /usr/local/nginx/conf/nginx.conf


# start openresty
/usr/local/nginx/sbin/nginx


# start node app
#/app/node/bin/node /app/backend/app.js

