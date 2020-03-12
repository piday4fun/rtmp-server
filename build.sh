#!/bin/sh

OPENRESTY_VERSION=1.15.8.2
NODE_VERSION=v12.16.1

OPENRESTY_PACKAGE=openresty-${OPENRESTY_VERSION}.tar.gz
NODE_PACKAGE=node-${NODE_VERSION}-linux-x64.tar.xz

yum -y update
yum -y install wget gcc pcre pcre-devel openssl openssl-devel libxml2-devel libxslt-devel perl-ExtUtils-Embed

# install node.js
if [ ! -f ${NODE_PACKAGE} ]; then
    wget https://nodejs.org/dist/${NODE_VERSION}/${NODE_PACKAGE}
fi

tar -vxf ${NODE_PACKAGE}
mv node-${NODE_VERSION}-linux-x64/ node/

export PATH=$PATH/app/node


if [ ! -d build ]; then
    mkdir build
fi

# 
cd build

if [ ! -f ${OPENRESTY_PACKAGE} ]; then
    wget https://openresty.org/download/${OPENRESTY_PACKAGE}
fi

if [ ! -f 2.3.tar.gz ]; then
    wget https://github.com/FRiCKLE/ngx_cache_purge/archive/2.3.tar.gz
fi

if [ ! -f v1.2.1.tar.gz ]; then
    wget https://github.com/arut/nginx-rtmp-module/archive/v1.2.1.tar.gz
fi

tar -xvf ${OPENRESTY_PACKAGE}
tar -xvf v1.2.1.tar.gz -C openresty-1.15.8.2/bundle
tar -xvf 2.3.tar.gz  -C openresty-1.15.8.2/bundle

# build openresty
cd openresty-1.15.8.2

./configure --prefix=/opt/openresty \ 
    --with-luajit --with-http_ssl_module \
    --user=root --group=root \
    --with-http_realip_module \
    --add-module=./bundle/ngx_cache_purge-2.3 \
    --add-module=./bundle/nginx-rtmp-module-1.2.1 \
    --with-http_xslt_module \
    --with-http_stub_status_module \
    --with-http_gzip_static_module \
    --with-http_flv_module \
    --with-http_perl_module \
    --with-mail

make
make install

cd ..

cd ..

# copy config files
cp ./config/nginx.conf /opt/openresty/nginx/conf/nginx.conf
cp ./config/openresty.service //usr/lib/systemd/system/

# start openresty
systemctl enable openresty
systemctl start openresty

# start node app
/app/node/node /app/backend/app.js

