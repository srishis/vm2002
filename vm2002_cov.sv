`include"vm2002_pkg.svh"
module vm2002_cov(vm2002_if vif);

// import package
import vm2002_common_pkg::*;

covergroup vm2002_cg;
// user mode coverpoints
COINS_CP: coverpoint vif.coins{
				option.at_least = 20;
				bins nickel = 	{NICKEL};	
				bins dime 	= 	{DIME};
				bins quarter = 	{QUARTER};
				//bins C_ZERO    = {2'h0};	
				bins  others = default;
								}
								
BUTTONS_CP : coverpoint vif.buttons{
				option.at_least = 10;
				bins a  = 	{A};	
				bins b 	= 	{B};
				bins c  = 	{C};						
				bins d  = 	{D};
				bins e 	= 	{E};
				bins f  = 	{F};						
				bins g  = 	{G};
				//bins B_ZERO    = {2'h0};	
				bins  others = default;
								}
								
SELECT_CP:coverpoint vif.select{
				option.at_least = 20;
				bins low  = {0};
				bins high = {1};	
								}
// supplier	mode coverpoints							
//button then select transition bin						
/*BUTTONS_SELECT_CP:cross BUTTONS_CP,SELECT_CP{
				option.at_least = 5;
				bins button_select = (binsof(BUTTONS_CP) => binsof(SELECT_CP.high) );
							}
*/
VALID_CP:coverpoint vif.valid{
				option.at_least = 20;
				bins valid = {0,1};
								}
                
//item, count cost bins								
ITEM_CP:coverpoint vif.item{
				option.at_least = 10;
				bins items = {[WATER:BARS]};
				bins NO_ITEM = {3'h0};	
							}
							
COUNT_CP:coverpoint vif.count{
				option.at_least = 10;
				bins low = {[0:7]};
				bins high= {[8:15]};
							}
							
COST_CP:coverpoint vif.cost{
				option.at_least = 10;
				bins low = {[0:127]};
				bins high= {[127:255]};
							}
			/*				
//valid then item select then cost or count transition bin		
VALID_ITEM_CP:coverpoint valid_item_cost_count{
				option.at_least = 5;
				bins valid_item[] = {vif.valid = 1 => vif.item = [WATER:BARS] => (vif.cost = [0:255] || IF.count = [0:15] };
							}							
		
//item count cross coverage
ITEM_COUNT_CROSS_CP: cross ITEM_CP,COUNT_CP{
								bins item_low_cross		=	{	binsof(ITEM_CP.items) intersect binsof(COUNT_CP.low)};
								bins item_high_cross		=	{	binsof(ITEM_CP.items) intersect binsof(COUNT_CP.high)};		
								}			
*/
endgroup

// COVERAGE instantiation and sample
initial begin
	vm2002_cg cg;
	cg = new();
  	while(cg.get_coverage() < 100) cg.sample();
end

endmodule
