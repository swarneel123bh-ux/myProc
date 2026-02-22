module Proc (
    input reset, 
    output [31:0] instr
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
        .addr(pcOp), .ce(clk), .out(instr_)
    );

    assign instr = instr_;

endmodule