#!/bin/bash

iterations="$1"

path=`dirname $0`
path=`cd "$path"; pwd`
echo $path

cd "$path"
declare conn=0

for ((i=0;i<=iterations;i++));
do
    declare sum=0
    let conn=2**$i
    echo "Testing envoy performance using nighthawk connections  is  "$conn" ... "
    for((j=1; j<=10; j++))
    do
	 taskset -c 11-13  bazel-bin/nighthawk_client --rps 1500  --connections $conn --concurrency 4 --request-body-size 17480 --prefetch-connections -v info http://127.0.0.1:10000/ | grep  mean | awk '{print $8*1000+$9}' | tr -d 'a-zA-Z'|  head -1  >>$conn.log
    done

    for((j=1; j<=10; j++))
    do
         temp='sed -n '$j'p '$conn'.log'
	 temp=$($temp)
	 echo $temp
	 let sum+=$temp
    done
    echo "$sum" >>conn_sum.log

done
#less ../test-example/cpu_interim.log | awk '{print $9}' |  sed -e '/^$/d'  >>../test-example/cpu_memcpy_result.log

