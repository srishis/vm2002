
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

import vm2002_common_pkg::*;

// internal variables
logic [8:0] timer;				// 9 bit down counter which counts 512 clocks
logic start_timer;				// control signal for internal timer	
logic [15:0] prev_balance;
logic [15:0] prev_amount;
logic insufficient_amount;

fsm_state_t state, next_state;
item_count_struct_t item_reg;
cost_struct_t cost_reg;
coins_t coin;
buttons_t button;
item_t items;
status_t stat;
//assign coin   = coins;
//assign button = buttons;
//assign items  = item;
//assign status = stat;
always_comb begin
$cast(coin, coins);
$cast(button, buttons);
$cast(items, item);
$cast(stat, status);
end

// initial condition
  always_ff@(posedge clk) begin
  if(hrst) begin state        <= IDLE;
  	         timer        <= '1;		// set timer to max value for down count
		 //prev_balance <= '0;
  end
  else begin state        <= next_state;
  	     timer        <= timer;		
	     //prev_balance <= prev_balance;
  end
  end // always_ff block for  initial condition 

  // add soft reset logic to restore previous balance
  always@(srst) begin
  //prev_balance <= balance;
  prev_amount  <= amount;
  end

  /*
  task soft_reset();
	// on soft reset, maintain balance, timer, inventory and cost of item
  	amount 		  	  = amount;
	item_reg.WATER_COUNT      = item_reg.WATER_COUNT;
	item_reg.COLA_COUNT       = item_reg.COLA_COUNT;
	item_reg.PEPSI_COUNT      = item_reg.PEPSI_COUNT;
	item_reg.FANTA_COUNT      = item_reg.FANTA_COUNT;
	item_reg.COFFEE_COUNT     = item_reg.COFFEE_COUNT;
	item_reg.CHIPS_COUNT      = item_reg.CHIPS_COUNT;
	item_reg.BARS_COUNT       = item_reg.BARS_COUNT;
	//item_reg.COOKIE_COUNT   = item_reg.COOKIE_COUNT;
	cost_reg.COST_OF_WATER    = cost_reg.COST_OF_WATER;						
  	cost_reg.COST_OF_COLA     = cost_reg.COST_OF_COLA;							
  	cost_reg.COST_OF_PEPSI    = cost_reg.COST_OF_PEPSI;				
  	cost_reg.COST_OF_FANTA    = cost_reg.COST_OF_FANTA;
   	cost_reg.COST_OF_COFFEE   = cost_reg.COST_OF_COFFEE;						
        cost_reg.COST_OF_CHIPS    = cost_reg.COST_OF_CHIPS;					
        cost_reg.COST_OF_BARS     = cost_reg.COST_OF_BARS;				
        //cost_reg.COST_OF_COOKIE = cost_reg.COST_OF_COOKIE;
  end
  endtask // soft_reset
  */

// watchdog timer logic using down counter
  assign timeout = (timer == '0) ? 1 : 0;
  always_ff@(posedge clk) begin
  if(start_timer) timer <= timer - 1'b1;
  else		  timer <= '1;
  end

// FSM output logic
  always_comb begin
    // default value for outputs and internal variables for each state
    {product, status, info, balance, amount, insert_coins, insufficient_amount} = '0;
    
    unique case (1'b1) 	// reverse case
  	state[IDLE_INDEX] 	      : begin  end

  	state[CHECK_ITEM_COUNT_INDEX] : begin 
  					//if(button == A)	// WATER
  					unique case (button)	// reverse case
  					 A:	begin
  						if(item_reg.WATER_COUNT != 0) begin
  						status = AVAILABE;
						info = cost_reg.COST_OF_WATER;
						end
  						else
  						status = OUT_OF_STOCK;
  						end
  					//if(button == B)	// COLA
  					 B:	begin
  						if(item_reg.COLA_COUNT != 0) begin
  						status = AVAILABE;
						info = cost_reg.COST_OF_COLA;
						end
  						else
  						status = OUT_OF_STOCK;
  						end
  					//if(button == C)	// PEPSI
  					 C:	begin
  						if(item_reg.PEPSI_COUNT != 0) begin
  						status = AVAILABE;
						info = cost_reg.COST_OF_PEPSI;
						end
  						else
  						status = OUT_OF_STOCK;
  						end
  					//if(button == D)	// FANTA
  					 D:	begin
  						if(item_reg.FANTA_COUNT != 0) begin
  						status = AVAILABE;
						info = cost_reg.COST_OF_FANTA;
						end
  						else
  						status = OUT_OF_STOCK;
  						end
  					//if(button == E)	// COFFEE
  					 E:	begin
  						if(item_reg.COFFEE_COUNT != 0) begin
  						status = AVAILABE;
						info = cost_reg.COST_OF_COFFEE;
						end
  						else
  						status = OUT_OF_STOCK;
  						end
  					//if(button == F)	// CHIPS
  					 F:	begin
  						if(item_reg.CHIPS_COUNT != 0) begin
  						status = AVAILABE;
						info = cost_reg.COST_OF_CHIPS;
						end
  						else
  						status = OUT_OF_STOCK;
  						end
  					//if(button == G)	// BARS
  					 G:	begin
  						if(item_reg.BARS_COUNT != 0) begin
  						status = AVAILABE;
						info = cost_reg.COST_OF_BARS;
						end
  						else
  						status = OUT_OF_STOCK;
  						end
  					//if(button == H)	// COOKIE
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
					//while(!select) begin	
					if(coin == NICKEL)	        amount += prev_amount + 16'h5;	// $0.05
					else if (coin == DIME)		amount += prev_amount + 16'hA;	// $0.10		
					else if (coin == QUARTER)	amount += prev_amount + 16'h19;	// $0.25
					else				amount  = prev_amount + amount;			
					//else amount = 0;			
					// make insert coins control signal low
					balance = '0;
					//insert_coins = 1'b0;
					end
					  
  
  	// compare cost with amount inserted by user and compute balance 
  	state[CHECK_BALANCE]          : begin 
  				    	start_timer = 1'b0;
  					if(button == A)	// WATER
  					  if(amount > cost_reg.COST_OF_WATER)	        balance = amount - cost_reg.COST_OF_WATER;
  					  else if(amount < cost_reg.COST_OF_WATER)      insufficient_amount = 1'b1;
  					  else 					        balance = 0;
  					else if(button == B)	// COLA
  					  if(amount > cost_reg.COST_OF_COLA)	        balance = amount - cost_reg.COST_OF_COLA;
  					  else if(amount < cost_reg.COST_OF_COLA)       insufficient_amount = 1'b1;
  					  else 					        balance = 0;
  					else if(button == C)	// PEPSI
  					  if(amount > cost_reg.COST_OF_PEPSI)	        balance = amount - cost_reg.COST_OF_PEPSI;
  					  else if (amount < cost_reg.COST_OF_PEPSI)	insufficient_amount = 1'b1;
  					  else 					        balance = 0;
  					else if(button == D)	// FANTA
  					  if(amount > cost_reg.COST_OF_FANTA)	        balance = amount - cost_reg.COST_OF_FANTA;
  					  else if (amount < cost_reg.COST_OF_FANTA)	insufficient_amount = 1'b1;
  					  else 					        balance = 0;
  					else if(button == E)	// COFFEE
  					  if(amount > cost_reg.COST_OF_COFFEE)	        balance = amount - cost_reg.COST_OF_COFFEE;
  					  else if (amount < cost_reg.COST_OF_COFFEE)	insufficient_amount = 1'b1;
  					  else 					        balance = 0;
  					else if(button == F)	// CHIPS
  					  if(amount > cost_reg.COST_OF_CHIPS)	        balance = amount - cost_reg.COST_OF_CHIPS;
  					  else if (amount < cost_reg.COST_OF_CHIPS)	insufficient_amount = 1'b1;
  					  else 					        balance = 0;
  					else if(button == G)	// BARS
  					  if(amount > cost_reg.COST_OF_BARS)	        balance = amount - cost_reg.COST_OF_BARS;
  					  else if (amount < cost_reg.COST_OF_BARS)	insufficient_amount = 1'b1;
  					  else 					        balance = 0;
  					//if(button == H)	// COOKIE
  					//if(amount > cost_reg.COST_OF_COOKIE)	       balance = amount - cost_reg.COST_OF_COOKIE;
  					//if(amount > cost_reg.COST_OF_COOKIE)         stat = ERROR;	
  					//else 					       balance = 0;
  					end
  
          state[RESTOCK_INDEX]	      : begin
  					  // update the stock
  					  unique case(items)
  						WATER: 	begin	
  							  if(item_reg.WATER_COUNT + count > 5'h10)	stat = ERROR;
  							  else 						item_reg.WATER_COUNT = item_reg.WATER_COUNT + count;
  							end
  						COLA:	begin	
  							  if(item_reg.COLA_COUNT + count > 5'h10)	stat = ERROR;
  							  else 						item_reg.COLA_COUNT = item_reg.COLA_COUNT + count;
  							end
  						PEPSI:	begin	
  							  if(item_reg.PEPSI_COUNT + count > 5'h10)	stat = ERROR;
  						       	  else 						item_reg.PEPSI_COUNT = item_reg.PEPSI_COUNT + count;
  							end
  						FANTA:  begin
  							  if(item_reg.FANTA_COUNT + count > 5'h10)	stat = ERROR;
  							  else 						item_reg.FANTA_COUNT = item_reg.FANTA_COUNT + count;
  							end
  						COFFEE:	begin	
  							  if(item_reg.COFFEE_COUNT + count > 5'h10)	stat = ERROR;
  							  else 						item_reg.COFFEE_COUNT = item_reg.COFFEE_COUNT + count;
  							end
  						CHIPS:	begin	
  							  if(item_reg.CHIPS_COUNT + count > 5'h10)	stat = ERROR;
  							  else 						item_reg.CHIPS_COUNT = item_reg.CHIPS_COUNT + count;
  							end
  						BARS:	begin	
  							  if(item_reg.BARS_COUNT + count > 5'h10)	stat = ERROR;
  							  else 						item_reg.BARS_COUNT = item_reg.BARS_COUNT + count;
  							end
  					//	COOKIE: begin	
  					//		  if(item_reg.COOKIE_COUNT + count > 5'h10)	stat = ERROR;
  					//		  else item_reg.COOKIE_COUNT = item_reg.COOKIE_COUNT + count;
  			   		//		end	
  					  endcase
  					// update the cost of items
  					if(cost)
  					  unique case(items)
  						WATER : cost_reg.COST_OF_WATER  = cost;	
  					
  						COLA  :	cost_reg.COST_OF_COLA   = cost;		
  					
  						PEPSI :	cost_reg.COST_OF_PEPSI  = cost;	
  					
  						FANTA :	cost_reg.COST_OF_FANTA  = cost;	
  					
  						COFFEE:	cost_reg.COST_OF_COFFEE = cost;		
  					
  						CHIPS :	cost_reg.COST_OF_CHIPS  = cost;		
  			
  						BARS  :	cost_reg.COST_OF_BARS   = cost;	
  			
  						//COOKIE:	cost_reg.COST_OF_COOKIE = cost;		
  					  endcase
  					else begin
  					  cost_reg.COST_OF_WATER  = cost_reg.COST_OF_WATER;						
  					  cost_reg.COST_OF_COLA   = cost_reg.COST_OF_COLA ;							
  					  cost_reg.COST_OF_PEPSI  = cost_reg.COST_OF_PEPSI;						
  					  cost_reg.COST_OF_FANTA  = cost_reg.COST_OF_FANTA;
  					  cost_reg.COST_OF_COFFEE = cost_reg.COST_OF_COFFEE;						
  					  cost_reg.COST_OF_CHIPS  = cost_reg.COST_OF_CHIPS;					
  					  cost_reg.COST_OF_BARS   = cost_reg.COST_OF_BARS;				
  					  //cost_reg.COST_OF_COOKIE = cost_reg.COST_OF_COOKIE;
  					end
  					end	// end of RESTOCK case
  				
  	state[DISPENSE_ITEM_INDEX]  : begin 
  	 				//product = item;
  	 				unique case(button)
  						A : 	begin product  = WATER;   item_reg.WATER_COUNT  = item_reg.WATER_COUNT - 1'b1; end	
  					
  						B :	begin product  = COLA;	  item_reg.COLA_COUNT   = item_reg.COLA_COUNT - 1'b1; end	
  					
  						C :	begin product  = PEPSI;   item_reg.PEPSI_COUNT  = item_reg.PEPSI_COUNT - 1'b1; end	
  					
  						D :	begin product  = FANTA;   item_reg.FANTA_COUNT  = item_reg.FANTA_COUNT - 1'b1; end	
  					
  						E :	begin product  = COFFEE;  item_reg.COFFEE_COUNT = item_reg.COFFEE_COUNT - 1'b1; end		
  					
  						F :	begin product  = CHIPS;	  item_reg.CHIPS_COUNT  = item_reg.CHIPS_COUNT - 1'b1; end	
  			
  						G :	begin product  = BARS;    item_reg.BARS_COUNT   = item_reg.BARS_COUNT - 1'b1; end	
  			
  						//H:	begin product  = COOKIE;	
  					  endcase	
  				      end	
  
  	endcase // FSM output logic case
  
  end // FSM outputs always_comb block
  
  // FSM Next state logic 
  always_comb begin
  
  	next_state = state; // default value for each state
  
  	unique case(1'b1)	// reverse case
  	
  	state[IDLE_INDEX]             : begin 
					// if supplier press valid, enter in RESTOCK state
  			                if(valid)			 	next_state = RESTOCK;
					// if no valid or buttons are pressed, stay in this state
  			                else if (!valid && !buttons || srst) 	next_state = IDLE;
					// if no valid and user presses a button, go to CHECK_ITEM_COUNT state
  			                else if (!valid && buttons)		next_state = CHECK_ITEM_COUNT;
  			                end
  
  	state[CHECK_ITEM_COUNT_INDEX] : begin 
					// if insert coins is asserted and status indicates requested item is available, go to INSERT_COINS state. 
  					if(insert_coins && stat == AVAILABE)		next_state = INSERT_COINS;
					// if insert coins is deasserted and status indicates requested item is available, stay in this state. 
  					else if(!insert_coins && stat == AVAILABE)	next_state = CHECK_ITEM_COUNT;
  					// if status indicates the requested item is not available, go back to IDLE state
  					else if (stat != AVAILABE || srst)		next_state = IDLE;
  					end
  
  	state[INSERT_COINS_INDEX]     : begin 
  					if(select)			 	       	 	next_state = CHECK_BALANCE;
  					// wait for user to insert coins and then press select till timeout
  					else if(!select && !timeout)			 	next_state = INSERT_COINS;
  					// if no coins are inserted or user doesn't press select and timeout occurs, go back to IDLE
  					else if(!select && timeout || stat == ERROR || srst)    next_state = IDLE;
  					end
  
  	state[CHECK_BALANCE]          : begin 
  					if(stat == ERROR || srst)	next_state = IDLE;
  					else if(insufficient_amount)	next_state = INSERT_COINS;
  					else 				next_state = DISPENSE_ITEM;
  					end
  
       state[RESTOCK_INDEX]	      : begin
  					if(!valid || srst)	next_state = IDLE;
  					else			next_state = RESTOCK;
  					end
  	
      state[DISPENSE_ITEM_INDEX]      : begin
  					next_state = IDLE;
  					end

  //    state[SOFT_RESET_INDEX]         : begin
  //      				next_state = IDLE;	
  //					end
          endcase
  
  end // FSM Next state logic

endmodule
