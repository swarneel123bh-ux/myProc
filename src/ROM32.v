module ROM32(
    input [31:0] addr,
    input ce, 
    output [31:0] out
);

    reg [31:0] ROM_ [0:31];

    integer i;

    // Program 
    initial begin

        for (i = 0; i < 32; i = i + 1) begin
          ROM_[i]  = 32'h00000000;
        end

        // OR $1, $2, $3 => $1 = $2 | $3;
        ROM_[0] = 32'b00000000001000100001100000000000;
        // SUBI $1, $2, 21 => $1 = $2 - 21;
        ROM_[1] = 32'h04220015;
        // SUBI $2, $1, 0xFFFFFFEA => $1 = $2 - 0xFFFFFFEA; -> Answer will be 1
        ROM_[2] = 32'b00000100010000101111111111101010;
        // SW $6, 10($1) -> Load dataMem from Addr[<$1> + 10] into $6
        ROM_[3] = 32'b00001000110000010000000000000000;
        // OR $3, $1, $6 => $3 = $1 | $6
        ROM_[4] = 32'b00000000011000010011000000000000;
    end

    reg [31:0] out_;

    always @(*) begin
      if (ce == 1) begin
        out_ = (addr < 11) ? ROM_[addr] : 32'hx;
      end
    end

    assign out = out_;

endmodule
