#!/bin/bash

iterations="$1"

path=`dirname $0`
path=`cd "$path"; pwd`
echo $path

cd "$path"
declare bsize=0

for ((i=1;i<=iterations;i++));
do
    declare sum=0
    let bsize=$i*4096

    echo "Testing envoy performance using nighthawk request per second is  "$bsize" ... "
    for((j=1; j<=3; j++))
    do
	 taskset -c 60-70  ../bazel-bin/nighthawk_client --rps 500  --connections 64 --concurrency 4 --request-body-size $bsize  --prefetch-connections -v info http://127.0.0.1:10000/  --duration 30  | grep  "0.8  " | head -1 | awk '{print $4*1000+$5}' | tr -d "a-zA-Z"  >>$bsize.log
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

