#!/bin/bash

iterations="$1"

path=`dirname $0`
path=`cd "$path"; pwd`
echo $path

cd "$path"
declare conn=0
declare colum1=0
declare colum2=0
for ((i=1;i<=iterations;i++));
do
    declare sum1=0
    declare sum2=0
    let conn=2**$i
    echo "Testing envoy performance using nighthawk connections  is  "$conn" ... "
    for((j=1; j<=10; j++))
    do
	  taskset -c 60-70  ../bazel-bin/nighthawk_client --rps 500  --connections $conn  --concurrency 4 --request-body-size 65536  --prefetch-connections -v info http://127.0.0.1:10000/ --h2 --duration 30  | grep -E  "0.75  |0.8  " | head -2 | awk '{print $4*1000+$5}' | tr -d "a-zA-Z"  >>$conn.log
    done
    
    
    for ((j=1; j<=10; j++))
    do
        let colum1=$j*2-1
        let colum2=$j*2
        temp1='sed -n '$colum1'p '$conn'.log'
	    temp1=$($temp1)
	    echo $temp1
	    let sum1+=$temp1
        temp2='sed -n '$colum2'p '$conn'.log'
        temp2=$($temp2)
        echo $temp2
        let sum2+=$temp2
    done
    let sum1=$sum1/10
    echo "$sum1" >>conn_sum1.log
    let sum2=$sum2/10
    echo "$sum2" >>conn_sum2.log

done


