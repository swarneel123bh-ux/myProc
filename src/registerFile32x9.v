module registerFile32x9(
    input [3:0] readAddr1, readAddr2, writeAddr,
    input [31:0] writeData,
    input writeEnable, resetb,
    output [31:0] readData1, readData2
);

    reg [31:0] registers [8:0];

    integer i;
    initial begin
        for(i = 0; i < 9; i = i + 1) begin
            registers[i] = 0;
        end
    end

    always @(posedge writeEnable) begin
        if (writeAddr < 9) begin
            registers[writeAddr] = writeData;
        end 
    end

    integer j;
    always @(negedge resetb) begin
        for (j = 0; j < 9; j = j + 1) begin
            registers[j] = 0;
        end
    end

    assign readData1 = (readAddr1 < 9) ? registers[readAddr1] : 32'h00000000;
    assign readData2 = (readAddr2 < 9) ? registers[readAddr2] : 32'h00000000;

endmodule