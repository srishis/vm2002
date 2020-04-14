module vm2002_tb;

// import package
import vm2002_pkg::*;

// output interface
logic [2:0] product;
<<<<<<< Updated upstream
status_t status;
=======
logic [1:0] status;
>>>>>>> Stashed changes
logic [15:0] balance;
logic [7:0] info;

logic clk, hrst, srst;

<<<<<<< Updated upstream
// user interface s
coin_t coins; 
items_t buttons; 
logic select; 

// supplier interface inputs
item_t item;
logic [3:0] count;
cost_t cost;
=======
// user interface inputs
logic [1:0] coins; 
logic [2:0] buttons; 
logic select; 

// supplier interface inputs
logic [2:0] item;
logic [3:0] count;
logic [7:0] cost;
>>>>>>> Stashed changes
logic valid;

vm2002 VM(.*);


//clock generation
initial begin
clk = 0;
repeat(1000) #5 clk = ~clk;
$finish;
end

//hard reset generation
initial begin
hrst = 1;
#10;
hrst = 0;
end 

endmodule