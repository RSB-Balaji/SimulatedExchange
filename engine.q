\l init_eng.q

.eng.bbpx:{exec max(price) from .eng.lbq}
.eng.bapx:{exec min(price) from .eng.laq}
.eng.bbqty:{exec sum(qty) from .eng.lbq where price=.eng.bbpx[]}
.eng.baqty:{exec sum(qty) from .eng.laq where price=.eng.bapx[]}

.eng.if_mbo:{((((count .eng.mbq) > 0) and ((count .eng.laq) > 0)))} /and ((first .eng.mbq)[`qty] <= sum .eng.laq[`qty])}

.eng.bpx:{(neg .eng.ex_h) (".ex.get_bpx"; (.eng.bbpx; .eng.bapx));}

.eng.match_mbo:{
	while[.eng.if_mbo[];
	bo:first .eng.mbq;
	so:first .eng.laq;
	if[bo[`qty] < so[`qty];
	t:(bo[`oid]; so[`oid]; .z.T; bo[`sym]; so[`price]; bo[`qty]);
	(neg .eng.ex_h) (".ex.recv_trade"; t);
	so[`qty]-:bo[`qty];
	bo[`qty]:0;
	delete from `.eng.mbq where oid=bo[`oid];
	update qty:so[`qty] from `.eng.laq where oid=so[`oid];];
	if[bo[`qty] = so[`qty];
	t:(bo[`oid]; so[`oid]; .z.T; bo[`sym]; so[`price]; bo[`qty]);
	(neg .eng.ex_h) (".ex.recv_trade"; t);
	bo[`qty]:0;
	so[`qty]:0;
	delete from `.eng.mbq where oid=bo[`oid];
	delete from `.eng.laq where oid=so[`oid];];
	if[bo[`qty] > so[`qty];
	t:(bo[`oid]; so[`oid]; .z.T; bo[`sym]; so[`price]; so[`qty]);
	(neg .eng.ex_h) (".ex.recv_trade"; t);
	bo[`qty]-:so[`qty];
	so[`qty]:0;
	update qty:bo[`qty] from `.eng.mbq where oid=bo[`oid];
	delete from `.eng.laq where oid=so[`oid];];];}

.eng.if_mao:{((((count .eng.maq) > 0) and ((count .eng.lbq) > 0)))} /and ((first .eng.maq)[`qty] <= (sum .eng.lbq[`qty]))}

.eng.match_mao:{
	while[.eng.if_mao[];
	so:first .eng.maq;
	bo:first .eng.lbq;
	if[so[`qty] < bo[`qty];
	t:(bo[`oid]; so[`oid]; .z.T; bo[`sym]; bo[`price]; so[`qty]);
	(neg .eng.ex_h) (".ex.recv_trade"; t);
	bo[`qty]-:so[`qty];
	so[`qty]:0;
	delete from `.eng.maq where oid=so[`oid];
	update qty:bo[`qty] from `.eng.lbq where oid=bo[`oid];];
	if[bo[`qty] = so[`qty];
	t:(bo[`oid]; so[`oid]; .z.T; bo[`sym]; bo[`price]; so[`qty]);
	(neg .eng.ex_h) (".ex.recv_trade"; t);
	bo[`qty]:0;
	so[`qty]:0;
	delete from `.eng.maq where oid=so[`oid];
	delete from `.eng.lbq where oid=bo[`oid];];
	if[so[`qty] > bo[`qty];
	t:(bo[`oid]; so[`oid]; .z.T; bo[`sym]; bo[`price]; bo[`qty]);
	(neg .eng.ex_h) (".ex.recv_trade"; t);
	so[`qty]-:bo[`qty];
	bo[`qty]:0;
	update qty:so[`qty] from `.eng.maq where oid=so[`oid];
	delete from `.eng.lbq where oid=bo[`oid];];];}

.eng.match_lo:{
	while[(.eng.bbpx[] >= .eng.bapx[]) and (((count .eng.lbq) > 0) and ((count .eng.laq) > 0));
	bo:first .eng.lbq;
	so:first .eng.laq;
	if[bo[`qty] < so[`qty];
	t:(bo[`oid]; so[`oid]; .z.T; bo[`sym]; so[`price]; bo[`qty]);
	(neg .eng.ex_h) (".ex.recv_trade"; t);
	so[`qty]-:bo[`qty];
	bo[`qty]:0;
	delete from `.eng.lbq where oid=bo[`oid];
	update qty:so[`qty] from `.eng.laq where oid=so[`oid];];
	if[(bo[`qty]=so[`qty]) and (bo[`qty]<>0);
	t:(bo[`oid]; so[`oid]; .z.T; bo[`sym]; so[`price]; so[`qty]);
	(neg .eng.ex_h) (".ex.recv_trade"; t);
	so[`qty]:0;
	bo[`qty]:0;
	delete from `.eng.lbq where oid=bo[`oid];
	delete from `.eng.laq where oid=so[`oid];];
	if[bo[`qty] > so[`qty];
	t:(bo[`oid]; so[`oid]; .z.T; bo[`sym]; so[`price]; so[`qty]);
	(neg .eng.ex_h) (".ex.recv_trade"; t);
	bo[`qty]-:so[`qty];
	so[`qty]:0;
	update qty:bo[`qty] from `.eng.lbq where oid=bo[`oid];
	delete from `.eng.laq where oid=so[`oid];];];}

.eng.show_books:{
	0N!"|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||";
	0N!"market bid q";
	show .eng.mbq;
	0N!"market ask q";
	show .eng.maq;
	0N!"limit bid q";
	show .eng.lbq;
	0N!"limit ask q";
	show .eng.laq;
	0N!"|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||";}

.eng.match_order:{
	.eng.match_mbo[];
	.eng.match_mao[];
	.eng.match_lo[];}

.eng.ex_h:0;

.eng.deq:{[order; callback]
	delete from `.eng.laq where oid=order[0];
	delete from `.eng.lbq where oid=order[0];
	delete from `.eng.maq where oid=order[0];
	delete from `.eng.mbq where oid=order[0];
	(neg .eng.ex_h) (callback; order);}

.eng.enq:{[order]
	.eng.ex_h:.z.w;
	if[order[5]~`market; if[order[3]~"B"; .eng.mbq,:order]; if[order[3]~"S"; .eng.maq,:order];];
	if[order[5]~`limit; if[order[3]~"B"; .eng.lbq,:order; `price xdesc `time xasc `.eng.lbq;]; if[order[3]~"S"; .eng.laq,:order; `price xasc `time xasc `.eng.laq;];];
	.eng.match_order[]}
	
\p 5454