module ROM32tb();

    reg [31:0] addr;
    reg ce;
    wire [31:0] out;

    ROM32 uut(
        .addr(addr), .ce(ce),
        .out(out)
    );

    initial begin
        $dumpfile("build/ROM32.vcd");   // Name of output file
        $dumpvars(0, ROM32tb);
        ce = 1;
        addr = 0; #1;
        addr = 1; #1;
        addr = 2; #1;
        addr = 3; #1;
        addr = 4; #1;

        ce = 0; #3;
        addr = 5; #1;
        ce = 1; #3;

        addr = 6; #1;
        addr = 7; #1;
        addr = 8; #1;
        addr = 9; #1;
        addr = 10; #1;

        $finish;
    end

endmodule