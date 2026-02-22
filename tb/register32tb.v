module register32tb();

    reg [31:0] ip; 
    reg resb;
    wire [31:0] op;
    reg clk;

    register32 uut(
        .ip(ip), .op(op),
        .wen(clk), .resb(resb)
    );

    always begin
        #3; clk = ~clk;
    end

    initial begin
        $dumpfile("build/register32.vcd");   // Name of output file
        $dumpvars(0, register32tb);
        clk = 0;
        resb = 1;
        #6;
        ip = 32'hFEEDBEEF; 
        #10;
        resb = 0;
        #10;
        resb = 1;
        #10;
        ip = 32'hFEEBDEEF;
        #10;
        $finish;
    end

endmodule