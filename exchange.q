\l init_ex.q

.ex.eng_h:hopen `::5454;

id:0;

.ex.get_bal:{[pl_id]
	exec balance from `.dt.players where pid=pl_id}

.ex.get_qty:{[pl_id]
	exec noShares from `.dt.players where pid=pl_id}

.ex.upd_pl:{[pl_id; qty; price]
	info:exec balance, noShares from .dt.players where pid=pl_id;
	update balance:info[`balance][0]-(price*qty), noShares:info[`noShares][0]+qty from `.dt.players where pid=pl_id;
	(neg pl_id) (".pl.upd_info"; info[`balance][0]-(price*qty); info[`noShares][0]+qty);}

.ex.upd_trade:{[trade]
	if[trade[0] in .ex.lq[`oid];
	info:exec pid, filledQty from .ex.lq where oid=trade[0];
	update filledQty:info[`filledQty][0]+trade[5], tradePrice:trade[4] from `.ex.lq where oid=trade[0];
	.ex.upd_pl[info[`pid][0]; trade[5]; trade[4]];
	(neg info[`pid][0]) (".pl.upd_trade"; (trade[0]; trade[2]; trade[5]; trade[4]));];
	if[trade[0] in .ex.mq[`oid];
	info:exec pid, filledQty from .ex.mq where oid=trade[0];
	update filledQty:info[`filledQty][0]+trade[5], tradePrice:trade[4] from `.ex.mq where oid=trade[0];
	.ex.upd_pl[info[`pid][0]; trade[5]; trade[4]];
	(neg info[`pid][0]) (".pl.upd_trade"; (trade[0]; trade[2]; trade[5]; trade[4]));];
	if[trade[1] in .ex.lq[`oid];
	info:exec pid, filledQty from .ex.lq where oid=trade[1];
	update filledQty:info[`filledQty][0]+trade[5], tradePrice:trade[4] from `.ex.lq where oid=trade[1];
	.ex.upd_pl[info[`pid][0]; (neg trade[5]); trade[4]];
	(neg info[`pid][0]) (".pl.upd_trade"; (trade[1]; trade[2]; trade[5]; trade[4]));];
	if[trade[1] in .ex.mq[`oid];
	info:exec pid, filledQty from .ex.mq where oid=trade[1];
	.ex.upd_pl[info[`pid][0]; (neg trade[5]); trade[4]]
	update filledQty:info[`filledQty][0]+trade[5], tradePrice:trade[4] from `.ex.mq where oid=trade[1];
	(neg info[`pid][0]) (".pl.upd_trade"; (trade[1]; trade[2]; trade[5]; trade[4]));];}

.ex.recv_trade:{[trade]
	.dt.trade,:trade;
	.ex.upd_trade[trade];}

.ex.bpx:(0;0);
.ex.get_bpx:{.ex.bpx:x;}

.ex.is_valid_order:{[order; pid]
	r:0b;
	(neg .ex.eng_h) (".eng.bpx");
	if[order[1]="B";
	if[order[3]=`limit;
	if[(order[4]>0)and(order[2]>0);
	if[order[2]*order[4] <= .ex.get_bal[pid][0]; r:1b;];];];
	if[order[3]=`market;
	if[order[2]>0;
	if[order[2]*.ex.bpx[1] <= .ex.get_bal[pid][0]; r:1b;];];];];
	if[order[1]="S";
	if[order[3]=`limit;
	if[(order[4]>0)and(order[2]>0);
	if[order[2] <= .ex.get_qty[pid][0]; r:1b];];];
	if[order[3]=`market;
	if[order[2]>0;
	if[order[2] <= .ex.get_qty[pid][0]; r:1b];];];];
	r}

.ex.cancel:{[order]
	if[order[0] in .ex.lq[`oid];
	update status:`cancel from `.ex.lq where oid=order[0];
	pid:.ex.lq[`.ex.lq[`oid]?order[0]][`pid];
	(neg pid) (".pl.recv_canc"; order);];
	if[order[0] in .ex.mq[`oid];
	update status:`cancel from `.ex.mq where oid=order[0];
	pid:.ex.lq[`.ex.lq[`oid]?order[0]][`pid];
	(neg pid) (".pl.recv_canc"; order);];}

.ex.recv_order:{[order; callback]
	if[order[1]~`cancel;
	(neg .ex.eng_h) (".eng.deq"; order; ".ex.cancel");];
	if[(order[3]~`market) or (order[3]~`limit);
	o:(id+:1; .z.N), order;
	flag:.ex.is_valid_order[order; .z.w];
	if[flag;
	if[order[3]~`market; .ex.mq,:(.z.w),(o,0,0,`open);];
	if[order[3]~`limit; .ex.lq,:(.z.w),(o,0,0,`open);];
	(neg .ex.eng_h) (".eng.enq"; o);
	if[order[3]~`market; o,:0];
	(neg .z.w) (callback; (o, 0, 0, `accepted));];
	if[not flag;
	(neg .z.w) (callback; (o, 0, 0, `rejected));];];}

.ex.reg_player:{[name; callback]
	l:(.z.w; name; 100000; 500);
	.dt.players,:l;
	(neg .z.w) (callback; l)}

\p 5555