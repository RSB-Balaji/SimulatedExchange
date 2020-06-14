# SimulatedExchange
A simulated electronic exchange built using "q" language and using KDB+ that mimics an intraday trades of one stock.

The exchange accepts three kinds of orders:
1. Market order 
2. Limit order
3. Cancel order

## Simulation

The simulation of the orders is modelled based on three things:
1. Arrival of orders
2. Quantities of orders
3. Price of orders

### Arrival times
The arrival times of the orders are modelled as a Homogenos Poisson Process. With constant rate for each type of order i.e., market buy, market sell, limit buy, limit sell.

Here is the q code that simulates the arrival of orders as a Homogenous Poisson Process.
```
inv_cdf:{[x; lam] -1*(log (1.0 - x))%lam}

poi_sim:{[lam]
	p:first 1?1.0;
	t:`int$inv_cdf[p; lam]+1;	
	t}
```

### Price dynamic
The price dymaics of the orders are modelled as a Random Walk model with the tick size being $1. 

