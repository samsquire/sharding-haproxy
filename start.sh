#!/usr/bin/env bash
source venv/bin/activate

sudo -E $(which gunicorn) -w 1 -k gevent  shardserver:app --bind 127.0.0.1:5000 &
start_port=8000
port=${start_port}
for i in $(seq 0 5); do 
	for m in $(seq 0 3); do
	echo "Starting shard server... ${port}" 
	export SHARD_ARGS="--shard $m" ; 
	sudo -E $(which gunicorn) -w 1 -k gevent  server:app --bind 127.0.0.1:$port &
	port=$((port+1))
	done
done
wait
