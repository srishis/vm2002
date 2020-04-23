
`include"vm2002_pkg.svh"
//module vm2002Top;
module top;

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

// TODO: COVERAGE instantiation
//vm2002_cov cov(vif);

/*
coins_t coin;
buttons_t button;
item_t items;
status_t stat;
*/

// clock generation
initial begin
 clk = 0;
 repeat(10000) #CLK_PERIOD clk = ~clk;
 //$stop;
end

// apply and Lift hard reset 
task apply_hard_reset();
 hrst = 1;
 repeat(10*CYCLES) @(negedge clk);
 hrst = 0;
endtask : apply_hard_reset

// apply random stimulus
task run();
apply_hard_reset();
$display("reset lift complete");
vif.configure();
$display("configure complete");
vif.report_results();
	vif.print_count();
	vif.print_cost();
random_stimulus();
  // TODO: check_results();
endtask : run


initial begin
	// call run task
	run();
end

// randomize valid signal to enter either in supplier mode or user mode
// apply random stimulus
task random_stimulus();
repeat(5*CYCLES)@(negedge clk);
vif.valid = 1; 
// supplier mode
if(vif.valid == 1) begin
	repeat(5)begin
	//@negedge(clk)
	vif.item  = $urandom_range(1,7);
	vif.count = $urandom_range(0,15);
	vif.cost = vif.get_cost();
	repeat(2*CYCLES)@(negedge clk);
	vif.valid = 0;
	$display("SUPPLIER MODE : RESULTS DISPLAY");
	vif.test_count++;
	vif.report_results();
	vif.print_count();
	vif.print_cost();
	//$stop;
	end // end for repeat loop
end // end for valid == 1 if block

vif.valid = 0;

// user mode
if(vif.valid == 0) begin
	repeat(5) begin
	vif.buttons  = $urandom_range(1,7);
	$display("WAIT: for status");
	wait(vif.status === AVAILABLE || vif.status === OUT_OF_STOCK);
	vif.srst = $urandom;
	if(vif.srst == 0) begin
	$display("WAIT: for insert_coins");
		wait(vif.insert_coins === 1);
		$display("WAIT: for start_timer");
		//	@(negedge clk);
		wait(vif.start_timer === 1);
		// insert coins
		vif.add_coins;
	$display("USER: add coins done!!");
		//vif.srst = $urandom;
		if(vif.srst == 0) vif.select = 1; //$urandom;
	
		if(vif.select == 0) begin 
			$display("WAIT: for timeout"); 
			while(vif.timeout !== 1) @(negedge clk);
			//wait(vif.timeout === 1); 
			$display("USER: WAIT:  TIMEOUT OCCURRED!!!!"); 
			end
		else if(vif.select == 1 && vif.timeout === 0) begin
	$display("WAIT: for start timer 0");
			@(negedge clk);
			wait(vif.start_timer === 0);
			if(vif.insufficient_amount === 1) begin
				vif.add_coins;
			end
		end
	repeat(2*CYCLES)@(negedge clk);
	vif.test_count++;
	$display("USER MODE : RESULTS DISPLAY");
	vif.report_results();
	vif.print_count();
	vif.print_cost();
	end // srst if	
	end // end for repeat 
end // end for if block 
	$stop;
	endtask : random_stimulus

endmodule
