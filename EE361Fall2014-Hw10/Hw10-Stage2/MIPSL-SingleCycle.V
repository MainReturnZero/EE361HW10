// EE 361
// Homework 10
// MIPSL 
// 
// Obviously, it's incomplete.  Just the ports are defined.
//

module MIPSL(
//output
    iaddr,		// Program memory address.  This is the program counter
	daddr,		// Data memory address
	dwrite,		// Data memory write enable
	dread,		// Data memory read enable
	dwdata,		// Data memory write output
	alu_out,	// Output of alu for debugging purposes
//inputs
    clock,
	idata,		// Program memory output, which is the current instruction
	ddata,		// Data memory output
	reset
	);

output [15:0] iaddr;
output [15:0] daddr;	
output dwrite;
output dread;
output [15:0] dwdata;
output [15:0] alu_out;
input clock;
input [15:0] idata; // Instructions are 16 bits
input [15:0] ddata;	
input reset;

wire [15:0] pc_next;
wire [3:0] opcode;
//Register variable***************************************************************************
wire [15:0] Opcode;
wire [15:0] instrf1;
wire [15:0] instrf2;
wire [15:0] instrf3;
wire [15:0] writedata;
wire [15:0] idata;
wire [6:0] immeddata;

//Control signal **************************************************
wire regdst;
wire branch;
wire memread;
wire memtoreg;
wire [2:0] alu_select;
wire memwrite;
wire alusrc;
wire regwrite;

//Reset PC*****************************************

//always @(posedge clock)
//    begin
//    if(reset ==1)
//        begin
//        pc_next <= 0;
//        end
//    end

//Control behavior*******************************

assign opcode=idata[15:13];

Control control1(
    regdst,
    branch,
    memread,
    memtoreg,
    alu_select,
    memwrite,
    alusrc,
    regwrite,
    opcode
    );
//Register file behavior*************************

assign instrf1=idata[12:10];
assign instrf2=idata[9:7];
assign instrf3=idata[6:4];

wire [15:0] rrdata1,
wire [15:0] rrdata2,
wire [15:0] rwdata,
wire [15:0] rwaddr,

RegFile regfile1(
    rrdata1,
    rrdata2,
    clock,
    rwdata,
    rwaddr,
    instrf1,
    instrf2,
    regwrite
    );

assign immeddata=idata[6:0];

//Select write register source*********************

MUX2 wirteregsrc(
    rwaddr,
    instrf2,
    instrf3,
    regdst
    );

wire [15:0] signext1;
SignExt signext1(
    signext1,
    immeddata
    );
    
wire [15:0] alu2ndsrc
MUX2 AluSRC(
    alu2ndsrc,
    instrucfield2,
    signext1,
    alusrc
    );

wire [15:0] aluresult;
wire [15:0] zero_result;
ALU alu1(
    aluresult,
    zero_result,
    instrf1,
    alu2ndsrc
    )

wire [15:0] memreaddata;
wire [15:0] io_display;
wire io_sw0;
wire io_sw1;
DMemory_IO datamemory(
    memreaddata,
    io_display,
    clock,
    aluresult,
    rrdata2,
    memwrite,
    memread,
    io_sw0,
    io_sw1
    );

MUX2 regwritedatasource(
    rwdata,
    memreaddata,
    aluresult,
    memtoreg
    );







































endmodule

