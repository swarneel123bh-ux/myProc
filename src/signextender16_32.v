module signextender16_32(
  input [15:0] inp,
  output [31:0] op
);

  reg [31:0] out_;

  initial begin
    out_ = 32'h00000000;
  end

  always @(*) begin
    out_ = {(inp[15] == 0) ? 16'h0000 : 16'hFFFF, inp};
  end

  assign op = out_;

endmodule
