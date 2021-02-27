#!/bin/bash

# if detect 'install' in arguments, start kind cluster before ct. elsewhere just run ct as it called

stringContain() { [ -z "$1" ] || { [ -z "${2##*$1*}" ] && [ -n "$2" ];};}
if stringContain "install" "$2" ; then exec /entrypoint-kind.sh "$@" ; else cd /data && exec "$@"; fi


# if [ -z "${string##*$reqsubstr*}" ] ;then
#     echo "'install' within parameter detected, so start cluster first"
#     # exec /entrypoint-kind.sh echo "Cluster started"
#   else
#     echo "String '$string' don't contain substring: '$reqsubstr'."
# fi

# exec "$@"
