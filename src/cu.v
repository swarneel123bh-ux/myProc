module cu (
    input  [31:0] instr,
    output [1:0] aluCtrl,
    output [3:0] regFileReadAddr1, regFileReadAddr2, regFileWriteAddr,
    output aluSrc, regFileWriteEnable, RAMWriteEnable,
    aluOut_dataMemOut_select, RAMEnable, BranchFlg
);

  reg [1:0] aluCtrl_;
  reg regFileWriteEnable_, RAMWriteEnable_;
  reg [3:0] regFileWriteAddr_;
  reg [3:0] regFileReadAddr1_, regFileReadAddr2_;
  reg aluSrc_, aluOut_dataMemOut_select_, RAMEnable_, BranchFlg_;

  // OR outreg3, inreg1, inreg2 -> R-type
  // SUBI outreg4, inreg5, immval21 -> I-type
  // SW reg6, 5 (reg7) -> I-type (NOT IMPLEMENTED)
  // BEQ reg9, reg8, 7 -> J-type (NOT IMPLEMENTED)
  always @(*) begin
    casez (instr[31:26])
      // R-type (only OR)
      // 000000 5'b<Rd> 5'b<Rs> 5'b<Rt> 5'b<shamt> 6'b<funct>
      6'b000000: begin
        // Only OR as R-type supported as of now hence we set undef
        aluCtrl_ = 2'b00;
        regFileWriteAddr_ = instr[25:21];
        regFileWriteEnable_ = 1;
        regFileReadAddr1_ = instr[20:16];
        regFileReadAddr2_ = instr[15:11];
        aluSrc_ = 0;
        aluOut_dataMemOut_select_ = 0;
        RAMEnable_ = 0;
        RAMWriteEnable_ = 0;
        BranchFlg_ = 0;
      end
      // I-type
      // 000001 5'b<Rd> 5'b<rS> 16'b<ImmVal>
      6'b000001: begin
        aluCtrl_ = 2'b01;
        regFileWriteAddr_ = instr[25:21];
        regFileWriteEnable_ = 1;
        regFileReadAddr1_ = instr[20:16];
        regFileReadAddr2_ = 5'bzzzzz;
        aluSrc_ = 1;
        aluOut_dataMemOut_select_ = 0;
        RAMEnable_ = 0;
        RAMWriteEnable_ = 0;
        BranchFlg_ = 0;
      end

      // SW destReg, <ImmVal>(srcAddrReg)
      // I-type 
      // 000010 5'b<Rd> 5'b<Rs> 16'b<ImmVal>
      // ALU needs to do an ADD operation
      6'b000010: begin
        // aluCtrl_ = ??? WE NEED AN ADD OR A SUBTRACT
        aluCtrl_ = 2'b10;
        regFileWriteEnable_ = 1;
        regFileWriteAddr_ = instr[25:21];
        regFileReadAddr1_ = instr[20:16];
        regFileReadAddr2_ = 5'bzzzzz;
        aluSrc_ = 1;
        RAMWriteEnable_ = 0; 
        aluOut_dataMemOut_select_ = 1;
        RAMEnable_ = 1;
        RAMWriteEnable_ = 0;
        BranchFlg_ = 0;
      end
      
      // BEQ <[destAddrReg]> <[value1Register]> <ImmVal2>
      // 000011 5'b<RegisterNumber_A> 5'b<RegisterNumber_B> 16'b<ImmVal=>OFFSET>
      // IF A == B THEN SHIFT PC+4 to PC+4+OFFSET (OFFSET CALCULTAED BY ASSEMBLER)
      // ALU needs to do SUBI operation on RegisterNumber_A and ImmVal
      6'b000011:begin
        aluCtrl_ = 2'b10;
        regFileWriteEnable_ = 0;
        regFileWriteAddr_ = 5'bzzzzz;
        regFileReadAddr1_ = instr[25:21];
        regFileReadAddr2_ = instr[20:16];
        aluSrc_ = 0;
        RAMWriteEnable_ = 0; 
        aluOut_dataMemOut_select_ = 0;
        RAMEnable_ = 0;
        RAMWriteEnable_ = 0;
        BranchFlg_ = 1;
      end

      default: begin
        aluCtrl_ = 2'bxx;
        regFileWriteAddr_ = 5'bxxxxx;
        regFileWriteEnable_ = 1'bx;
        regFileReadAddr1_ = 5'bxxxxx;
        regFileReadAddr2_ = 5'bxxxxx;
        aluSrc_ = 1'bx;
      end
    endcase
  end

  assign aluCtrl = aluCtrl_;
  assign regFileWriteAddr = regFileWriteAddr_;
  assign regFileWriteEnable = regFileWriteEnable_;
  assign regFileReadAddr1 = regFileReadAddr1_;
  assign regFileReadAddr2 = regFileReadAddr2_;
  assign aluSrc = aluSrc_;
  assign RAMWriteEnable = RAMWriteEnable_;
  assign aluOut_dataMemOut_select = aluOut_dataMemOut_select_;
  assign RAMEnable = RAMEnable_;
  assign BranchFlg = BranchFlg_;

endmodule
