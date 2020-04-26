
// Interface for VM2002 design

`include "vm2002_pkg.svh"
interface vm2002_if(input logic clk, hrst);

import vm2002_common_pkg::*;

logic srst;

// output interface
logic [2:0] product;
logic [15:0] balance;
logic [7:0] info;
logic [1:0] status;

// user interface inputs
logic [1:0] coins; 
logic [2:0] buttons; 
logic select; 

// supplier interface inputs
logic valid;
logic [2:0] item;
logic [3:0] count;
logic [7:0] cost;

// internal variables
logic [15:0] amount;
logic insert_coins;
logic [4:0] timer;				
logic start_timer;				
logic timeout;
logic [15:0] prev_balance;
logic [15:0] prev_amount;
logic insufficient_amount;

// Design modport
modport DUT(
			input clk, hrst, srst, coins, buttons, select, valid, item, count,  cost, 
			output product, balance, info, status
);

// TB modport
modport TB(clocking cb,
	   import report_results,
	   import get_cost,
	   import configure,
	   import print_cost,
	   import print_count,
	   import add_coins
	   );

clocking cb @(posedge clk);
	default input #1step output #1;
endclocking 

// Test bench methods

static int test_count = 0;

// Display results
function void report_results();
	$display("**********************TEST COUNT = %0d**************************", test_count);
	$display("VALID = %0h", valid);
	$display("SOFT RESET = %0h", srst);
	$display("ITEM = %0d", item);
	$display("ITEM COUNT = %0d", count);
	$display("ITEM COST = %0d", cost);
	$display("BUTTON PRESSED = %0h", buttons);
	$display("COINS = %0d", coins);
	$display("PREVIOUS AMOUNT = %0d", prev_amount);
	$display("AMOUNT = %0d", amount);
	$display("INSUFFICIENT AMOUNT = %0h", insufficient_amount);
	$display("SELECT = %0h", select);
	$display("PRODUCT = %0d", product);
	$display("INFO = %0d", info);
	$display("STATUS = %0h", status);
	$display("BALANCE = %0d", balance);
	$display("************************************************");
endfunction : report_results

function void print_count();
	$display("*****************PRINTING ITEM COUNT*******************************");
	$display("WATER COUNT = %0d", WATER_COUNT);
	$display("COLA COUNT = %0d", COLA_COUNT);
	$display("PEPSI COUNT = %0d", PEPSI_COUNT);
	$display("FANTA COUNT = %0d", FANTA_COUNT);
	$display("COFFEE COUNT = %0d", COFFEE_COUNT);
	$display("BARS COUNT = %0d", BARS_COUNT);
	$display("CHIPS COUNT = %0d", CHIPS_COUNT);
	$display("************************************************");
endfunction : print_count

function void print_cost();
	$display("*****************PRINTING ITEM COST*******************************");
	$display("WATER COST = %0d", COST_OF_WATER);
	$display("COLA COST = %0d", COST_OF_COLA);
	$display("PEPSI COST = %0d", COST_OF_PEPSI);
	$display("FANTA COST = %0d", COST_OF_FANTA);
	$display("COFFEE COST = %0d", COST_OF_COFFEE);
	$display("BARS COST = %0d", COST_OF_BARS);
	$display("CHIPS COST = %0d", COST_OF_CHIPS);
	$display("************************************************");
endfunction : print_cost

// configure design before generating stimulus
function void configure();
  // default item count
  WATER_COUNT = 0;
  COLA_COUNT = 0;
  PEPSI_COUNT = 0;
  FANTA_COUNT = 0;
  COFFEE_COUNT = 0;
  BARS_COUNT = 0;
  CHIPS_COUNT = 0;
  // default cost
  COST_OF_WATER  = 8'd50;	// $0.5 		
  COST_OF_COLA	  = 8'd100;	// $1    		
  COST_OF_PEPSI  = 8'd100;	// $1    		
  COST_OF_FANTA  = 8'd100;	// $1    		
  COST_OF_COFFEE = 8'd200;	// $2    		
  COST_OF_CHIPS  = 8'd150;	// $1.50      
  COST_OF_BARS	  = 8'd125;	// $1.25
endfunction : configure

// TODO: task to check_results

// insert coins task
task add_coins();
  static int loop = $urandom_range(1,25); // number of times the user can insert a coin 
//$display("*Inside add coins with loop = %d*", loop);
  repeat(loop) begin
  	coins = $urandom_range(1,3);
  	@(negedge clk);
  end
endtask : add_coins

function int get_cost();
	// logic to generate random cost to be a multiple of 5
	static int temp = $urandom_range(0,255);
	return (temp - (temp % 5));
endfunction : get_cost

endinterface

