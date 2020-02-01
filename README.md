# kafka-simple-benchmark

Shell scripts to test parallel consumer/producers by leveraging the base kafka release scripts.

The folliwng scripts are based on the kafka-2.11-2.2.0 release

The idea is pretty simple: get logs, aggregate results (last lines) and produce averages on records sent (producer) or fetched (consumer) figures per second and latencies.


## Run example

For each parameter combination (producer and/or consumer)
we modify the respective script to encode the tested parameter value
and run the test scripts in 2 shell sessions.
For example, to test 30 producers and 30 consumers with message size 1500 bytes:

*session 1*

```
./run-producers.sh 30 1500
```

*session 2*

```
./run-consumers.sh 30
```

We observe that we will have 60 log files in the <base kafka dir>/logs directory with the patterns:

```
producer-NNNN.out
consumer-NNNN.out
```

In this example we then move the logs inside a dedicated directory to avoid mixing further test runs
(TODO: automate this)

```
cd logs
mkdir 1500-base
mv *.out 1500-base/
```

We note the message size is a suffix.

## Daemon mode

2 base scripts have been modified in order to run them in daemon mode:

(from the base kafka directory)
./bin/kafka-producer-perf-test.sh

The last line has been modified as following:

```
exec $(dirname $0)/kafka-run-class.sh -daemon -name producer_$BASHPID org.apache.kafka.tools.ProducerPerformance "$@"
```

./kafka-consumer-perf-test.sh

The last line has been modified:

```
exec $(dirname $0)/kafka-run-class.sh -daemon -name consumer_$BASHPID kafka.tools.ConsumerPerformance "$@"
```

The above modifications will cause logs being generated in the <kafka base dir>/logs directory.

## Stats

The genstats.sh script must be placed in the <kafka base dir>/logs directory
This script scans all test directories and aggregate 2 metrics:

- average messages/second
- average latency

It will generate 2 output files:

producer_stats_sorted.csv
consumer_stats_sorted.csv

Which contain data sorted by message size and latency.
