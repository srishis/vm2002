// package for common entities in vm2002 design and testbench

`ifndef VM2002_PKG
`define VM2002_PKG

package vm2002_pkg;

  // enum for acceptable coins
  typedef enum logic [1:0] {
	NICKEL      = 2'h1,
	DIME        = 2'h2,
	QUARTER     = 2'h3,
	NO_COINS    = 2'h0	
  }
  coins_t;
  
  // this variable holds the total amount inserted by the user through coins
  logic amount;
  logic insert_coins;

  // enum for items/product in the vending machine
  typedef enum logic [2:0] {
	WATER	= 3'h1,		
  	COLA	= 3'h2,	
  	PEPSI	= 3'h3,	
  	FANTA	= 3'h4,	
	COFFEE	= 3'h5,	
	CHIPS	= 3'h6,	
	BARS	= 3'h7,	
	//COOKIE	= 3'h7		
  } item_t;

  // struct for item count register in the vending machine
  // setting all items default count to avg value 8
  typedef struct packed {
	logic [2:0] WATER_COUNT	 = 3'h8;
  	logic [2:0] COLA_COUNT	 = 3'h8;
  	logic [2:0] PEPSI_COUNT	 = 3'h8;
  	logic [2:0] FANTA_COUNT	 = 3'h8;
	logic [2:0] COFFEE_COUNT = 3'h8;
	logic [2:0] CHIPS_COUNT	 = 3'h8;
	logic [2:0] BARS_COUNT	 = 3'h8;
	//logic [2:0] COOKIE_COUNT = 3'h8;
  } item_count_struct_t;
  
  // struct for item costs register in the vending machine
  typedef struct packed {
	logic [7:0] COST_OF_WATER	= 8'h6;		// $0.50 
  	logic [7:0] COST_OF_COLA	= 8'h12;	// $1
  	logic [7:0] COST_OF_PEPSI	= 8'h12;	// $1
  	logic [7:0] COST_OF_FANTA	= 8'h12;	// $1
	logic [7:0] COST_OF_COFFEE	= 8'h24;	// $2
	logic [7:0] COST_OF_CHIPS	= 8'h15;	// $1.25
	logic [7:0] COST_OF_BARS	= 8'h18;	// $1.50
	//logic [7:0] COST_OF_COOKIE	= 8'h21;	// $1.75
  } cost_struct_t;


  // enum for buttons on the vending machine
  typedef enum logic [2:0] {
	A = 3'h1,			// Button A selects water			
  	B = 3'h2,			// Button B selects cola 			
  	C = 3'h3,			// Button C selects pepsi                       
  	D = 3'h4,		        // Button D selects fanta                       
	E = 3'h5,			// Button E selects coffee                       
	F = 3'h6,			// Button F selects chips                       
	G = 3'h7,			// Button G selects bars                       
  } buttons_t;

  // enum for product availability status
  typedef enum logic [1:0] {
	AVAILABE      = 2'h1,
	OUT_OF_STOCK  = 2'h2,
	ERROR	      = 2'h3,
	NO_STATUS     = 2'h0	
  } status_t;

  // Indices for FSM states in Vending machine for bug free state logic 
  typedef enum {
	IDLE_INDEX             = 0,
	USER_INDEX             = 1,
	RESTOCK_INDEX          = 2,
	CHECK_ITEM_COUNT_INDEX = 3,
	CHECK_STATUS_INDEX     = 4,
	INSERT_COINS_INDEX     = 5,
	CHECK_BALANCE_INDEX    = 6,
	END_TRANSACTION_INDEX  = 7
  } state_index;

  // one hot FSM states for Vending machine
  typedef enum logic [7:0] {
	IDLE             = 8'b0000_0001 << IDLE_INDEX,
	USER             = 8'b0000_0001 << USER_INDEX,
	RESTOCK          = 8'b0000_0001 << RESTOCK_INDEX,
	CHECK_ITEM_COUNT = 8'b0000_0001 << CHECK_ITEM_COUNT_INDEX,
	CHECK_STATUS     = 8'b0000_0001 << CHECK_STATUS_INDEX,
	INSERT_COINS     = 8'b0000_0001 << INSERT_COINS_INDEX,
	CHECK_BALANCE    = 8'b0000_0001 << CHECK_BALANCE_INDEX,
	DISPENSE_ITEM    = 8'b0000_0001 << DISPENSE_ITEM_INDEX
  } state, next_state; 

endpackage
