
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

// registers
//item_count_struct_t 
//cost_struct_t 

// supplier interface inputs
logic valid;
logic [2:0] item;
logic [3:0] count;
logic [7:0] cost;

// internal variables
logic [15:0] amount;
logic insert_coins;
logic [4:0] timer;				// 9 bit down counter which counts 512 clocks
logic start_timer;				// control signal for internal timer	
logic timeout;
logic [15:0] prev_balance;
logic [15:0] prev_amount;
logic insufficient_amount;

modport DUT(
			input clk, hrst, srst, coins, buttons, select, valid, item, count,  cost, 
			output product, balance, info, status
);

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

// Test bench methods:

static int test_count = 0;
static int temp = 0;

// Display results
function void report_results();
	$display("**********************TEST COUNT = %d**************************", test_count);
	//$display("ITEM REGISTER = %p", ;
	//$display("COST REGISTER = %p", ;
	$display("VALID = %h", valid);
	$display("SOFT RESET = %h", srst);
	$display("ITEM = %h", item);
	$display("ITEM COUNT = %h", count);
	$display("ITEM COST = %h", cost);
	$display("BUTTON PRESSED = %h", buttons);
	$display("COINS = %h", coins);
	$display("PREVIOUS AMOUNT = %h", prev_amount);
	$display("AMOUNT = %h", amount);
	$display("INSUFFICIENT AMOUNT = %h", insufficient_amount);
	$display("SELECT = %h", select);
	$display("PRODUCT = %h", product);
	$display("INFO = %h", info);
	$display("STATUS = %h", status);
	$display("BALANCE = %h", balance);
	$display("************************************************");
endfunction : report_results

function void print_count();
	$display("WATER COUNT = %h", WATER_COUNT);
	$display("COLA COUNT = %h", COLA_COUNT);
	$display("PEPSI COUNT = %h", PEPSI_COUNT);
	$display("FANTA COUNT = %h", FANTA_COUNT);
	$display("COFFEE COUNT = %h", COFFEE_COUNT);
	$display("BARS COUNT = %h", BARS_COUNT);
	$display("CHIPS COUNT = %h", CHIPS_COUNT);
endfunction : print_count
function void print_cost();
	$display("WATER COST = %h", COST_OF_WATER);
	$display("COLA COST = %h", COST_OF_COLA);
	$display("PEPSI COST = %h", COST_OF_PEPSI);
	$display("FANTA COST = %h", COST_OF_FANTA);
	$display("COFFEE COST = %h", COST_OF_COFFEE);
	$display("BARS COST = %h", COST_OF_BARS);
	$display("CHIPS COST = %h", COST_OF_CHIPS);
endfunction : print_cost

// configure design before generating stimulus

// configure design before generating stimulus
function void configure();
  //covergroup new function called - covergroup created
  //cov.cov_new();
 
  // default item count
  //= '0;
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
  static int loop = $urandom_range(1,51); // 51*5 = 255 which is the max value
$display("*Inside add coins with loop = %d*", loop);
  repeat(loop) begin
  	coins = $urandom_range(1,3);
  	@(negedge clk);
	$display("AMOUNT = %d", amount);
  end
endtask : add_coins

function int get_cost();
	// logic to generate random cost to be a multiple of 5
	static int temp = $urandom_range(0,255);
	//vif.cost -= temp % 5;
	return (temp % 5);
endfunction : get_cost

endinterface

