
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
vm2002 V1(.*);

// COVERAGE instantiation
vm2002_cov cov(vif);

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
  fork
  cov.cov_run();
  while(cov.vm2002_cg.get_coverage() < 100) begin
  random_stimulus();
  end
  join_any
  // check_results();
endtask : run

// Display results
task report_results();
	$display("ITEM REGISTER = %h", item_reg);
	$display("COST REGISTER = %h", cost_reg);
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
  //covergroup new function called - covergroup created
  cov.cov_new();
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
