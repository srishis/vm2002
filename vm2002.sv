// RTL Design for vm2002 for Assignment 1

`include "vm2002_pkg.svh"
module vm2002(product, status, balance, info, clk, hrst, srst, coins, buttons, select, item, count, cost, valid);

input clk, hrst, srst;

// user interface inputs
input [1:0] coins; 
input [2:0] buttons; 
input select; 

// supplier interface inputs
input [2:0] item;
input [3:0] count;
input [7:0] cost;
input valid;

// output interface
output logic [2:0] product;
output logic [1:0] status;
output logic [15:0] balance;
output logic [7:0] info;

// internal variables
logic [8:0] timer;				// 9 bit down counter which counts 512 clocks

// insufficient_amount flag 
logic insufficient_amount;
// import package
import vm2002_pkg::*;

item_count_struct_t item_reg;
cost_struct_t cost_reg;

  assign coins_t   = coins;
  assign buttons_t = buttons;
  assign item_t    = items;
  assign status  = status_t;

// initial condition
  always_ff@(posedge clk) begin
  if(hrst)	begin
  	product	<= '0;
  	status 	<= '0;
  	balance <= '0;
  	info	  <= '0;
  	state   <= IDLE;
  	timer   <= '1;		// set timer to max value for down count
  end
  // add soft reset logic
  else begin
  	product	<= product;
  	status 	<= status;
  	balance <= balance;
  	info	  <= info;
  	state   <= next_state;
  	timer   <= timer;		
  end
  end // always_ff block for  initial condition 

// watchdog timer logic using down counter
  assign timeout = (timer == '0) ? 1 : 0;
  always_ff@(posedge clk)
  if(start_timer)	begin
  	timer = timer - 1'b1;
  else
  	timer = '1;
  end

// FSM output logic
  always_comb begin
    // default value for outputs and internal variables for each state
    {product, status, balance, info, amount, insert_coins, insufficient_amount} = '0;
    
    unique case (1'b1) 	// reverse case
  	state[IDLE_INDEX] 	      : begin /* default value for each output already assigned above  */ end

  	state[CHECK_ITEM_COUNT_INDEX] : begin 
  					//if(buttons_t == A)	// WATER
  					unique case (buttons_t)	// reverse case
  					 A:	begin
  						if(WATER_COUNT != 0)
  						status = AVAILABE;
  						else
  						status = OUT_OF_STOCK;
  						end
  					//if(buttons_t == B)	// COLA
  					 B:	begin
  						if(COLA_COUNT != 0)
  						status = AVAILABE;
  						else
  						status = OUT_OF_STOCK;
  						end
  					//if(buttons_t == C)	// PEPSI
  					 C:	begin
  						if(PEPSI_COUNT != 0)
  						status = AVAILABE;
  						else
  						status = OUT_OF_STOCK;
  					//if(buttons_t == D)	// FANTA
  					 D:	begin
  						if(FANTA_COUNT != 0)
  						status = AVAILABE;
  						else
  						status = OUT_OF_STOCK;
  						end
  					//if(buttons_t == E)	// COFFEE
  					 E:	begin
  						if(COFFEE_COUNT != 0)
  						status = AVAILABE;
  						else
  						status = OUT_OF_STOCK;
  						end
  					//if(buttons_t == F)	// CHIPS
  					 F:	begin
  						if(CHIPS_COUNT != 0)
  						status = AVAILABE;
  						else
  						status = OUT_OF_STOCK;
  						end
  					//if(buttons_t == G)	// BARS
  					 G:	begin
  						if(BARS_COUNT != 0)
  						status = AVAILABE;
  						else
  						status = OUT_OF_STOCK;
  						end
  					//if(buttons_t == H)	// COOKIE
  					//H:	begin
  					//	if(COOKIE_COUNT != 0)
  					//	status = AVAILABE;
  					//	else
  					//	status = OUT_OF_STOCK;
  					
  					endcase
  
  					insert_coins = 1'b1;
  					end 
  
  	state[INSERT_COINS_INDEX]     : begin 
  				    	//if(!cancel)
  				    	start_timer = 1'b1;
  					if(coins_t == NICKEL)	        amount += 16'h5;	// $0.05
  					else if (coins_t == DIME)	amount += 16'hA;	// $0.10		
  					else if (coins_t == QUARTER)	amount += 16'h19;	// $0.25
  					else				amount = amount;			
  					//else amount = 0;			
  					// make insert coins control signal low
  					insert_coins = 1'b0;
  			                end
  
  	// if(!cancel && !insert_coins)
  	state[CHECK_BALANCE]          : begin 
  				    	start_timer = 1'b0;
  					if(buttons_t == A)	// WATER
  					  if(amount >= cost_reg.COST_OF_WATER)	       balance = amount - cost_reg.COST_OF_WATER;
  					  else if(amount < cost_reg.COST_OF_WATER)     insufficient_amount = 1'b1;
  					  else 					       balance = 0;
  					else if(buttons_t == B)	// COLA
  					  if(amount >= cost_reg.COST_OF_COLA)	       balance = amount - cost_reg.COST_OF_COLA;
  					  else if(amount < cost_reg.COST_OF_COLA)      insufficient_amount = 1'b1;
  					  else 					       balance = 0;
  					else if(buttons_t == C)	// PEPSI
  					  if(amount >= cost_reg.COST_OF_PEPSI)	        balance = amount - cost_reg.COST_OF_PEPSI;
  					  else if (amount < cost_reg.COST_OF_PEPSI)	insufficient_amount = 1'b1;
  					  else 					        balance = 0;
  					else if(buttons_t == D)	// FANTA
  					  if(amount >= cost_reg.COST_OF_FANTA)	        balance = amount - cost_reg.COST_OF_FANTA;
  					  else if (amount < cost_reg.COST_OF_FANTA)	insufficient_amount = 1'b1;
  					  else 					        balance = 0;
  					else if(buttons_t == E)	// COFFEE
  					  if(amount >= cost_reg.COST_OF_COFFEE)	        balance = amount - cost_reg.COST_OF_COFFEE;
  					  else if (amount < cost_reg.COST_OF_COFFEE)	insufficient_amount = 1'b1;
  					  else 					        balance = 0;
  					else if(buttons_t == F)	// CHIPS
  					  if(amount >= cost_reg.COST_OF_CHIPS)	        balance = amount - cost_reg.COST_OF_CHIPS;
  					  else if (amount < cost_reg.COST_OF_CHIPS)	insufficient_amount = 1'b1;
  					  else 					        balance = 0;
  					else if(buttons_t == G)	// BARS
  					  if(amount >= cost_reg.COST_OF_BARS)	        balance = amount - cost_reg.COST_OF_BARS;
  					  else if (amount < cost_reg.COST_OF_BARS)	insufficient_amount = 1'b1;
  					  else 					        balance = 0;
  					//if(buttons_t == H)	// COOKIE
  					//if(amount >= cost_reg.COST_OF_COOKIE)	       balance = amount - cost_reg.COST_OF_COOKIE;
  					//if(amount >= cost_reg.COST_OF_COOKIE)        status_t = ERROR;	
  					//else 					       balance = 0;
  					end
  
          state[RESTOCK_INDEX]	      : begin
  					  // update the stock
  					  unique case(item)
  						WATER: 	begin	
  							  if(item_count.WATER_COUNT + count > 5'h10)	status_t = ERROR;
  							  else 						item_count.WATER_COUNT = item_count.WATER_COUNT + count;
  							end
  						COLA:	begin	
  							  if(item_count.COLA_COUNT + count > 5'h10)	status_t = ERROR;
  							  else 						item_count.COLA_COUNT = item_count.COLA_COUNT + count;
  							end
  						PEPSI:	begin	
  							  if(item_count.PEPSI_COUNT + count > 5'h10)	status_t = ERROR;
  						       	  else 						item_count.PEPSI_COUNT = item_count.PEPSI_COUNT + count;
  							end
  						FANTA:  begin
  							  if(item_count.FANTA_COUNT + count > 5'h10)	status_t = ERROR;
  							  else 						item_count.FANTA_COUNT = item_count.FANTA_COUNT + count;
  							end
  						COFFEE:	begin	
  							  if(item_count.COFFEE_COUNT + count > 5'h10)	status_t = ERROR;
  							  else 						item_count.COFFEE_COUNT = item_count.COFFEE_COUNT + count;
  							end
  						CHIPS:	begin	
  							  if(item_count.CHIPS_COUNT + count > 5'h10)	status_t = ERROR;
  							  else 						item_count.CHIPS_COUNT = item_count.CHIPS_COUNT + count;
  							end
  						BARS:	begin	
  							  if(item_count.BARS_COUNT + count > 5'h10)	status_t = ERROR;
  							  else 						item_count.BARS_COUNT = item_count.BARS_COUNT + count;
  							end
  					//	COOKIE: begin	
  					//		  if(item_count.COOKIE_COUNT + count > 5'h10)	status_t = ERROR;
  					//		  else item_count.COOKIE_COUNT = item_count.COOKIE_COUNT + count;
  			   		//		end	
  					  endcase
  					if(cost)
  					  unique case(item_t)
  						WATER : item_cost.COST_OF_WATER  = cost;	
  					
  						COLA  :	item_cost.COST_OF_COLA   = cost;		
  					
  						PEPSI :	item_cost.COST_OF_PEPSI  = cost;	
  					
  						FANTA :	item_cost.COST_OF_FANTA  = cost;	
  					
  						COFFEE:	item_cost.COST_OF_COFFEE = cost;		
  					
  						CHIPS :	item_cost.COST_OF_CHIPS  = cost;		
  			
  						BARS  :	item_cost.COST_OF_BARS   = cost;	
  			
  						//COOKIE:	item_cost.COST_OF_COOKIE = cost;		
  					  endcase
  					else begin
  					  item_cost.COST_OF_WATER = item_cost.COST_OF_WATER;						
  					  item_cost.COST_OF_COLA = item_cost.COST_OF_COLA ;							
  					  item_cost.COST_OF_PEPSI = item_cost.COST_OF_PEPSI;						
  					  item_cost.COST_OF_FANTA = item_cost.COST_OF_FANTA;
  					  item_cost.COST_OF_COFFEE = item_cost.COST_OF_COFFEE;						
  					  item_cost.COST_OF_CHIPS = item_cost.COST_OF_CHIPS;					
  					  item_cost.COST_OF_BARS = item_cost.COST_OF_BARS;				
  					  //item_cost.COST_OF_COOKIE = item_cost.COST_OF_COOKIE;
  					end
  					end	// end of RESTOCK case
  				
  	state[DISPENSE_ITEM_INDEX]  : begin 
  	 				//product = item;
  	 				unique case(buttons_t)
  						A : product  = WATER;	
  					
  						B :	product  = COLA;		
  					
  						C :	product  = PEPSI;	
  					
  						D :	product  = FANTA;	
  					
  						E :	product  = COFFEE;		
  					
  						F :	product  = CHIPS;		
  			
  						G :	product  = BARS;	
  			
  						//H:	product  = COOKIE;	
  					  endcase	
  				      end	
  
  	endcase // FSM output logic case
  
  end // FSM outputs always_comb block
  
  // FSM Next state logic 
  always_comb begin
  
  	next_state = state; // default value for each state
  
  	unique case(1'b1)	// reverse case
  	
  	state[IDLE_INDEX]             : begin 
  			                if(valid)			next_state = RESTOCK;
  			                else if (!valid && !buttons) 	next_state = IDLE;
  			                else if (!valid && buttons)	next_state = CHECK_ITEM_COUNT;
  			                end
  
  	state[CHECK_ITEM_COUNT_INDEX] : begin 
  					if(insert_coins && status_t == AVAILABE)	next_state = INSERT_COINS;
  					else if(!insert_coins && status_t == AVAILABE)	next_state = CHECK_ITEM_COUNT;
  					// if the requested item is not available, go back to IDLE state
  					else if (status_t != AVAILABE)			next_state = IDLE;
  					end
  
  	state[INSERT_COINS_INDEX]     : begin 
  					if(coins && !insert_coins)			next_state = CHECK_BALANCE;
  					// wait for coins till timeout 
      else if(!coins && !timeout)			next_state = INSERT_COINS;
  					// if no coins inserted and timeout occurs, go back to IDLE
      else if(!coins && timeout || status_t == ERROR)	next_state = IDLE;
  					end
  
  	state[CHECK_BALANCE]          : begin 
  					if(status_t == ERROR)		next_state = IDLE;
  					else if(insufficient_amount)	next_state = INSERT_COINS;
  					else 				next_state = DISPENSE_ITEM;
  					end
  
    	state[RESTOCK_INDEX]	      : begin
  					if(!valid)	next_state = IDLE;
  					else		next_state = RESTOCK;
  					end
  	
    	state[DISPENSE_ITEM_INDEX]    : begin
  					next_state = IDLE;
  					end
          endcase
  
  end // FSM Next state logic

endmodule
