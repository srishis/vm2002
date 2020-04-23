
`include"vm2002_pkg.svh"
module vm2002Top;

// import package
import vm2002_common_pkg::*;

parameter CLK_PERIOD = 10;
parameter DELAY = 100;
parameter CYCLES = 2;
parameter LOOP = 20;

logic clk, hrst;

// interface instantiation
vm2002_if vif(clk, hrst);

// DUT instantiation
vm2002 V1(vif);

// TODO: COVERAGE instantiation
//vm2002_cov cov(vif);

// clock generation
initial begin
 clk = 0;
 //repeat(100000*CYCLES) #CLK_PERIOD clk = ~clk;
 forever #CLK_PERIOD clk = ~clk;
 //$stop;
end

// apply and Lift hard reset 
task apply_hard_reset();
 hrst = 1;
 repeat(5*CYCLES) @(negedge clk);
 hrst = 0;
endtask : apply_hard_reset

// stimulus 
task run();
apply_hard_reset();
$display("*****Reset Lifted*****");
vif.configure();
$display("****Configuration complete******");
$display("****Initial condition******");
vif.report_results();
vif.print_count();
vif.print_cost();
random_stimulus();
// TODO: check_results();
endtask : run

task supplier_mode_test();
	//@negedge(clk)
	vif.item  = $urandom_range(1,7);
	vif.count = $urandom_range(0,15);
	vif.cost = vif.get_cost();
	repeat(2*CYCLES)@(negedge clk);
	//vif.valid = 0;
	$display("**********SUPPLIER MODE RESULTS***********");
	vif.test_count++;
	vif.report_results();
	vif.print_count();
	vif.print_cost();
endtask : supplier_mode_test

task user_mode_test();
	vif.buttons  = $urandom_range(1,7);
	//$display("WAIT: for status");
	if(vif.status === ERROR) begin
	$display("USER MODE: ERROR condition occured!!!");	
	end
	else wait(vif.status === AVAILABLE || vif.status === OUT_OF_STOCK);
	vif.srst = $urandom;
	if(vif.srst == 0) begin
		//$display("WAIT: for insert_coins");
		wait(vif.insert_coins === 1);
		//$display("WAIT: for start_timer");
		wait(vif.start_timer === 1);
		// insert coins
		vif.add_coins;
		//$display("USER: add coins done!!");
		vif.srst = $urandom;
		if(vif.srst == 0) vif.select = $urandom;
		if(vif.select == 0) begin 
			//$display("WAIT: for timeout"); 
			while(vif.timeout !== 1) @(negedge clk);
			//wait(vif.timeout === 1); 
			$display("USER MODE: NO SELECT INPUT & TIMEOUT OCCURRED - END TRANSACTION!!!!"); 
			end
		else if(vif.select == 1 && vif.timeout === 0) begin
			//$display("WAIT: for start timer 0");
			wait(vif.start_timer === 0);
			if(vif.insufficient_amount === 1) begin
				$display("USER  MODE: Insufficient amount inserted by user!!!");
				vif.add_coins;
			end
		end
	$display("*******USER MODE RESULTS*******");
	repeat(2)@(negedge clk);
	vif.test_count++;
	vif.report_results();
	vif.print_count();
	vif.print_cost();
	repeat(CYCLES)@(negedge clk);
	vif.srst = 0;
	vif.select = 0;
	end // srst if	
endtask : user_mode_test

initial begin
	// call run task
	run();
end

// apply random stimulus
task random_stimulus();
repeat(2*CYCLES)@(negedge clk);
// enter first in supplier mode to restock
vif.valid = 1; 
// supplier mode
  repeat(LOOP)begin
  	supplier_mode_test();	
  end // end for repeat loop

// enter in user mode now as the restock is complete
vif.valid = 0;

// user mode test
repeat(2*LOOP) begin
user_mode_test();	
end // end for repeat 

vif.valid = $urandom;
if(vif.valid == 1) begin
  repeat(LOOP)begin
  	supplier_mode_test();	
  end // end for repeat loop
end // end for valid == 1 if block
else begin
  repeat(2*LOOP) begin
  user_mode_test();	
  end // end for repeat 
end // end for if block 

$display("Final test count = %0d", vif.test_count);
$stop;
endtask : random_stimulus

endmodule
