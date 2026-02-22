module add32tb();

    reg [31:0] A, B;
    reg Cin;
    wire [31:0] Sum;
    wire Cout;

    add32 uut(
        .A(A), .B(B), .Cin(Cin),
        .Sum(Sum), .Cout(Cout)
    );

    integer fd;

    initial begin
        $dumpfile("build/add32tb.vcd");
        $dumpvars(0, add32tb);
        A = 0; B = 0; Cin = 0; #3;
        A = 0; B = 0; Cin = 1; #3;
        A = 0; B = 1; Cin = 0; #3;
        A = 0; B = 1; Cin = 1; #3;
        A = 1; B = 0; Cin = 0; #3;
        A = 1; B = 0; Cin = 1; #3;
        A = 2**32 - 1; B = 2 ** 32 - 1; Cin = 1; #3;
    end

endmodule