module RAM32tb();

  reg [31:0] addr, dataIn;
  reg clk, writeEnable, RAMWriteEnable, RAMEnable;
  wire [31:0] dataOut;

  RAM32 uut(
    .addr(addr), .dataIn(dataIn),
    .clk(clk), .writeEnable(writeEnable),
    .dataOut(dataOut),.enable(RAMEnable)
  );

  always begin
    #3; clk = ~clk;
  end

  initial begin
  $dumpfile("build/RAM32tb.vcd");
  $dumpvars(0, RAM32tb);

  clk = 0;
  RAMEnable = 0;

  addr = 0; #3;
  RAMEnable = 1;
  #3;
  RAMEnable = 0;

  addr = 5;
  dataIn = 7;
  writeEnable = 1;
  #1;
  writeEnable = 0; #2;

  RAMEnable = 1;
  addr = 5;
  dataIn = 7;
  writeEnable = 1;
  #1;
  writeEnable = 0; #2;
  RAMEnable = 0;


  RAMEnable = 1;
  addr = 3; #3;
  addr = 5; #3;

  $finish;
  end

endmodule
