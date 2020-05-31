.dt.trade:([]
	boid:`int$();
	soid:`int$();
	time:`timespan$();
	sym:`symbol$();
	price:`int$();
	qty:`int$())

.dt.players:([]
	pid:`int$();
	pname:`symbol$();
	balance:`int$();
	profit:`int$();
	noShares:`int$())

.ex.lq:([] 
	pid:`int$();
	oid:`int$(); 
	time:`timespan$(); 
	sym:`symbol$(); 
	side:`char$(); 
	qty:`int$(); 
	otype:`symbol$();
	price:`int$())

.ex.mq:([] 
	pid:`int$();
	oid:`int$(); 
	time:`timespan$(); 
	sym:`symbol$(); 
	side:`char$(); 
	qty:`int$(); 
	otype:`symbol$())

.eng.lbq:([] 
	oid:`int$(); 
	time:`timespan$(); 
	sym:`symbol$(); 
	side:`char$(); 
	qty:`int$(); 
	otype:`symbol$();
	price:`int$())

.eng.laq:([] 
	oid:`int$(); 
	time:`timespan$(); 
	sym:`symbol$(); 
	side:`char$(); 
	qty:`int$(); 
	otype:`symbol$();
	price:`int$())

.eng.mbq:([] 
	oid:`int$(); 
	time:`timespan$(); 
	sym:`symbol$(); 
	side:`char$(); 
	qty:`int$(); 
	otype:`symbol$())

.eng.maq:([] 
	oid:`int$(); 
	time:`timespan$(); 
	sym:`symbol$(); 
	side:`char$(); 
	qty:`int$(); 
	otype:`symbol$())