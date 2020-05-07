.dt.trade:([]
	boid:`int$();
	soid:`int$();
	time:`time$();
	sym:`symbol$();
	price:`int$();
	qty:`int$())

.dt.players:([]
	pid:`int$();
	pname:`symbol$();
	balance:`int$();
	noShares:`int$())

.ex.lq:([] 
	pid:`int$();
	oid:`int$();
	time:`time$();
	sym:`symbol$();
	side:`char$();
	qty:`int$();
	otype:`symbol$();
	price:`int$();
	filledQty:`int$();
	tradePrice:`int$();
	status:`symbol$())

.ex.mq:([]
	pid:`int$();
	oid:`int$(); 
	time:`time$(); 
	sym:`symbol$(); 
	side:`char$(); 
	qty:`int$();
	otype:`symbol$();
	filledQty:`int$();
	tradePrice:`int$();
	status:`symbol$())
