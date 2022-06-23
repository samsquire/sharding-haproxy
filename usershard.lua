local function shard(txn)
    shard = 'shard0'

    local tcp = core.tcp()
    tcp:settimeout(1)

    if tcp:connect("127.0.0.1", "5000") then
      if tcp:send("GET /shards/0 HTTP/1.1\r\nconnection: close\r\n\r\n") then
	while true do
                local line, _ = tcp:receive('*l')

                if not line then break end
                if line == '' then break end
            end
	local line, _ = tcp:receive('*a')

	shard = "shard" .. line
      end
      tcp:close()
    else
      print('Socket connection failed')
    end
    print('Shard is', shard)
    print(txn.http)

    txn:set_var('req.shard', shard)
end

core.register_action('shard', {'tcp-req', 'http-req'}, shard)
