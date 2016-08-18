pathtest = string.match(test, "(.*/)") or ""

dofile(pathtest .. "test_common.lua")

function event(thread_id)
	local aid = sb_rand(1, accounts_size * scale)

	db_query("SELECT abalance FROM accounts WHERE aid = " .. aid)
end
