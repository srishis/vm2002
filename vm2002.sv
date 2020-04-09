// RTL Design for vm2002 for Assignment 1
module vm2002(product, status, balance, info, clk, rst, coins, buttons, select, item, count, cost, valid);

input clk, rst;

// user interface inputs
input coin_t coins; 
input items_t buttons; 
input select; 

// supplier interface inputs
input item_t item;
input [3:0] count;
input cost_t cost;
input valid;

// output interface
output logic [2:0] product;
output status_t status;
output logic [15:0] balance;
output logic [7:0] info;

//internal variables to maintain item count
logic [6:0] total_c = '0; //suppose that we can store upto 16 items (16 slots per product) each and we have total of 8 items so 16*8 = 128 max count
logic [3:0] water_c = '0; 
logic [3:0] cola_c  = '0; 
logic [3:0] pepsi_c = '0;
logic [3:0] fanta_c = '0;
logic [3:0] coffee_c = '0;
logic [3:0] chips_c = '0;
logic [3:0] bars_c  = '0;
logic [3:0] redbull_c= '0;

//for maintaining total number of item count
assign total_c = water_c + cola_c + pepsi_c + fanta_c + coffee_c + chips_c + bars_c + redbull_c;

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

//supplier restocking logic

//TODO:what if supplier has to change the cost of any specific product??

//check added if the number of slots available are equal to number of products supplier putting in vm
always_ff@(posedge clk) begin
if(valid)begin
	if(total_c == 8'h80) $display("Vending Machine Full");
	else
	unique case(item)
		WATER: 	begin	if(water_c + count > 5'h10)$display("Error: Overflow Insufficient slots you can add %0d product ",(16 - water_c));
						else water_c <= water_c + count;
				end
		COLA:	begin	if(cola_c + count > 5'h10)$display("Error: Overflow Insufficient slots you can add %0d product ",(16 - cola_c));
						else cola_c <= cola_c + count;
				end
		PEPSI:	begin	if(pepsi_c + count > 5'h10)$display("Error: Overflow Insufficient slots you can add %0d product ",(16 - pepsi_c));
						else pepsi_c <= pepsi_c + count;
				end
		FANTA:	begin	if(fanta_c + count > 5'h10)$display("Error: Overflow Insufficient slots you can add %0d product ",(16 - fanta_c));
						else fanta_c <= fanta_c + count;
				end
		COFFEE:	begin	if(coffee_c + count > 5'h10)$display("Error: Overflow Insufficient slots you can add %0d product ",(16 - coffee_c));
						else coffee_c <= coffee_c + count;
				end
		CHIPS:	begin	if(chips_c + count > 5'h10)$display("Error: Overflow Insufficient slots you can add %0d product ",(16 - chips_c));
						else chips_c <= chips_c + count;
				end
		BARS:	begin	if(bars_c + count > 5'h10)$display("Error: Overflow Insufficient slots you can add %0d product ",(16 - bars_c));
						else bars_c <= bars_c + count;
				end
		REDBULL:begin	if(redbull_c + count > 5'h10)$display("Error: Overflow Insufficient slots you can add %0d product ",(16 - redbull_c));
						else redbull_c <= redbull_c + count;
				end	
	endcase
else
// TODO: user access logic
end

endmodule
