// EE 361 Hw 10 Testbench for sequential circuit Parts
// * 8 x 16 register file

module testbench
;
wire [15:0] rf_rdata1; // read data output 1
wire [15:0] rf_rdata2; // read data output 2

reg [15:0] rf_wdata; // write data input

reg [2:0] rf_waddr; // write address
reg [2:0] rf_raddr1; // read address 1
reg [2:0] rf_raddr2; // read address 2
reg rf_write; // write enable
reg clock;

// Instantiation

RegFile  RFile_Circuit(
	rf_rdata1,	// read data output 1
	rf_rdata2,	// read data output 2
	clock,	
	rf_wdata,	// write data input
	rf_waddr,	// write address
	rf_raddr1,	// read address 1
	rf_raddr2,	// read address 2
	rf_write	// write enable
	);			

// Clock signal

initial clock = 0;
always #1 clock = ~clock;
// Generating signals to the circuits

initial 
	begin
	rf_wdata = 9;
	rf_raddr1 = 0; // Output $0
	rf_raddr2 = 1; // Output $1, which initially is xxxxx
	rf_waddr = 1;  // Set up $1=9
	rf_write = 0;
	#4
	rf_write = 1; // $1=9
	#2
	rf_write = 0; // Disable write
	#4
	rf_wdata = 7; 
	rf_raddr1 = 6; // Output $6
	rf_raddr2 = 1; // Output $1
	rf_waddr = 6;  // Set up $6=7
	rf_write = 0;
	#4
	rf_write = 1;  // $6=7
	#2
	rf_write = 0;
	#4
	rf_raddr2=0; // Output $0
	#4
	rf_waddr=0;  // Set up $0=7
	#4
	rf_write=1; // Won't write because $0 is always 0
	#2
	rf_write=0;
	#4
	$finish;
		
	end


initial
	$monitor("Read1[%b]=%b Read2[%b]=%b Write[%b]=%b write=%b clock=%b",
		rf_raddr1,
		rf_rdata1,
		rf_raddr2,
		rf_rdata2,
		rf_waddr,
		rf_wdata,
		rf_write,
		clock
		);
endmodule