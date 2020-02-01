#!/bin/bash

num_threads=$1	# number of parallel threads

for (( i = 1 ; i <= num_threads ; i++ ))
do
	./kafka-consumer-perf-test.sh \
--broker-list node-01:9094,node-02:9094,node-03:9094 \
--messages 100000 \
--topic test \
--timeout 30000 
#--fetch-size 100000

done

