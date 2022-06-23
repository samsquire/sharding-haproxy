local function shard(txn)
    shard = 'shard0'
    local logicalshard = "0"
    local tcp = core.tcp()
    local headers = txn.http:req_get_headers()
    if headers then
		local cookie = headers["cookie"]
		if cookie then
			session = cookie[0]
			if session then
				found_cookie = session:match("username=([a-zA-Z0-9]+)")

				if found_cookie then
				
					print("User has a shard cookie")
					print(found_cookie)
					logicalshard =  string.gsub(found_cookie, "[^a-zA-Z0-9]+", "")
				end
			end
			tcp:settimeout(1)
			if tcp:connect("127.0.0.1", "5000") then
			  if tcp:send("GET /shards/" .. logicalshard .." HTTP/1.1\r\nconnection: close\r\n\r\n") then
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
			  print('Socket connection to shardserver failed')
			end
			print('Shard is', shard)
			print(txn.http)

			end	
		end	
	txn:set_var('req.shard', shard)
end

core.register_action('shard', {'http-req'}, shard)
