interface vm_2002_if(logic clk, hrst, srst);

// import package
import vm2002_pkg::*;

// user interface s
coin_t coins; 
buttons_t buttons; 
logic select; 

// supplier interface inputs
item_t item;
logic [2:0] count;
logic [7:0] cost;
logic valid;

// output interface
item_t product;
status_t status;
logic [15:0] balance;
cost_struct_t info;

modport DUT(
input 
output
);

endinterface