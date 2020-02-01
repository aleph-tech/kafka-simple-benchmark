#!/bin/bash

num_threads=$1 	# number of parallel producer threads
rec_size=$2	# message size in bytes

for (( i = 1 ; i <= num_threads ; i++ ))
do
	./kafka-producer-perf-test.sh \
--num-records 100000 \
--record-size $rec_size \
--topic test \
--throughput 5000 \
--producer-props \
request.timeout.ms=300000 \
bootstrap.servers=node-01:9094,node-02:9094,node-03:9094 \
compression.type=lz4 \
acks=all  
#linger.ms=85

done
