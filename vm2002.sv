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

//item count
item_count_struct_t item_count;
logic [6:0] total_c = '0; //suppose that we can store upto 16 items (16 slots per product) each and we have total of 8 items so 16*8 = 128 max count

//item cost
cost_struct_t item_cost;

//for maintaining total number of item count
assign total_c = item_count.WATER_COUNT + item_count.COLA_COUNT + item_count.PEPSI_COUNT + item_count.FANTA_COUNT + item_count.COFFEE_COUNT + item_count.CHIPS_COUNT + item_count.BARS_COUNT + item_count.COOKIE_COUNT;

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



//supplier cost resetting logic
always@(count) begin
if(valid)begin
		unique case(item)
			WATER: 	item_cost.COST_OF_WATER = cost;	
					
			COLA:	item_cost.COST_OF_COLA = cost;		
					
			PEPSI:	item_cost.COST_OF_PEPSI = cost;	
					
			FANTA:	item_cost.COST_OF_FANTA = cost;	
					
			COFFEE:	item_cost.COST_OF_COFFEE = cost;		
				
			CHIPS:	item_cost.COST_OF_CHIPS = cost;		
			
			BARS:	item_cost.COST_OF_BARS = cost;	
			
			COOKIE:	item_cost.COST_OF_COOKIE = cost;		
		endcase
	end
else
	begin
		item_cost.COST_OF_WATER = item_cost.COST_OF_WATER;						
		item_cost.COST_OF_COLA = item_cost.COST_OF_COLA ;							
		item_cost.COST_OF_PEPSI = item_cost.COST_OF_PEPSI;						
		item_cost.COST_OF_FANTA = item_cost.COST_OF_FANTA;
		item_cost.COST_OF_COFFEE = item_cost.COST_OF_COFFEE;						
		item_cost.COST_OF_CHIPS = item_cost.COST_OF_CHIPS;					
		item_cost.COST_OF_BARS = item_cost.COST_OF_BARS;				
		item_cost.COST_OF_COOKIE = item_cost.COST_OF_COOKIE;
	end
end

//supplier restocking logic
always_ff@(posedge clk) begin
if(valid)begin
	if(total_c == 8'h80) $display("Vending Machine Full");//check added if the number of slots available are equal to number of products supplier putting in vm
	else
	unique case(item)
		WATER: 	begin	if(item_count.WATER_COUNT + count > 5'h10)$display("Error: Overflow Insufficient slots you can add %0d product ",(16 - item_count.WATER_COUNT));
						else item_count.WATER_COUNT <= item_count.WATER_COUNT + count;
				end
		COLA:	begin	if(item_count.COLA_COUNT + count > 5'h10)$display("Error: Overflow Insufficient slots you can add %0d product ",(16 - item_count.COLA_COUNT));
						else item_count.COLA_COUNT <= item_count.COLA_COUNT + count;
				end
		PEPSI:	begin	if(item_count.PEPSI_COUNT + count > 5'h10)$display("Error: Overflow Insufficient slots you can add %0d product ",(16 - item_count.PEPSI_COUNT));
						else item_count.PEPSI_COUNT <= item_count.PEPSI_COUNT + count;
				end
		FANTA:	begin	if(item_count.FANTA_COUNT + count > 5'h10)$display("Error: Overflow Insufficient slots you can add %0d product ",(16 - item_count.FANTA_COUNT));
						else item_count.FANTA_COUNT <= item_count.FANTA_COUNT + count;
				end
		COFFEE:	begin	if(item_count.COFFEE_COUNT + count > 5'h10)$display("Error: Overflow Insufficient slots you can add %0d product ",(16 - item_count.COFFEE_COUNT));
						else item_count.COFFEE_COUNT <= item_count.COFFEE_COUNT + count;
				end
		CHIPS:	begin	if(item_count.CHIPS_COUNT + count > 5'h10)$display("Error: Overflow Insufficient slots you can add %0d product ",(16 - item_count.CHIPS_COUNT));
						else item_count.CHIPS_COUNT <= item_count.CHIPS_COUNT + count;
				end
		BARS:	begin	if(item_count.BARS_COUNT + count > 5'h10)$display("Error: Overflow Insufficient slots you can add %0d product ",(16 - item_count.BARS_COUNT));
						else item_count.BARS_COUNT <= item_count.BARS_COUNT + count;
				end
		COOKIE:begin	if(item_count.COOKIE_COUNT + count > 5'h10)$display("Error: Overflow Insufficient slots you can add %0d product ",(16 - item_count.COOKIE_COUNT));
						else item_count.COOKIE_COUNT <= item_count.COOKIE_COUNT + count;
				end	
	endcase
else
// TODO: user access logic
end

endmodule
