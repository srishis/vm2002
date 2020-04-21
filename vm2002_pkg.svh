
// package for common entities in vm2002 design and testbench

`ifndef VM2002_PKG
`define VM2002_PKG
`endif

package vm2002_common_pkg;

  // enum for acceptable coins
  typedef enum logic [1:0] {
	NICKEL      = 2'h1,
	DIME        = 2'h2,
	QUARTER     = 2'h3
  }
  coins_t;
  
  // enum for items/product in the vending machine
  typedef enum logic [2:0] {
	WATER	= 3'h1,		
  	COLA	= 3'h2,	
  	PEPSI	= 3'h3,	
  	FANTA	= 3'h4,	
	COFFEE	= 3'h5,	
	CHIPS	= 3'h6,	
	BARS	= 3'h7	
  } item_t;

  // struct for item count register in the vending machine
  // setting all items default count to avg value 8
  typedef struct packed {
	logic [3:0] WATER_COUNT;	 
  	logic [3:0] COLA_COUNT;	 
  	logic [3:0] PEPSI_COUNT;	 
  	logic [3:0] FANTA_COUNT;	 
	logic [3:0] COFFEE_COUNT; 
	logic [3:0] CHIPS_COUNT;	 
	logic [3:0] BARS_COUNT;	 
  } item_count_struct_t;
  
  // struct for item costs register in the vending machine
  typedef struct packed {
	logic [7:0] COST_OF_WATER;	 
  	logic [7:0] COST_OF_COLA;	
  	logic [7:0] COST_OF_PEPSI;	
  	logic [7:0] COST_OF_FANTA;	
	logic [7:0] COST_OF_COFFEE;	
	logic [7:0] COST_OF_CHIPS;	
	logic [7:0] COST_OF_BARS;	
  } cost_struct_t;


  // enum for buttons on the vending machine
  typedef enum logic [2:0] {
	A = 3'h1,			// Button A selects water			
  	B = 3'h2,			// Button B selects cola 			
  	C = 3'h3,			// Button C selects pepsi                       
  	D = 3'h4,		        // Button D selects fanta                       
	E = 3'h5,			// Button E selects coffee                       
	F = 3'h6,			// Button F selects chips                       
	G = 3'h7			// Button G selects bars                       
  } buttons_t;

  // enum for product availability status
  typedef enum logic [1:0] {
	AVAILABLE      = 2'h1,
	OUT_OF_STOCK   = 2'h2,
	ERROR	       = 2'h3
  } status_t;

  // Indices for FSM states in Vending machine for bug free state logic 
  typedef enum {
	IDLE_INDEX             = 0,
	RESTOCK_INDEX          = 1,
	CHECK_ITEM_COUNT_INDEX = 2,
	INSERT_COINS_INDEX     = 3,
	CHECK_BALANCE_INDEX    = 4,
	DISPENSE_ITEM_INDEX    = 5 
  } state_index;

  // one hot FSM states for Vending machine
  typedef enum logic [5:0] {
	IDLE             = 6'b000001 << IDLE_INDEX,
	RESTOCK          = 6'b000001 << RESTOCK_INDEX,
	CHECK_ITEM_COUNT = 6'b000001 << CHECK_ITEM_COUNT_INDEX,
	INSERT_COINS     = 6'b000001 << INSERT_COINS_INDEX,
	CHECK_BALANCE    = 6'b000001 << CHECK_BALANCE_INDEX,
	DISPENSE_ITEM    = 6'b000001 << DISPENSE_ITEM_INDEX
  } fsm_state_t; 


endpackage
