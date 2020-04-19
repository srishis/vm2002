module vm2002_cov(vm_2002_if vif);

function cov_new();
  vm2002_cg = new();
endfunction

task cov_run();
  forever vm2002_cg.sample();
endtask

covergroup vm2002_cg;
// user mode coverpoints
COINS_CP: coverpoint vif.coins{
				option.at_least = 20;
				bins NICKEL = 	{NICKEL};	
				bins DIME 	= 	{DIME};
				bins QUARTER = 	{QUARTER};
				bins C_ZERO    = {2'h0};	
								};
								
BUTTONS_CP : coverpoint vif.buttons{
				option.at_least = 10;
				bins A  = 	{A};	
				bins B 	= 	{B};
				bins C  = 	{C};						
				bins D  = 	{D};	
				bins E 	= 	{E};
				bins F  = 	{F};						
				bins G  = 	{G};
				bins B_ZERO    = {2'h0};	
								};
								
SELECT_CP:coverpoint vif.select{
				option.at_least = 20;
				bins select = {0,1};
								};
// supplier	mode coverpoints							
//button then select transition bin						
BUTTONS_SELECT_CP:coverpoint button_select{
				option.at_least = 5;
				bins button_select[] = {vif.buttons = [A:G] => vif.select = 1};
							};

VALID_CP:coverpoint vif.valid{
				option.at_least = 20;
				bins valid = {0,1};
								};
                
//item, count cost bins								
ITEM_CP:coverpoint vif.item{
				option.at_least = 10;
				bins items = {[WATER:BARS]};
				bins NO_ITEM = {3'h0};	
							};
							
COUNT_CP:coverpoint vif.count{
				option.at_least = 10;
				bins low = {[0:7]};
				bins high= {[8:15]};
							};
							
COST_CP:coverpoint vif.cost{
				option.at_least = 10;
				bins low = {[0:127]};
				bins high= {[127:255]};
							};
							
//valid then item select then cost or count transition bin		
VALID_ITEM_CP:coverpoint valid_item_cost_count{
				option.at_least = 5;
				bins valid_item[] = {vif.valid = 1 => vif.item = [WATER:BARS] => (vif.cost = [0:255] || IF.count = [0:15] };
							};							
		

//item count cross coverage
ITEM_COUNT_CROSS_CP: cross ITEM_CP,COUNT_CP,{
								bins item_low_cross		=	binsof(ITEM_CP.items) intersect binsof(COUNT_CP.low);
								bins item_high_cross	=	binsof(ITEM_CP.items) intersect binsof(COUNT_CP.high);		
								};			
endgroup

endmodule
