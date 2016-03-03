#!/bin/sh
set -x
PROXY_URL=

if wget --spider --timeout 1 --tries 1 http://192.168.11.6:3142/acng-doc/ ; then
    PROXY_URL=http://192.168.11.6:3142/
elif http_proxy=http://192.168.11.4:3128/ wget --spider --timeout 1 --tries 1 http://jschule.github.io/ubuntu/ ; then
    PROXY_URL=http://192.168.11.4:3128/
fi

if test "$PROXY_URL" ; then
    echo Setting proxy to $PROXY_URL
    debconf-set mirror/http/proxy $PROXY_URL
fi
