# sharding-haproxy

This shows how to shard HaProxy by user or tenant.

We use a Lua script based on [5 Ways to Extend HAProxy with Lua](https://www.haproxy.com/blog/5-ways-to-extend-haproxy-with-lua/) and [Nick Serra's blog](https://tech.nickserra.com/2019/12/03/haproxy-dynamic-backend-selection-with-lua-script/)

This Luascript creates a HTTP request to a shard server which is running on the server that runs HaProxy, this maps user shard identifiers to backends.

This is a bit like a sticky session for sharded users or tenants. If the user doesn't have a username cookie, they are sent to the default server shard which is shard0. You could load balance the login server by randomly picking a shard. Any server can be a login server, but user's data may only be on certain servers.

The intention is to ultimately combine this with [Instagram's approach to ID generation](https://instagram-engineering.com/sharding-ids-at-instagram-1cf5a71e5a5c?gi=4b7f98f4ba9d).

You need a stable approach to generating the haproxy configuration file, you need to enumerate all logical shards and all physical servers in those shards.

# installation

This was developed on Ubuntu.

Install redis, python3 and haproxy. I build haproxy from source with LUA 

```
sudo apt install liblua5.3-0
sudo apt install lua5.3
make TARGET=linux-glibc LUA_LIB=/usr/bin/lua5.3 LUA_INC=/usr/include/lua5.3/ LUA_LIB_NAME=lua5.3 USE_LUA=1
```

Run
```
sudo bash install.sh
sudo bash start.sh
sudo systemctl daemon-reload
sudo service haproxy restart
```

Go to http://localhost:7000 and http://localhost:8404/stats and login with a number from 0-5 and password sam. You shall be load balanced servers that are part of a shard.

# serious usage

If you plan to use this approach, create an issue please to log your usage of this approach and your company name or website.

If you were doing this seriously, you want a good quality approach to generating `shards.cfg` and you want to formalise the adding servers to a shard.

You could use consul for service discovery but you need to have some runbook for assigning users to servers, it's partially a manual process. You also want to load balance neighbours or users so you need some kind of data movement procedure.
