function thread_init(thread_id)
	set_vars()
end

function set_vars()
	branches_size = branches_size or 1
	tellers_size = tellers_size or 10
	accounts_size = accounts_size or 100000
	scale = scale or 1
	mysql_table_engine = mysql_table_engine or "innodb"
end

function prepare()
	set_vars()

	db_connect()

	db_query([[
create table accounts(
aid int not null primary key,
bid int,
abalance int,
filler char(84)
) 
/*! ENGINE = ]] .. mysql_table_engine ..
[[ default character set=latin1 */ 
]])

	db_query([[
create table branches(
bid int not null primary key,
bbalance int,
filler char(88)
)
/*! ENGINE = ]] .. mysql_table_engine ..
[[ default character set=latin1 */
]])

	db_query([[
create table history(
tid int,
bid int,
aid int,
delta int,
mtime timestamp,
filler char(22)
) 
/*! ENGINE = ]] .. mysql_table_engine ..
[[ default character set=latin1 */ 
]])

	db_query([[
create table tellers(
tid int primary key,
bid int,
tbalance int,
filler char(84)
) 
/*! ENGINE = ]] .. mysql_table_engine ..
[[ default character set=latin1 */
]])

	for i=1,(branches_size * scale) do
		db_query("insert into branches (bid, bbalance, filler) values(" .. i .. ", 0, '')")
	end

	for i=1,(tellers_size * scale) do
		db_query("insert into tellers (tid, bid, tbalance, filler) values(" .. i .. ", " .. ((i % (branches_size * scale)) + 1) .. ", 0, '')")
	end

	for i=1,(accounts_size * scale) do
		db_query("insert into accounts (aid, bid, abalance, filler) values(" .. i .. ", " .. ((i % (branches_size * scale)) + 1) .. ", 0, '')")
	end
end

function cleanup()
	print("Dropping tables accounts, branches, history, tellers");
	db_query("drop table accounts, branches, history, tellers")
end
