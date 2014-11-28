// EE 361
// Homework 10
// MIPSL 
// 
// * PC and PC Control:  Program Counter and
//         the PC control logic

//--------------------------------------------------------------
// PC and PC Control
module PCLogic(
		pc_next,	// next value of the pc
		pc,		// current pc value
		signext1,	// from sign extend circuit
		branch,	// beq instruction
		alu_zero,	// zero from ALU, used in cond branch
		reset		// reset input
		);

output [15:0] pc_next;
input [15:0] pc;
input [15:0] signext1;  // From sign extend circuit
input branch;
input alu_zero;
input reset;


reg [15:0] pc_next; 
wire [15:0] shiftedsignext;
assign shiftedsignext = (signext1 << 1);

wire [15:0] branchresult;
assign branchresult = (pc+2 + shiftedsignext);


// pc_next output is updated
// Note that the multiplexers that are used to choose the
// next PC value are realized in verilog by the 
// if-else statements
// What's missing is conditional branch BEQ
// Note that the target branch address has to be computed
// which includes a sign extension of the branch target 
// offset

always @(pc or reset)
	begin
	if (reset==1) pc_next = 0;
	else if(branch & alu_zero)
        #10 pc_next = branchresult;
    else 
        #10 pc_next = pc+2; // default
	end

		
endmodule
