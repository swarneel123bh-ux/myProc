module Proctb();

    reg reset;
    wire [31:0] instr;

    Proc uut(
        .reset(reset),
        .instr(instr)
    );

    initial begin
        $dumpfile("build/Proctb.vcd");
        $dumpvars(0, Proctb);
        reset = 0;   // reset active
        #2; reset = 1; // release reset
        #100;
        $finish;
    end

endmodule