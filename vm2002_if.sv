// Interface for VM2002 design

`include "vm2002_pkg.svh"
interface vm2002_if(input logic clk, hrst);

import vm2002_common_pkg::*;

logic srst;

// output interface
logic [2:0] product;
logic [15:0] balance;
logic [7:0] info;
status_t status;

// user interface inputs
coins_t coins; 
buttons_t buttons; 
logic select; 

// supplier interface inputs
logic valid;
item_t item;
logic [3:0] count;
logic [7:0] cost;

// internal variables
logic [15:0] amount;
logic insert_coins;
logic [8:0] timer;				// 9 bit down counter which counts 512 clocks
logic start_timer;				// control signal for internal timer	
logic [15:0] prev_balance;
logic [15:0] prev_amount;
logic insufficient_amount;

endinterface

