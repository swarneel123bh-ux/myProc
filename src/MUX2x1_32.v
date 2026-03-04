module MUX2x1_32(
  input select,
  input [31:0] inp0, inp1,
  output [31:0] out
);

  reg [31:0] out_;

  always @(*) begin
    if (select == 0) begin
      out_ = inp0;
    end else begin
      out_ = inp1; 
    end
  end

  assign out = out_;

endmodule
