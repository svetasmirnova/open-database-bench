pathtest = string.match(test, "(.*/)") or ""

dofile(pathtest .. "test_common.lua")

function thread_init(thread_id)
    set_vars()

    upd1 = db_prepare("UPDATE accounts SET abalance = ? WHERE aid = ?")
    upd1_params = {1,1}
    db_bind_param(upd1, upd1_params)

	sel = db_prepare("SELECT abalance FROM accounts WHERE aid = ?")
	sel_params = {1}
	db_bind_param(sel, sel_params)

	upd2 = db_prepare("UPDATE tellers SET tbalance = ? WHERE tid = ?")
    upd2_params = {1,1}
    db_bind_param(upd2, upd2_params)

	upd3 = db_prepare("UPDATE branches SET bbalance = ? WHERE bid = ?")
    upd3_params = {1,1}
    db_bind_param(upd3, upd3_params)

	ins = db_prepare("INSERT INTO history (tid, bid, aid, delta, mtime) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)")
    ins_params = {1,1,1,1}
    db_bind_param(ins, ins_params)
end


function event(thread_id)
	local rs
	local aid = sb_rand_gaussian(1, (accounts_size * scale))
	local bid = sb_rand_gaussian(1, (branches_size * scale))
	local tid = sb_rand_gaussian(1, (tellers_size * scale))
	local delta = sb_rand(-5000, 5000)

	upd1_params[1] = delta
	upd1_params[2] = aid

	sel_params[1] = aid

	upd2_params[1] = delta
	upd2_params[2] = tid

	upd3_params[1] = delta
	upd3_params[2] = bid

	ins_params[1] = tid
	ins_params[2] = bid
	ins_params[3] = aid
	ins_params[4] = delta

	db_query("begin")
	db_execute(upd1)
	rs = db_execute(sel)
	db_free_results(rs)
	db_execute(upd2)
	db_execute(upd3)
	db_execute(ins)
	db_query("commit")
end
