#!/bin/bash

  if [ -f producer_stats.txt ]; then
    rm producer_stats.txt
  fi
  if [ -f consumer_stats.txt ]; then
    rm consumer_stats.txt
  fi

for d in `find . ! -path . -type d`; do
  cd $d
  echo "Browsing $d..."
  echo "Processing producer stats..."
  if [ -f producer_stats.txt ]; then
    rm producer_stats.txt
  fi
  if [ -f consumer_stats.txt ]; then
    rm consumer_stats.txt
  fi

  for p in `find . -name "producer*" `; do
    tail -1 $p >> producer_stats.txt
  done
  echo "Processing consumer stats..."
  for c in `find . -name "consumer*" `; do
    tail -1 $c >> consumer_stats.txt
  done
  
  count=0;
  total_recsec=0; 
  total_lat=0;
  for i in $( awk '{ print $4";"$8; }' producer_stats.txt )
  do 
    a=$(echo $i | cut -f1 -d ";" )
    b=$(echo $i | cut -f2 -d ";" )

    total_recsec=$(echo $total_recsec+$a | bc )
    total_lat=$(echo $total_lat+$b | bc )
    ((count++))
  done
  avg_recsec=$(echo "scale=2; $total_recsec / $count" | bc )
  avg_lat=$(echo "scale=2; $total_lat / $count" | bc )

  count2=0;
  total_recsec2=0;
  total_lat2=0;
  for i in $( awk -F "," '{gsub(/ /, "", $8); print $6";"$8; }' consumer_stats.txt ) 
  do
    a=$(echo $i | cut -f1 -d ";" )
    b=$(echo $i | cut -f2 -d ";" )
    total_recsec2=$(echo $total_recsec2+$a | bc )
    total_lat2=$(echo $total_lat2+$b | bc )
    ((count2++))
  done
  avg_recsec2=$(echo "scale=2; $total_recsec2 / $count2" | bc )
  avg_lat2=$(echo "scale=2; $total_lat2 / $count2" | bc )

  cd ..

d2=`echo "$d" |cut -c3- `
msgsz=`echo "$d2" |cut -d'-' -f1`
echo "$d2,$msgsz,$avg_recsec,$avg_lat" >> producer_stats.txt
echo "$d2,$msgsz,$avg_recsec2,$avg_lat2" >> consumer_stats.txt

done

echo "Sorting results..."
echo "TEST,MSGSZ,AVG_RECSEC,AVG_LAT" > producer_stats_sorted.csv
sort -t, -k2,2n -k4,4n producer_stats.txt >> producer_stats_sorted.csv
echo "TEST,MSGSZ,AVG_RECSEC,AVG_LAT" > consumer_stats_sorted.csv
sort -t, -k2,2n -k4,4n consumer_stats.txt >> consumer_stats_sorted.csv

