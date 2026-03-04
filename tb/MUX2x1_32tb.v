module MUX2x1_32tb();

  reg select;
  reg [31:0] inp0, inp1;
  wire [31:0] out;

  MUX2x1_32 uut(
    .select(select),
    .inp0(inp0), .inp1(inp1),
    .out(out)
  );

  initial begin

    $dumpfile("build/MUX2x1_32tb.vcd");
    $dumpvars(0, MUX2x1_32tb);

    inp0 = 6; inp1 = 7; select = 0; #3;
    inp0 = 6; inp1 = 7; select = 1; #3;

    $finish;
  end

endmodule
