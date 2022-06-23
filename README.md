# sharding-haproxy

This shows how to shard HaProxy by user or tenant.

We use a Lua script based on [5 Ways to Extend HAProxy with Lua](https://www.haproxy.com/blog/5-ways-to-extend-haproxy-with-lua/) and [Nick Serra's blog](https://tech.nickserra.com/2019/12/03/haproxy-dynamic-backend-selection-with-lua-script/)

This Luascript creates a HTTP request to a shard server which is running on the server that runs HaProxy, this maps user identifiers in cookies

The intention is to ultimately combine this with [Instagram's approach to ID generation](https://instagram-engineering.com/sharding-ids-at-instagram-1cf5a71e5a5c?gi=4b7f98f4ba9d).
