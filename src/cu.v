module cu (
    input  [31:0] instr,
    output [ 1:0] aluCtrl
);

  reg [1:0] aluCtrl_;

  // OR reg3, reg1, reg2 -> R-type
  // SUBI reg4, reg5, 21 -> I-type
  // SW reg6, 5 (reg7) -> I-type (NOT IMPLEMENTED)
  // BEQ reg9, reg8, 7 -> J-type (NOT IMPLEMENTED)
  always @(*) begin
    casez (instr[31:26])
      // R-type (only OR)
      6'b000000: begin
        // Only OR as R-type supported as of now hence we set undef
        aluCtrl_ = (instr[5:0] == 0) ? 0 : 2'bxx;
      end
      // I-type (SUBI only for now)
      6'b000001: begin
        aluCtrl_ = 1;
      end
      default: begin
        aluCtrl_ = 2'bxx;
      end
    endcase
  end

  assign aluCtrl = aluCtrl_;

endmodule
