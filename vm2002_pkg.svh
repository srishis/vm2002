// package for common entities in vm2002 design and testbench

`ifndef VM2002_PKG
`define VM2002_PKG

package vm2002_pkg;

  // enum for acceptable coins
  typedef enum logic [1:0] {
	NICKEL      = 2'h0,
	DIME        = 2'h1,
	QUARTER     = 2'h2,
	ILLEGALCOIN = 2'h3	
  }
  coins_t;

  // enum for items in the vending machine
  typedef enum logic [2:0] {
	WATER	= 3'h0,		
  	COLA	= 3'h1,	
  	PEPSI	= 3'h2,	
  	FANTA	= 3'h3,	
	COFFEE	= 3'h4,	
	CHIPS	= 3'h5,	
	BARS	= 3'h6,	
	COOKIE	= 3'h7		
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
	logic [2:0] COOKIE_COUNT = 3'h8;
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
	logic [7:0] COST_OF_COOKIE	= 8'h21;	// $1.75
  } cost_struct_t;


  // enum for buttons on the vending machine
  typedef enum logic [2:0] {
	A = 3'h0,			// Button A selects water			
  	B = 3'h1,			// Button B selects cola 			
  	C = 3'h2,			// Button C selects pepsi                       
  	D = 3'h3,			// Button D selects fanta                       
	E = 3'h4,			// Button E selects coffee                       
	F = 3'h5,			// Button F selects chips                       
	G = 3'h6,			// Button G selects bars                       
	H = 3'h7			// Button H selects cookie                       
  } buttons_t;

  // enum for product availability status
  typedef enum logic [1:0] {
	AVAILABE      = 2'h0,
	OUT_OF_STOCK  = 2'h1,
	ERROR	      = 2'h2,
	ILLEGALSTATUS = 2'h3	
  } status_t;

endpackage

