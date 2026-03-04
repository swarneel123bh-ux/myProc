module Proc (
    input reset
);

    reg clk;

    initial clk = 0;

    always begin
        #1;
        clk = ~clk;
    end

    wire [31:0] pcIp;
    wire pcWen, pcResb;
    assign pcResb = reset;
    assign pcWen = clk;

    wire [31:0] pcOp;

    wire pcCout;
    add32 pcAdder(
        .A(pcOp), .B(32'h00000004), .Cin(1'b0),
        .Sum(pcIp), .Cout(pcCout)
    );

    register32 PC(
        .ip(pcIp), .wen(pcWen), .resb(pcResb),
        .op(pcOp)
    );

    wire [31:0] instr_;
    ROM32 instrMem(
        .addr(pcOp >> 2), .ce(clk), .out(instr_)
    );

    wire [1:0] aluCtrl_;
    wire [3:0] regFileReadAddr1_, regFileReadAddr2_, regFileWriteAddr_;
    wire aluSrc_, regFileWriteEnable_;
    cu CU(
      .instr(instr_),
      .aluCtrl(aluCtrl_),
      .regFileWriteAddr(regFileWriteAddr_),
      .regFileWriteEnable(regFileWriteEnable_),
      .regFileReadAddr1(regFileReadAddr1_), .regFileReadAddr2(regFileReadAddr2_),
      .aluSrc(aluSrc_)
    );

	  wire [31:0] aluOut_;		// Operation result

    wire [31:0] regFileReadData1_, regFileReadData2_;
    registerFile32x9 REGISTERFILE(
      .readAddr1(regFileReadAddr1_), 
      .readAddr2(regFileReadAddr2_),
      .writeAddr(regFileWriteAddr_),
      .writeData(aluOut_),
      .writeEnable(regFileWriteEnable_),
      .resetb(1'b1),
      .readData1(regFileReadData1_),
      .readData2(regFileReadData2_),
      .clk(clk)
    );


    wire [31:0] aluImmVal;
    signextender16_32 SIGNEXTEND16_32(
      .inp(instr_[15:0]), .op(aluImmVal)
    );

	  wire zflg, ovflg, brwflg, negflg; // Output characteristic flags
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

endmodule
