module Proc (
    input reset
);

    // CLOCK SETUP
    reg clk;
    initial clk = 0;
    always begin #1; clk = ~clk; end

    // ALL COMPONENT WIRES
    // For Program Counter PC
    wire [31:0] pcIp, pcOp;
    wire pcWen, pcResb, pcCout;

    // For Instruction Memory
    wire [31:0] instr_;

    // For dataMemory
    wire [31:0] dataMemoryOut_;

    // For Control Unit CU
    wire [1:0] aluCtrl_;
    wire [3:0] regFileReadAddr1_, regFileReadAddr2_, regFileWriteAddr_;
    wire aluSrc_, regFileWriteEnable_, RAMWriteEnable_, 
      aluOut_dataMemOut_select, RAMEnable_, BranchFlg_;

    // For arithmetic logic unit ALU
	  wire [31:0] aluOut_;		// Operation result
	  wire zflg, ovflg, brwflg, negflg; // Output characteristic flags

    // For register file REGISTERFILE
    wire [31:0] regFileReadData1_, regFileReadData2_;

    // For mux to choose between ALU output and DATAMEMORY output
    wire [31:0] alu_dataMem_MUXOut_;

    // For sign-extender SIGNEXTEND16_32
    wire [31:0] aluImmVal;

    // For branch calculator circuit
    wire [31:0] pcBranchOffset_;



    // Some initialization before declaring units
    assign pcResb = reset;  // Assign reet to input for testbench purposes
    assign pcWen = clk;     // Assign pcWriteEnableSignal to clk




    // MODULE DECLARATIONS
    // Adder for the program counter
    wire [31:0] pcIntermid;
    add32 pcAdder(
        .A(pcOp), .B(32'h00000004), .Cin(1'b0),
        .Sum(pcIntermid), .Cout(pcCout)
    );

    register32 PC(
        .ip(pcIp), .wen(pcWen), .resb(pcResb),
        .op(pcOp)
    );

    ROM32 instrMem(
      .addr(pcOp >> 2), .ce(clk), .out(instr_)
    );

    cu CU(
      .instr(instr_),
      .aluCtrl(aluCtrl_),
      .regFileWriteAddr(regFileWriteAddr_),
      .regFileWriteEnable(regFileWriteEnable_),
      .regFileReadAddr1(regFileReadAddr1_), .regFileReadAddr2(regFileReadAddr2_),
      .aluSrc(aluSrc_), .RAMWriteEnable(RAMWriteEnable_), 
      .aluOut_dataMemOut_select(aluOut_dataMemOut_select),
      .RAMEnable(RAMEnable_),
      .BranchFlg(BranchFlg_)
    );

    MUX2x1_32 ALU_DATAMEM_MUX(
      .select(aluOut_dataMemOut_select),
      .inp0(aluOut_), .inp1(dataMemoryOut_),
      .out(alu_dataMem_MUXOut_)
    );

    registerFile32x9 REGISTERFILE(
      .readAddr1(regFileReadAddr1_), 
      .readAddr2(regFileReadAddr2_),
      .writeAddr(regFileWriteAddr_),
      .writeData(alu_dataMem_MUXOut_),
      .writeEnable(regFileWriteEnable_),
      .resetb(1'b1),
      .readData1(regFileReadData1_),
      .readData2(regFileReadData2_),
      .clk(clk)
    );

    signextender16_32 SIGNEXTEND16_32(
      .inp(instr_[15:0]), .op(aluImmVal)
    );

    alu32 ALU(
      .A(regFileReadData1_), 
      .B((aluSrc_ == 1) ? aluImmVal : regFileReadData2_), 
      .Ctrl(aluCtrl_),
      .Out(aluOut_), 
      .zflg(zflg), 
      .ovflg(ovflg), 
      .brwflg(brwflg), 
      .negflg(negflg)
    );

    RAM32 DATAMEMORY(
      .addr(aluOut_), .dataIn(regFileReadData2_),
      .clk(clk), .writeEnable(RAMWriteEnable_),
      .dataOut(dataMemoryOut_), .enable(RAMEnable_)
    );
    
    MUX2x1_32 PC_BRANCH_MUX(
        .select(((BranchFlg_ && zflg) == 1) ? 1'b1 : 1'b0),
        .inp0(pcIntermid), .inp1(pcBranchOffset_),
        .out(pcIp)
    );
    
    
    add32 branchOffsetCalculator(
        .A(pcIntermid), .B(aluImmVal << 2), .Cin(1'b0),
        .Sum(pcBranchOffset_), .Cout(pcCout)
    );

endmodule
