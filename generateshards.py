#!/usr/bin/env python3
start_port = 8000

print("""
frontend stats
    bind *:8404
    stats enable
    stats uri /stats
    stats refresh 10s
    stats admin if LOCALHOST

frontend frontend
    bind *:7000
    mode http


    # inspect-delay was required or else was seeing timeouts during lua script run
    # tcp-request inspect-delay 1m

    # This line intercepts the incoming tcp request and pipes it through lua function, called "pick backend"
    http-request lua.shard

    # use_backend based off of the "streambackend" response variable we inject via lua script
    use_backend %[var(req.shard)]
""")

for shard in range(6):
    print("""
backend shard{}
    mode http\n""".format(shard))
    for server in range(3):
        print("""    server {}_{} 127.0.0.1:{} check\n""".format(
        shard, server, start_port))
        start_port = start_port + 1

