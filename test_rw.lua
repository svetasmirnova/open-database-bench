pathtest = string.match(test, "(.*/)") or ""

dofile(pathtest .. "test_common.lua")

function event(thread_id)
	local aid = sb_rand_gaussian(1, (accounts_size * scale))
	local bid = sb_rand_gaussian(1, (branches_size * scale))
	local tid = sb_rand_gaussian(1, (tellers_size * scale))
	local delta = sb_rand(-5000, 5000)

	db_query("begin")
	db_query("UPDATE accounts SET abalance = abalance + " .. delta .. " where aid = " .. aid)
	db_query("SELECT abalance FROM accounts WHERE aid = " .. aid)
	db_query("UPDATE tellers SET tbalance = tbalance + " .. delta .. " WHERE tid = " .. tid)
	db_query("UPDATE branches SET bbalance = bbalance + " ..delta .. " WHERE bid = " .. bid)
	db_query("INSERT INTO history (tid, bid, aid, delta, mtime) VALUES (" .. tid .. ", " .. bid .. ", " .. aid .. ", " .. delta .. ", CURRENT_TIMESTAMP)")
	db_query("commit")
end
