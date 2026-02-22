module ROM32(
    input [31:0] addr,
    input ce, 
    output [31:0] out
);

    reg [31:0] ROM_ [0:31];

    // Program 
    initial begin
        ROM_[0] = 32'hFEEDBEEF;
        ROM_[1] = 32'hDEEFFFEB;
        ROM_[2] = 32'hABACADAB;
        ROM_[3] = 32'hFEEDBEEF;
        ROM_[4] = 32'hDEEFFFEB;
        ROM_[5] = 32'hABACADAB;
        ROM_[6] = 32'hFEEDBEEF;
        ROM_[7] = 32'hDEEFFFEB;
        ROM_[8] = 32'hABACADAB;
        ROM_[9] = 32'hDEEFFFEB;
        ROM_[10] = 32'hABACADAB;
    end

    reg [31:0] out_;

    always @(addr) begin
        if (ce == 1) begin
            out_ = ROM_[addr[31:2]];
        end else begin out_ = 32'hzzzzzzzz; end
    end

    assign out = out_;

endmodule
