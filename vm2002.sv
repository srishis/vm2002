
// RTL Design for vm2002 

`include "vm2002_pkg.svh"
//module vm2002(pif.product, pif.status, pif.balance, pif.info, pif.clk, pif.hrst, pif.srst, pif.coins, pif.buttons, pif.select, pif.item, pif.count, pif.cost, pif.valid);
module vm2002(vm2002_if pif);

import vm2002_common_pkg::*;

fsm_state_t state, next_state;
item_count_struct_t item_reg;
cost_struct_t cost_reg;
//pif.coins_t coin;
//pif.buttons_t button;
//pif.item_t pif.items;
//pif.status_t stat;
//always_comb begin
//  $cast(coin, pif.coins);
//  $cast(button, pif.buttons);
//  $cast(pif.items, pif.item);
//  $cast(stat, pif.status);
//end

// initial condition
  always_ff@(posedge pif.clk) begin
  if(pif.hrst) begin state       <= IDLE;
  	         pif.timer   <= '1;		// set pif.timer to max value for down count
		 //prev_balance <= '0;
  end
  else begin state        <= next_state;
  	     pif.timer    <= pif.timer;		
	     //prev_balance <= prev_balance;
  end
  end // always_ff block for  initial condition 

  // add soft reset logic to restore previous balance
  always@(pif.srst) begin
  //prev_balance <= pif.balance;
  pif.prev_amount  <= pif.amount;
  end


// watchdog timer logic using down pif.counter
  assign timeout = (pif.timer == '0) ? 1 : 0;
  always_ff@(posedge pif.clk) begin
  if(pif.start_timer) pif.timer <= pif.timer - 1'b1;
  else		      pif.timer <= '1;
  end

// FSM output logic
  always_comb begin
    // default value for outputs and internal variables for each state
    {pif.product, pif.status, pif.info, pif.balance, pif.amount, pif.insert_coins, pif.insufficient_amount} = '0;
    
    unique case (1'b1) 	// reverse case
  	state[IDLE_INDEX] 	      : begin  end

  	state[CHECK_ITEM_COUNT_INDEX] : begin 
  					//if(button == A)	// WATER
  					unique case (pif.buttons)	// reverse case
  					 A:	begin
  						if(item_reg.WATER_COUNT != 0) begin
  						pif.status = AVAILABLE;
						pif.info = cost_reg.COST_OF_WATER;
						end
  						else
  						pif.status = OUT_OF_STOCK;
  						end
  					//if(button == B)	// COLA
  					 B:	begin
  						if(item_reg.COLA_COUNT != 0) begin
  						pif.status = AVAILABLE;
						pif.info = cost_reg.COST_OF_COLA;
						end
  						else
  						pif.status = OUT_OF_STOCK;
  						end
  					//if(button == C)	// PEPSI
  					 C:	begin
  						if(item_reg.PEPSI_COUNT != 0) begin
  						pif.status = AVAILABLE;
						pif.info = cost_reg.COST_OF_PEPSI;
						end
  						else
  						pif.status = OUT_OF_STOCK;
  						end
  					//if(button == D)	// FANTA
  					 D:	begin
  						if(item_reg.FANTA_COUNT != 0) begin
  						pif.status = AVAILABLE;
						pif.info = cost_reg.COST_OF_FANTA;
						end
  						else
  						pif.status = OUT_OF_STOCK;
  						end
  					//if(button == E)	// COFFEE
  					 E:	begin
  						if(item_reg.COFFEE_COUNT != 0) begin
  						pif.status = AVAILABLE;
						pif.info = cost_reg.COST_OF_COFFEE;
						end
  						else
  						pif.status = OUT_OF_STOCK;
  						end
  					//if(button == F)	// CHIPS
  					 F:	begin
  						if(item_reg.CHIPS_COUNT != 0) begin
  						pif.status = AVAILABLE;
						pif.info = cost_reg.COST_OF_CHIPS;
						end
  						else
  						pif.status = OUT_OF_STOCK;
  						end
  					//if(button == G)	// BARS
  					 G:	begin
  						if(item_reg.BARS_COUNT != 0) begin
  						pif.status = AVAILABLE;
						pif.info = cost_reg.COST_OF_BARS;
						end
  						else
  						pif.status = OUT_OF_STOCK;
  						end
  					endcase
  
  					pif.insert_coins = 1'b1;
  					end 
  
  	state[INSERT_COINS_INDEX]     : begin 
  				    	pif.start_timer = 1'b1;
					if(pif.coins == NICKEL)	        pif.amount += pif.prev_amount + 16'h5;	// $0.05
					else if (pif.coins == DIME)		pif.amount += pif.prev_amount + 16'hA;	// $0.10		
					else if (pif.coins == QUARTER)	pif.amount += pif.prev_amount + 16'h19;	// $0.25
					else				pif.amount  = pif.amount;			
					//pif.balance = '0;
					end
					  
  
  	// compare cost with amount inserted by user and compute pif.balance 
  	state[CHECK_BALANCE]          : begin 
  				    	pif.start_timer = 1'b0;
  					if(pif.buttons == A)	// WATER
  					  if(pif.amount > cost_reg.COST_OF_WATER)	pif.balance = pif.amount - cost_reg.COST_OF_WATER;
  					  else if(pif.amount < cost_reg.COST_OF_WATER)  pif.insufficient_amount = 1'b1;
  					  else 					        pif.balance = 0;
  					else if(pif.buttons == B)	// COLA
  					  if(pif.amount > cost_reg.COST_OF_COLA)	pif.balance = pif.amount - cost_reg.COST_OF_COLA;
  					  else if(pif.amount < cost_reg.COST_OF_COLA)   pif.insufficient_amount = 1'b1;
  					  else 					        pif.balance = 0;
  					else if(pif.buttons == C)	// PEPSI
  					  if(pif.amount > cost_reg.COST_OF_PEPSI)	pif.balance = pif.amount - cost_reg.COST_OF_PEPSI;
  					  else if (pif.amount < cost_reg.COST_OF_PEPSI)	pif.insufficient_amount = 1'b1;
  					  else 					        pif.balance = 0;
  					else if(pif.buttons == D)	// FANTA
  					  if(pif.amount > cost_reg.COST_OF_FANTA)	pif.balance = pif.amount - cost_reg.COST_OF_FANTA;
  					  else if (pif.amount < cost_reg.COST_OF_FANTA)	pif.insufficient_amount = 1'b1;
  					  else 					        pif.balance = 0;
  					else if(pif.buttons == E)	// COFFEE
  					  if(pif.amount > cost_reg.COST_OF_COFFEE)	pif.balance = pif.amount - cost_reg.COST_OF_COFFEE;
  					  else if (pif.amount < cost_reg.COST_OF_COFFEE)pif.insufficient_amount = 1'b1;
  					  else 					        pif.balance = 0;
  					else if(pif.buttons == F)	// CHIPS
  					  if(pif.amount > cost_reg.COST_OF_CHIPS)	pif.balance = pif.amount - cost_reg.COST_OF_CHIPS;
  					  else if (pif.amount < cost_reg.COST_OF_CHIPS)	pif.insufficient_amount = 1'b1;
  					  else 					        pif.balance = 0;
  					else if(pif.buttons == G)	// BARS
  					  if(pif.amount > cost_reg.COST_OF_BARS)	pif.balance = pif.amount - cost_reg.COST_OF_BARS;
  					  else if (pif.amount < cost_reg.COST_OF_BARS)	pif.insufficient_amount = 1'b1;
  					  else 					        pif.balance = 0;
  					end
  
          state[RESTOCK_INDEX]	      : begin
  					  // update the stock
  					  unique case(pif.item)
  						WATER: 	begin	
  							  if(item_reg.WATER_COUNT + pif.count > 5'h10)	pif.status = ERROR;
  							  else 						item_reg.WATER_COUNT = item_reg.WATER_COUNT + pif.count;
  							end
  						COLA:	begin	
  							  if(item_reg.COLA_COUNT + pif.count > 5'h10)	pif.status = ERROR;
  							  else 						item_reg.COLA_COUNT = item_reg.COLA_COUNT + pif.count;
  							end
  						PEPSI:	begin	
  							  if(item_reg.PEPSI_COUNT + pif.count > 5'h10)	pif.status = ERROR;
  						       	  else 						item_reg.PEPSI_COUNT = item_reg.PEPSI_COUNT + pif.count;
  							end
  						FANTA:  begin
  							  if(item_reg.FANTA_COUNT + pif.count > 5'h10)	pif.status = ERROR;
  							  else 						item_reg.FANTA_COUNT = item_reg.FANTA_COUNT + pif.count;
  							end
  						COFFEE:	begin	
  							  if(item_reg.COFFEE_COUNT + pif.count > 5'h10)	pif.status = ERROR;
  							  else 						item_reg.COFFEE_COUNT = item_reg.COFFEE_COUNT + pif.count;
  							end
  						CHIPS:	begin	
  							  if(item_reg.CHIPS_COUNT + pif.count > 5'h10)	pif.status = ERROR;
  							  else 						item_reg.CHIPS_COUNT = item_reg.CHIPS_COUNT + pif.count;
  							end
  						BARS:	begin	
  							  if(item_reg.BARS_COUNT + pif.count > 5'h10)	pif.status = ERROR;
  							  else 						item_reg.BARS_COUNT = item_reg.BARS_COUNT + pif.count;
  							end
  					  endcase
  					// update the cost of items
  					if(pif.cost)
  					  unique case(pif.item)
  						WATER : cost_reg.COST_OF_WATER  = pif.cost;	
  					
  						COLA  :	cost_reg.COST_OF_COLA   = pif.cost;		
  					
  						PEPSI :	cost_reg.COST_OF_PEPSI  = pif.cost;	
  					
  						FANTA :	cost_reg.COST_OF_FANTA  = pif.cost;	
  					
  						COFFEE:	cost_reg.COST_OF_COFFEE = pif.cost;		
  					
  						CHIPS :	cost_reg.COST_OF_CHIPS  = pif.cost;		
  			
  						BARS  :	cost_reg.COST_OF_BARS   = pif.cost;	
  			
  					  endcase
  					else begin
  					  cost_reg.COST_OF_WATER  = cost_reg.COST_OF_WATER;						
  					  cost_reg.COST_OF_COLA   = cost_reg.COST_OF_COLA ;							
  					  cost_reg.COST_OF_PEPSI  = cost_reg.COST_OF_PEPSI;						
  					  cost_reg.COST_OF_FANTA  = cost_reg.COST_OF_FANTA;
  					  cost_reg.COST_OF_COFFEE = cost_reg.COST_OF_COFFEE;						
  					  cost_reg.COST_OF_CHIPS  = cost_reg.COST_OF_CHIPS;					
  					  cost_reg.COST_OF_BARS   = cost_reg.COST_OF_BARS;				
  					end
  					end	// end of RESTOCK case
  				
  	state[DISPENSE_ITEM_INDEX]  : begin 
  	 				unique case(pif.buttons)
  						A : 	begin pif.product  = WATER;   item_reg.WATER_COUNT  = item_reg.WATER_COUNT - 1'b1; end	
  					
  						B :	begin pif.product  = COLA;  item_reg.COLA_COUNT   = item_reg.COLA_COUNT - 1'b1; end	
  					
  						C :	begin pif.product  = PEPSI;   item_reg.PEPSI_COUNT  = item_reg.PEPSI_COUNT - 1'b1; end	
  					
  						D :	begin pif.product  = FANTA;   item_reg.FANTA_COUNT  = item_reg.FANTA_COUNT - 1'b1; end	
  					
  						E :	begin pif.product  = COFFEE;  item_reg.COFFEE_COUNT = item_reg.COFFEE_COUNT - 1'b1; end		
  					
  						F :	begin pif.product  = CHIPS;  item_reg.CHIPS_COUNT  = item_reg.CHIPS_COUNT - 1'b1; end	
  			
  						G :	begin pif.product  = BARS;    item_reg.BARS_COUNT   = item_reg.BARS_COUNT - 1'b1; end	
  			
  					  endcase	
  				      end	
  
  	endcase // FSM output logic case
  
  end // FSM outputs always_comb block
  
  // FSM Next state logic 
  always_comb begin
  
  	next_state = state; // default value for each state
  
  	unique case(1'b1)	// reverse case
  	
  	state[IDLE_INDEX]             : begin 
					// if supplier press pif.valid, enter in RESTOCK state
  			                if(pif.valid)			 	next_state = RESTOCK;
					// if no pif.valid or pif.buttons are pressed, stay in this state
  			                else if (!pif.valid && !pif.buttons || pif.srst) 	next_state = IDLE;
					// if no pif.valid and user presses a button, go to CHECK_ITEM_COUNT state
  			                else if (!pif.valid && pif.buttons)		next_state = CHECK_ITEM_COUNT;
  			                end
  
  	state[CHECK_ITEM_COUNT_INDEX] : begin 
					// if insert pif.coins is asserted and pif.status indicates requested pif.item is available, go to INSERT_COINS state. 
  					if(pif.insert_coins && pif.status == AVAILABLE)		next_state = INSERT_COINS;
					// if insert pif.coins is deasserted and pif.status indicates requested pif.item is available, stay in this state. 
  					else if(!pif.insert_coins && pif.status == AVAILABLE)	next_state = CHECK_ITEM_COUNT;
  					// if pif.status indicates the requested pif.item is not available, go back to IDLE state
  					else if (pif.status != AVAILABLE || pif.srst)		next_state = IDLE;
  					end
  
  	state[INSERT_COINS_INDEX]     : begin 
  					if(pif.select)			 	       	 	next_state = CHECK_BALANCE;
  					// wait for user to insert pif.coins and then press pif.select till timeout
  					else if(!pif.select && !timeout)			 	next_state = INSERT_COINS;
  					// if no pif.coins are inserted or user doesn't press pif.select and timeout occurs, go back to IDLE
  					else if(!pif.select && timeout || pif.status == ERROR || pif.srst)    next_state = IDLE;
  					end
  
  	state[CHECK_BALANCE]          : begin 
  					if(pif.status == ERROR || pif.srst)	next_state = IDLE;
  					else if(pif.insufficient_amount)	next_state = INSERT_COINS;
  					else 				next_state = DISPENSE_ITEM;
  					end
  
       state[RESTOCK_INDEX]	      : begin
  					if(!pif.valid)	next_state = IDLE;
  					else		next_state = RESTOCK;
  					end
  	
      state[DISPENSE_ITEM_INDEX]      : begin
  					next_state = IDLE;
  					end

      endcase
  
  end // FSM Next state logic

endmodule
