module cutb();
  
  reg [31:0] instr;
  wire [1:0] aluCtrl;
  cu uut(
    .instr(instr),
    .aluCtrl(aluCtrl)
  );

  initial begin
		$dumpfile("build/cutb.vcd");   // Name of output file
    $dumpvars(0, cutb);
    // OR $1, $2, $3
    instr = 32'h00110D00;
    // instr = 32'b000000 00001 00010 00011 00000 00000;
    // => instr = 0x00 0x11 0x0D 0x00;
    #3;

    // SUBI $1, $2, 21
    instr = 32'h04220015;
    // instr = 32'b000001 00001 00010 0000000000010101;
    // instr = 0x04 0x22 0x00 0x15;
    #3;

    // OR $4, $6, $7
    instr = 32'h00110D00;
    // instr = 32'b000000 00100 00110 00111 00000 000000;
    // 00000000 10000110 00111000 00000000;
    // 0x00     0x86      0x38    0x00
    // => instr = 0x00 0x11 0x0D 0x00;
    #3;

    $finish;
  end

endmodule
