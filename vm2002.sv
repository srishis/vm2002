// RTL Design for vm2002 for Assignment 1

module vm2002(product, status, balance, info, clk, rst, coins, buttons, select, item, count, cost, valid);


// user interface inputs
input [1:0] coins; 
input [2:0] buttons; 
input select; 

// supplier interface inputs
input [2:0] item;
input [3:0] count;
input [7:0] cost;
input valid;

// output interface
output logic [2:0] product;
output logic [1:0] status;
output logic [15:0] balance;
output logic [7:0] info;

// import package
import vm2002_pkg::*;

// initial condition
always_ff@(posedge clk) begin
if(rst)	begin
	product	<= '0;
	status 	<= '0;
	balance <= '0;
	info	<= '0;
end
else begin
	product	<= product;
	status 	<= status;
	balance <= balance;
	info	<= info;
end
end

// supplier restocking logic
endmodule
