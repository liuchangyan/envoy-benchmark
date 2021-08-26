#!/bin/bash

iterations="$1"

path=`dirname $0`
path=`cd "$path"; pwd`
echo $path

cd "$path"
declare rps=0

for ((i=1;i<=iterations;i++));
do
    declare sum=0
    let rps=$i*500
    echo "Testing envoy performance using nighthawk request per second is  "$rps" ... "
    for((j=1; j<=10; j++))
    do
	 taskset -c 11-13  bazel-bin/nighthawk_client --rps $rps  --connections 4  --concurrency 4 --request-body-size 16384  --prefetch-connections -v info http://127.0.0.1:10000/ | grep  mean | awk '{print $8*1000+$9}' | tr -d 'a-zA-Z'|  head -1   >>$rps.log
    done

    for((j=1; j<=10; j++))
    do
         temp='sed -n '$j'p '$rps'.log'
	 temp=$($temp)
	 echo $temp
	 let sum+=$temp
    done
    echo "$sum" >>sum.log

done

echo "*******************************************Testing over*************************************"
#less ../test-example/cpu_interim.log | awk '{print $9}' |  sed -e '/^$/d'  >>../test-example/cpu_memcpy_result.log

