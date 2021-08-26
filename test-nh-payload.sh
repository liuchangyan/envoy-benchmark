#!/bin/bash

iterations="$1"

path=`dirname $0`
path=`cd "$path"; pwd`
echo $path

cd "$path"
declare bsize=0

for ((i=42;i<=iterations;i++));
do
    declare sum=0
    let bsize=$i*1024

    echo "Testing envoy performance using nighthawk request per second is  "$bsize" ... "
    for((j=1; j<=3; j++))
    do
	 taskset -c 11-13  bazel-bin/nighthawk_client --rps 500  --connections 4 --concurrency 4 --request-body-size $bsize  --prefetch-connections -v info http://127.0.0.1:10000/ | grep  mean | awk '{print $8*1000+$9}' | tr -d 'a-zA-Z'|  head -1  >>$bsize.log
    done

    for((j=1; j<=3; j++))
    do
         temp='sed -n '$j'p '$bsize'.log'
	 temp=$($temp)
	 echo $temp
	 let sum+=$temp
    done
    echo "$sum" >>sum.log

done

