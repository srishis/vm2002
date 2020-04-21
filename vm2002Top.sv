
`include"vm2002_pkg.svh"
module vm2002_tb;

// import package
import vm2002_common_pkg::*;

parameter CLK_PERIOD = 10;
parameter DELAY = 100;
parameter CYCLES = 1;

logic clk, hrst;

// interface instantiation
vm2002_if vif(clk, hrst);

// DUT instantiation
vm2002 V1(vif);

// COVERAGE instantiation

covergroup vm2002_cg;
// user mode coverpoints
COINS_CP: coverpoint vif.coins{
				option.at_least = 20;
				bins nickel = 	{NICKEL};	
				bins dime 	= 	{DIME};
				bins quarter = 	{QUARTER};
				bins C_ZERO    = {2'h0};	
								}
								
BUTTONS_CP : coverpoint vif.buttons{
				option.at_least = 10;
				bins a  = 	{A};	
				bins b 	= 	{B};
				bins c  = 	{C};						
				bins d  = 	{D};
				bins e 	= 	{E};
				bins f  = 	{F};						
				bins g  = 	{G};
				bins B_ZERO    = {2'h0};	
								}
								
SELECT_CP:coverpoint vif.select{
				option.at_least = 20;
				bins low  = {0};
				bins high = {1};	
								}
// supplier	mode coverpoints							
//button then select transition bin						
/*BUTTONS_SELECT_CP:cross BUTTONS_CP,SELECT_CP{
				option.at_least = 5;
				bins button_select = (binsof(BUTTONS_CP) => binsof(SELECT_CP.high) );
							}
*/
VALID_CP:coverpoint vif.valid{
				option.at_least = 20;
				bins valid = {0,1};
								}
                
//item, count cost bins								
ITEM_CP:coverpoint vif.item{
				option.at_least = 10;
				bins items = {[WATER:BARS]};
				bins NO_ITEM = {3'h0};	
							}
							
COUNT_CP:coverpoint vif.count{
				option.at_least = 10;
				bins low = {[0:7]};
				bins high= {[8:15]};
							}
							
COST_CP:coverpoint vif.cost{
				option.at_least = 10;
				bins low = {[0:127]};
				bins high= {[127:255]};
							}
			/*				
//valid then item select then cost or count transition bin		
VALID_ITEM_CP:coverpoint valid_item_cost_count{
				option.at_least = 5;
				bins valid_item[] = {vif.valid = 1 => vif.item = [WATER:BARS] => (vif.cost = [0:255] || IF.count = [0:15] };
							}							
		
//item count cross coverage
ITEM_COUNT_CROSS_CP: cross ITEM_CP,COUNT_CP{
								bins item_low_cross		=	{	binsof(ITEM_CP.items) intersect binsof(COUNT_CP.low)};
								bins item_high_cross		=	{	binsof(ITEM_CP.items) intersect binsof(COUNT_CP.high)};		
								}			
*/
endgroup

vm2002_cg cg;
initial begin
cg = new();
forever begin
cg.sample();
end
end

int loop = 0;

// clock generation
initial begin
 clk = 0;
 repeat(1000*DELAY) #CLK_PERIOD clk = ~clk;
 $stop;
end

// apply and Lift hard reset 
task apply_hard_reset();
 hrst = 1;
 repeat(10*CYCLES) @(posedge clk);
 hrst = 0;
endtask : apply_hard_reset

// apply random stimulus
task run();
  apply_hard_reset();
  configure();
  while(cg.get_coverage() < 100) begin
  random_stimulus();
  end
  // check_results();
endtask : run

// Display results
task report_results();
//	$display("ITEM REGISTER = %h", item_reg);
//	$display("COST REGISTER = %h", cost_reg);
	$display("VALID = %h", vif.valid);
	$display("SOFT RESET = %h", vif.srst);
	$display("ITEM = %h", vif.item);
	$display("ITEM COUNT = %h", vif.count);
	$display("ITEM COST = %h", vif.cost);
	$display("BUTTON PRESSED = %h", vif.buttons);
	$display("COINS = %h", vif.coins);
	$display("PREVIOUS AMOUNT = %h", vif.prev_amount);
	$display("AMOUNT = %h", vif.amount);
	$display("INSUFFICIENT AMOUNT = %h", vif.insufficient_amount);
	$display("SELECT = %h", vif.select);
	$display("PRODUCT = %h", vif.product);
	$display("INFO = %h", vif.info);
	$display("STATUS = %h", vif.status);
	$display("BALANCE = %h", vif.balance);
endtask : report_results

// TODO: task to check_results

// configure design before generating stimulus
task configure();
  item_count_struct_t item_reg;
  cost_struct_t cost_reg;
  coins_t coin;
  buttons_t button;
  item_t items;
  status_t stat;
  // default item count
  item_reg = '0;
  // default cost
  cost_reg.COST_OF_WATER  = 8'd50;	// $0.5 		
  cost_reg.COST_OF_COLA	  = 8'd100;	// $1    		
  cost_reg.COST_OF_PEPSI  = 8'd100;	// $1    		
  cost_reg.COST_OF_FANTA  = 8'd100;	// $1    		
  cost_reg.COST_OF_COFFEE = 8'd200;	// $2    		
  cost_reg.COST_OF_CHIPS  = 8'd150;	// $1.50      
  cost_reg.COST_OF_BARS	  = 8'd125;	// $1.25
endtask : configure

// insert coins task
task add_coins();
  loop = $urandom_range(1,51); // 51*5 = 255 which is the max value
  repeat(loop) begin
  	vif.coins = $urandom_range(1,3);
  	@(posedge clk);
  end
endtask : add_coins

initial begin
	// call run task
	run();
end

	// randomize valid signal to enter either in supplier mode or user mode
	// apply random stimulus
	task random_stimulus();
	repeat(5*CYCLES)@(posedge clk);
	vif.valid = $urandom;
	// supplier mode
	if(vif.valid == 1) begin
		repeat(10)begin
		//@posedge(clk)
		vif.item  = $urandom_range(1,7);
		vif.count = $urandom_range(0,15);
		// logic to generate random cost to be a multiple of 5
		//TODO:Use Internal Variable
		vif.cost  = $urandom_range(0,255);
		vif.cost -= vif.cost % 5;
		
		repeat(2*CYCLES)@(posedge clk);
		vif.valid = 0;
		report_results();
		$stop;
		end // end for repeat loop
	end // end for valid == 1 if block

	// user mode
	else 
		vif.buttons  = $urandom_range(1,7);
		wait(vif.status === AVAILABLE || vif.status === OUT_OF_STOCK);
		vif.srst = $urandom;
		if(vif.srst == 0) begin
			wait(vif.insert_coins === 1);
			wait(vif.start_timer === 1);
			// insert coins
			add_coins();
			vif.srst = $urandom;
			if(vif.srst == 0) vif.select = $urandom;
			if(vif.select == 0) wait(vif.timeout === 1);
			else if(vif.select == 1 && vif.timeout === 0) begin
				wait(vif.start_timer === 0);
				if(vif.insufficient_amount === 1) begin
					add_coins();
				end
			end
		end // srst if	
		repeat(2*CYCLES)@(posedge clk);
		report_results();
		$stop;
	endtask : random_stimulus

endmodule
