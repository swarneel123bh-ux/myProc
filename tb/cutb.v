module cutb();
  
  reg  [31:0] instr;
  wire [1:0] aluCtrl;
  wire [3:0] regFileReadAddr1, regFileReadAddr2, regFileWriteAddr;
  wire regFileWriteEnable, aluSrc;

  cu uut(
    .instr(instr),
    .aluCtrl(aluCtrl),
    .regFileWriteAddr(regFileWriteAddr),
    .regFileWriteEnable(regFileWriteEnable),
    .regFileReadAddr1(regFileReadAddr1), .regFileReadAddr2(regFileReadAddr2),
    .aluSrc(aluSrc)
  );

  initial begin
		$dumpfile("build/cutb.vcd");   // Name of output file
    $dumpvars(0, cutb);

    // OR $1, $2, $3 => $1 = $2 | $3;
    instr = 32'b00000000001000100001100000000000;
    #3;

    // SUBI $1, $2, 21 => $1 = $2 - 21;
    // $1 will have FFFFFFEB
    instr = 32'h04220015;
    #3;

    // SUBI $2, $1, 0xFFFFFFEA => $1 = $2 - 0xFFFFFFEA; -> Answer will be 1
    instr = 32'b00000100010000101111111111101010;
    #3;

    // OR $3, $1, $2 => $4 = $1 | $7
    instr = 32'b00000000011000010001000000000000;
    #3;

    $finish;
  end

endmodule
