module vm2002_tb;

// import package
import vm2002_pkg::*;

logic clk, rst;

local parameter water_cost = 8'h6;
local parameter cola_cost = 8'h12;
local parameter pepsi_cost = 8'h12;
local parameter fanta_cost = 8'h12;
local parameter coffee_cost = 8'h24;
local parameter chips_cost = 8'h15;
local parameter bars_cost = 8'h18;

int test_fail,test_pass;
string test_case;
 
vm2002_if IF(clk,rst);
vm2002 VM(IF);

initial begin
clk = 0;
repeat(1000) #5 clk = ~clk;
$finish;
end

initial begin
unique case(test_case);
"vm_full_empty_test"	   : vm_full_empty_test;
"time_out_test"
endcase
end

covergroup vm2002_cg;
COINS_CP: coverpoint IF.coins{
								
								};
BUTTONS_CP:
ITEM_CP:
COUNT_CP:
COST_CP:
endgroup

task vm_full_empty_test;
//vending machine filled
supplier_vm_full;
//cost of products updated
supplier_cost_update
//check for info, product, status and balance
for(int i = 1; i <= 15 ;i++)begin
	for(int j = 1; j <= 7 ;j++)begin
	//check output info and status according to button pressed
		unique case(i)
		1:	begin IF.buttons = A ; if(IF.info == water_cost && IF.status == AVAILABLE)test_pass++; else test_fail++; end
		2:	begin IF.buttons = B ; if(IF.info == cola_cost && IF.status == AVAILABLE)test_pass++; else test_fail++; end
		3:	begin IF.buttons = C ; if(IF.info == pepsi_cost && IF.status == AVAILABLE)test_pass++; else test_fail++; end
		4:	begin IF.buttons = B ; if(IF.info == fanta_cost && IF.status == AVAILABLE)test_pass++; else test_fail++; end
		5:	begin IF.buttons = B ; if(IF.info == coffee_cost && IF.status == AVAILABLE)test_pass++; else test_fail++; end
		6:	begin IF.buttons = B ; if(IF.info == chips_cost && IF.status == AVAILABLE)test_pass++; else test_fail++; end
		7:	begin IF.buttons = B ; if(IF.info == bars_cost && IF.status == AVAILABLE)test_pass++; else test_fail++; end
		endcase
	
		unique case(j)
		1:	begin	repeat(10)  IF.coin = NICKEL; select =1; wait(IF.product);if(IF.product == WATER && IF.balance == 0) test_pass++; else test_fail++; end				//8'h6;  $0.50
		2:	begin	repeat(10)  IF.coin = DIME;   select =1; wait(IF.product);if(IF.product == COLA&& IF.balance == 0) test_pass++; else test_fail++;   end				//8'h12; $1
		3:	begin	repeat(10)  IF.coin = DIME;   select =1; wait(IF.product);if(IF.product == PEPSI && IF.balance == 0) test_pass++; else test_fail++; 	end				//8'h12; $1
		4:	begin	repeat(10)  IF.coin = DIME;   select =1; wait(IF.product);if(IF.product == FANTA && IF.balance == 0) test_pass++; else test_fail++; end				//8'h12; $1
		5:	begin	repeat(8)   IF.coin = QUARTER; select =1;wait(IF.product);if(IF.product == COFFEE && IF.balance == 0) test_pass++; else test_fail++;  end				//8'h24; $2
		6:	begin	repeat(5)   IF.coin = QUARTER ; select =1;wait(IF.product);if(IF.product == CHIPS && IF.balance == 0) test_pass++; else test_fail++;  end 			//8'h15; $1.25
		7:	begin	repeat(6)   IF.coin = QUARTER ; select =1; wait(IF.product);if(IF.product == BARS && IF.balance == 0) test_pass++; else test_fail++; end 			//8'h18; $1.50
		endcase 
	end
end	
//vm once empty check for item availability 
IF.buttons = A ; if(IF.info == water_cost && IF.status == OUT_OF_STOCK)test_pass++; else test_fail++; end

endtask


task supplier_vm_full;
IF.valid = 1;
for(int i = 1; i <= 7 ;i++)begin
unique case(i)
1:	IF.item = WATER ;
2:	IF.item = COLA;
3:	IF.item = PEPSI ;
4:	IF.item = FANTA ;
5:	IF.item = COFFEE ;
6:	IF.item = CHIPS ;
7:	IF.item = BARS ;
endcase
IF.count = 16;
end
//TODO:total count logic to add and comarison  to check if vending machine is full or not
IF.valid = 0;
endtask


task supplier_cost_update;
IF.valid = 1;
for(int i = 1; i <= 7 ;i++)begin
IF.item = i;
unique case(i)
1:	IF.cost = water_cost;
2:	IF.cost = cola_cost;
3:	IF.cost = pepsi_cost;
4:	IF.cost = fanta_cost;
5:	IF.cost = coffee_cost;
6:	IF.cost = chips_cost;
7:	IF.cost = bars_cost;
endcase
end
IF.valid = 0;
endtask



initial begin
$value$plusargs("TEST CASE = %s",test_case);
end 

endmodule