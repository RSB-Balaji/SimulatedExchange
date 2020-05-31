\l init_pl.q

.pl.reg_to_ex[`svr]

inv_cdf:{[x; lam] -1*(log (1.0 - x))%lam}

poi_sim:{[lam]
	p:first 1?1.0;
	t:`int$inv_cdf[p; lam]+1;	
	t}

p:50

do[1000; p+:(first 1?(1;-1)); iat:poi_sim[2.0]; system "sleep ",string iat*0.001; .pl.send_order[(`aapl; "S"; 1; `limit; p)]; show .z.N;]
