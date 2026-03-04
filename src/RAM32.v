module RAM32(
  input [31:0] addr, dataIn,
  input clk, writeEnable, enable,
  output [31:0] dataOut
);

  reg [31:0] memory[31:0];

  integer i;

  initial begin
    for (i = 0; i < 31; i = i + 1) begin
      memory[i] = 32'h00000000;
    end
  end

  always @(posedge clk) begin
    if ((writeEnable == 1) && (addr < 31)) begin
      memory[addr] = dataIn;
    end
  end
  
  // We assign 0 to any address that is above 31 because we cannot have actual
  // data that spans to that width of memory 9about 16 GB, cannot simulate)
  // hence we assume its just 0 instead of high impedance
  assign dataOut = ((addr < 31) && (enable == 1)) ? memory[addr] : 32'h00000000;

endmodule
