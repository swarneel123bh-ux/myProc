module registerFile32x9tb();

    reg [3:0] readAddr1, readAddr2, writeAddr;
    reg [31:0] writeData;
    reg writeEnable, resetb;
    wire [31:0] readData1, readData2;

    registerFile32x9 uut(
        .readAddr1(readAddr1), .readAddr2(readAddr2), .writeAddr(writeAddr),
        .writeData(writeData), .writeEnable(writeEnable), .resetb(resetb),
        .readData1(readData1), .readData2(readData2)
    );

    initial begin
        $dumpfile("build/registerFile32x9.vcd");   // Name of output file
        $dumpvars(0, registerFile32x9tb);
        resetb = 0;
        writeEnable = 0;
        readAddr1 = 0;
        readAddr2 = 0;
        writeAddr = 0;
        #1;

        resetb = 1;

        writeData = 32'hFEEDBEEF; #1;
        writeAddr =  4;
        writeEnable = 1; #1;
        writeEnable = 0;

        readAddr1 = 4;
        readAddr2 = 7;     
        #3;

        writeData = 32'hFEEDBEEF; #1;
        writeAddr =  7;
        writeEnable = 1; #1;
        writeEnable = 0;
        #3;

        readAddr1 = 4;
        readAddr2 = 3;     
        #3;

        $finish;
    end

endmodule