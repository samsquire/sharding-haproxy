#!/usr/bin/env bash

ln -s $(pwd)/usershard.lua /etc/haproxy/usershard.lua
ln -s $(pwd)/haproxy.service /etc/systemd/system/haproxy.service

python3 generateshards.py > shards.cfg

ln -s $(pwd)/shards.cfg /etc/haproxy/shards.cfg

virtualenv venv


