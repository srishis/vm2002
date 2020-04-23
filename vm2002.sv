
// RTL Design for vm2002 

`include "vm2002_pkg.svh"
//module vm2002(pif.product, pif.status, pif.balance, pif.info, pif.clk, pif.hrst, pif.srst, pif.coins, pif.buttons, pif.select, pif.item, pif.count, pif.cost, pif.valid);
module vm2002(vm2002_if pif);

import vm2002_common_pkg::*;

fsm_state_t state, next_state;
//item_count_struct_t 
//cost_struct_t 

coins_t coin;
buttons_t button;
item_t items;
status_t stat;

always_comb begin
  //$cast(coin, pif.coins);
  //$cast(button, pif.buttons);
  //$cast(items, pif.item);
  $cast(pif.status, stat);
  // cast signals to enum for readability
  coin =  coins_t'(pif.coins);
  button =  buttons_t'(pif.buttons);
  items =  item_t'(pif.item);
  //pif.status =  logic'(stat);
  //stat =  status_t'(pif.status);
end


// initial condition
  always_ff@(posedge pif.clk) begin
  if(pif.hrst) begin state       <= IDLE;
  	         pif.timer   <= '1;		// set pif.timer to max value for down count
		 pif.configure();
		 //prev_balance <= '0;
  end
  else begin state        <= next_state;
  	     pif.timer    <= pif.timer;		
	     //prev_balance <= prev_balance;
  end
  end // always_ff block for  initial condition 

  // add soft reset logic to restore previous balance
  always@(posedge pif.srst, posedge pif.insufficient_amount) begin
  //prev_balance <= pif.balance;
  pif.prev_amount  = pif.amount;
  end


// watchdog timer logic using down pif.counter
  assign vif.timeout = (pif.timer == '0) ? 1 : 0;
  always_ff@(posedge pif.clk) begin
  if(pif.start_timer) pif.timer <= pif.timer - 1'b1;
  else		      pif.timer <= '1;
  end

// FSM output logic
  always_comb begin
    // default value for outputs and internal variables for each state
    {pif.product, stat, pif.info, pif.insert_coins, pif.insufficient_amount, pif.start_timer} = '0;
    
    unique case (1'b1) 	// reverse case
  	state[IDLE_INDEX] 	      : begin  
					pif.amount = '0;
					pif.balance = '0;
					end

	 state[RESTOCK_INDEX]	      : begin
  				    	pif.amount = '0;
  				    	pif.balance = '0;
  					  // update the stock
  					  unique case(items)
  						WATER: 	begin	
  							  if(WATER_COUNT + pif.count > 5'h10)	stat = ERROR;
  							  else 						WATER_COUNT = WATER_COUNT + pif.count; 
  							end
  						COLA:	begin	
  							  if(COLA_COUNT + pif.count > 5'h10)	stat = ERROR;
  							  else 						COLA_COUNT = COLA_COUNT + pif.count;
  							end
  						PEPSI:	begin	
  							  if(PEPSI_COUNT + pif.count > 5'h10)	stat = ERROR;
  						       	  else 						PEPSI_COUNT = PEPSI_COUNT + pif.count;
  							end
  						FANTA:  begin
  							  if(FANTA_COUNT + pif.count > 5'h10)	stat = ERROR;
  							  else 						FANTA_COUNT = FANTA_COUNT + pif.count;
  							end
  						COFFEE:	begin	
  							  if(COFFEE_COUNT + pif.count > 5'h10)	stat = ERROR;
  							  else 						COFFEE_COUNT = COFFEE_COUNT + pif.count;
  							end
  						CHIPS:	begin	
  							  if(CHIPS_COUNT + pif.count > 5'h10)	stat = ERROR;
  							  else 						CHIPS_COUNT = CHIPS_COUNT + pif.count;
  							end
  						BARS:	begin	
  							  if(BARS_COUNT + pif.count > 5'h10)	stat = ERROR;
  							  else 						BARS_COUNT = BARS_COUNT + pif.count;
  							end
  					  endcase
					WATER_COUNT += 4;
					$display("WATER=%h",WATER_COUNT);
  					// update the cost of items
  					if(pif.cost)
  					  unique case(items)
  						WATER : COST_OF_WATER  = pif.cost;	
  					
  						COLA  :	COST_OF_COLA   = pif.cost;		
  					
  						PEPSI :	COST_OF_PEPSI  = pif.cost;	
  					
  						FANTA :	COST_OF_FANTA  = pif.cost;	
  					
  						COFFEE:	COST_OF_COFFEE = pif.cost;		
  					
  						CHIPS :	COST_OF_CHIPS  = pif.cost;		
  			
  						BARS  :	COST_OF_BARS   = pif.cost;	
  			
  					  endcase
  					else begin
  					  COST_OF_WATER  = COST_OF_WATER;						
  					  COST_OF_COLA   = COST_OF_COLA ;							
  					  COST_OF_PEPSI  = COST_OF_PEPSI;						
  					  COST_OF_FANTA  = COST_OF_FANTA;
  					  COST_OF_COFFEE = COST_OF_COFFEE;						
  					  COST_OF_CHIPS  = COST_OF_CHIPS;					
  					  COST_OF_BARS   = COST_OF_BARS;				
  					end
					COST_OF_WATER += 10;
					$display("COSTWATER=%h",COST_OF_WATER);
  					end	// end of RESTOCK case

  	state[CHECK_ITEM_COUNT_INDEX] : begin 
					pif.amount = '0;
					pif.balance = '0;
  					//if(button == A)	// WATER
  					unique case (pif.buttons)	// reverse case
  					 A:	begin
  						if(WATER_COUNT != 0) begin
  						stat = AVAILABLE;
						pif.info = COST_OF_WATER;
						end
  						else
  						stat = OUT_OF_STOCK;
  						end
  					//if(button == B)	// COLA
  					 B:	begin
  						if(COLA_COUNT != 0) begin
  						stat = AVAILABLE;
						pif.info = COST_OF_COLA;
						end
  						else
  						stat = OUT_OF_STOCK;
  						end
  					//if(button == C)	// PEPSI
  					 C:	begin
  						if(PEPSI_COUNT != 0) begin
  						stat = AVAILABLE;
						pif.info = COST_OF_PEPSI;
						end
  						else
  						stat = OUT_OF_STOCK;
  						end
  					//if(button == D)	// FANTA
  					 D:	begin
  						if(FANTA_COUNT != 0) begin
  						stat = AVAILABLE;
						pif.info = COST_OF_FANTA;
						end
  						else
  						stat = OUT_OF_STOCK;
  						end
  					//if(button == E)	// COFFEE
  					 E:	begin
  						if(COFFEE_COUNT != 0) begin
  						stat = AVAILABLE;
						pif.info = COST_OF_COFFEE;
						end
  						else
  						stat = OUT_OF_STOCK;
  						end
  					//if(button == F)	// CHIPS
  					 F:	begin
  						if(CHIPS_COUNT != 0) begin
  						stat = AVAILABLE;
						pif.info = COST_OF_CHIPS;
						end
  						else
  						stat = OUT_OF_STOCK;
  						end
  					//if(button == G)	// BARS
  					 G:	begin
  						if(BARS_COUNT != 0) begin
  						stat = AVAILABLE;
						pif.info = COST_OF_BARS;
						end
  						else
  						stat = OUT_OF_STOCK;
  						end
  					endcase
  
  					pif.insert_coins = 1'b1;
  				    	//pif.start_timer = 1'b1;
  					end 
  
  	state[INSERT_COINS_INDEX]     : begin 
					pif.balance = '0;
  				    	pif.start_timer = 1'b1;
  				    	//if(pif.start_timer == 1'b1) begin
					if(coin == NICKEL)	        pif.amount += pif.prev_amount + 16'h5;	// $0.05
					else if (coin == DIME)		pif.amount += pif.prev_amount + 16'hA;	// $0.10		
					else if (coin == QUARTER)	pif.amount += pif.prev_amount + 16'h19;	// $0.25
					else				pif.amount  = pif.amount;			
					end
					//end
					  
  
  	// compare cost with amount inserted by user and compute pif.balance 
  	state[CHECK_BALANCE]          : begin 
  				    	pif.start_timer = 1'b0;
  					if(button == A)	// WATER
  					  if(pif.amount > COST_OF_WATER)	pif.balance = pif.amount - COST_OF_WATER;
  					  else if(pif.amount < COST_OF_WATER)  begin
						pif.insufficient_amount = 1'b1;
					  end
  					  else 					        pif.balance = 0;
  					else if(button == B)	// COLA
  					  if(pif.amount > COST_OF_COLA)	pif.balance = pif.amount - COST_OF_COLA;
  					  else if(pif.amount < COST_OF_COLA)   begin 
						pif.insufficient_amount = 1'b1;
					  end
  					  else 					        pif.balance = 0;
  					else if(button == C)	// PEPSI
  					  if(pif.amount > COST_OF_PEPSI)	pif.balance = pif.amount - COST_OF_PEPSI;
  					  else if (pif.amount < COST_OF_PEPSI) begin	
						pif.insufficient_amount = 1'b1;
					  end
  					  else 					        pif.balance = 0;
  					else if(button == D)	// FANTA
  					  if(pif.amount > COST_OF_FANTA)	pif.balance = pif.amount - COST_OF_FANTA;
  					  else if (pif.amount < COST_OF_FANTA) begin	
						pif.insufficient_amount = 1'b1;
					  end
  					  else 					        pif.balance = 0;
  					else if(button == E)	// COFFEE
  					  if(pif.amount > COST_OF_COFFEE)	pif.balance = pif.amount - COST_OF_COFFEE;
  					  else if (pif.amount < COST_OF_COFFEE) begin
						pif.insufficient_amount = 1'b1;
					  end
  					  else 					        pif.balance = 0;
  					else if(button == F)	// CHIPS
  					  if(pif.amount > COST_OF_CHIPS)	pif.balance = pif.amount - COST_OF_CHIPS;
  					  else if (pif.amount < COST_OF_CHIPS) begin	
						pif.insufficient_amount = 1'b1;
					  end
  					  else 					        pif.balance = 0;
  					else if(button == G)	// BARS
  					  if(pif.amount > COST_OF_BARS)	pif.balance = pif.amount - COST_OF_BARS;
  					  else if (pif.amount < COST_OF_BARS) begin	
						pif.insufficient_amount = 1'b1;
					  end
  					  else 					        pif.balance = 0;
  					$display("********BALANCE = %h", pif.balance);
					end
					
  
           				
  	state[DISPENSE_ITEM_INDEX]  : begin 
  				    	pif.amount = '0;
  	 				unique case(button)
  						A : 	begin pif.product  = WATER;   WATER_COUNT  = WATER_COUNT - 1'b1; end	
  					
  						B :	begin pif.product  = COLA;  COLA_COUNT   = COLA_COUNT - 1'b1; end	
  					
  						C :	begin pif.product  = PEPSI;   PEPSI_COUNT  = PEPSI_COUNT - 1'b1; end	
  					
  						D :	begin pif.product  = FANTA;   FANTA_COUNT  = FANTA_COUNT - 1'b1; end	
  					
  						E :	begin pif.product  = COFFEE;  COFFEE_COUNT = COFFEE_COUNT - 1'b1; end		
  					
  						F :	begin pif.product  = CHIPS;  CHIPS_COUNT  = CHIPS_COUNT - 1'b1; end	
  			
  						G :	begin pif.product  = BARS;    BARS_COUNT   = BARS_COUNT - 1'b1; end	
  			
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
					// if no pif.valid or button are pressed, stay in this state
  			                else if (!pif.valid && !button || pif.srst) 	next_state = IDLE;
					// if no pif.valid and user presses a button, go to CHECK_ITEM_COUNT state
  			                else if (!pif.valid && button)		next_state = CHECK_ITEM_COUNT;
  			                end
  
  	state[CHECK_ITEM_COUNT_INDEX] : begin 
					// if insert pif.coins is asserted and stat indicates requested pif.item is available, go to INSERT_COINS state. 
  					if(pif.insert_coins)		next_state = INSERT_COINS;
					// if insert pif.coins is deasserted and stat indicates requested pif.item is available, stay in this state. 
  					else if(!pif.insert_coins && stat == AVAILABLE)	next_state = CHECK_ITEM_COUNT;
  					// if stat indicates the requested pif.item is not available, go back to IDLE state
  					else if (stat != AVAILABLE || pif.srst)		next_state = IDLE;
  					end
  
  	state[INSERT_COINS_INDEX]     : begin 
  					if(pif.select)			 	       	 	next_state = CHECK_BALANCE;
  					// wait for user to insert pif.coins and then press pif.select till timeout
  					else if(!pif.select && !vif.timeout)			 	next_state = INSERT_COINS;
  					// if no pif.coins are inserted or user doesn't press pif.select and timeout occurs, go back to IDLE
  					else if(!pif.select && vif.timeout || stat == ERROR || pif.srst)    next_state = IDLE;
  					end
  
  	state[CHECK_BALANCE]          : begin 
  					if(stat == ERROR || pif.srst)	next_state = IDLE;
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
