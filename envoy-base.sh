#!/bin/bash

set -e

ENVOY_CPU_SET=${ENVOY_CPU_SET:=8}
ENVOY_CONCURRENCY=${ENVOY_CONCURRENCY:=4}
ENVOY_BIN=/home/luyaozho/teresa/use-hugepage-envoy/base/envoy-static
ENVOY_CONFIG=/home/luyaozho/teresa/use-hugepage-envoy/envoy-demo.yaml
# mkdir -p $BASE_DIR
# ulimit -n 1048576

sudo taskset -c ${ENVOY_CPU_SET} ${ENVOY_BIN} --config-path ${ENVOY_CONFIG} --concurrency $ENVOY_CONCURRENCY > ./envoy.log 2>&1 &
echo "$!" > envoy.pid
echo "envoy started"

# sudo taskset -c 4 /home/luyaozho/teresa/use-hugepage-envoy/base/envoy-static --config-path /home/luyaozho/teresa/use-hugepage-envoy/envoy-demo.yaml --concurrency 4 > ./envoy.log 2>&1 &