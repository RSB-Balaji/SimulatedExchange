.pl.orders:([]
	oid:`int$();
	time:`timespan$();
	sym:`symbol$();
	side:`char$();
	qty:`int$();
	otype:`symbol$();
	price:`int$();
	filledQty:`int$();
	tradePrice:`int$();
	status:`symbol$())

.pl.h:hopen `::5555

.pl.info:0

.pl.upd_info:{[bal; ns]
	.pl.info[`balance]:bal;
	.pl.info[`noShares]:ns;}

.pl.upd_trade:{[trade]
	info:exec filledQty from .pl.orders where oid=trade[0];
	update filledQty:info[0]+trade[2], tradePrice:trade[3] from `.pl.orders where oid=trade[0];}

.pl.recv_ack:{[order] .pl.orders,:order;}

.pl.recv_info:{.pl.info:`pid`name`balance`noShares!x;}

.pl.reg_to_ex:{[name]
	(neg .pl.h) (".ex.reg_player"; name; ".pl.recv_info")}

.pl.recv_canc:{[order]
	update status:`cancel from `.pl.orders where oid=order[0];}

.pl.send_order:{[order]
	if[order[1]~`cancel;
	if[order[0] in .pl.orders[`oid];
	idx:.pl.orders[`oid]?order[0];
	if[.pl.orders[idx][`qty]<>.pl.orders[idx][`filledQty];
	(neg .pl.h) (".ex.recv_order"; order; ".pl.recv_canc");];];];
	if[(order[3]~`limit) or (order[3]~`market);
	(neg .pl.h) (".ex.recv_order"; order; ".pl.recv_ack");];}
