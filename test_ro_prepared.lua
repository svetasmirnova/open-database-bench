pathtest = string.match(test, "(.*/)") or ""

dofile(pathtest .. "test_common.lua")

function thread_init(thread_id)
	set_vars()

	point_select = db_prepare("SELECT abalance FROM accounts WHERE aid = ?")
	point_params = {}
	point_params[1] = 1
	db_bind_param(point_select, point_params)
end

function event(thread_id)
	local aid = sb_rand(1, accounts_size * scale)

	point_params[1] = sb_rand(1, accounts_size * scale)
	rs = db_execute(point_select)
end
