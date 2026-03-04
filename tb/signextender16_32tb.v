  module signextender16_32tb();

    reg [15:0] inp;
    wire [31:0] op;
    signextender16_32 uut(
      .inp(inp), .op(op)
    );
    initial begin
      $dumpfile("build/signextender16_32tb.vcd");   // Name of output file
      $dumpvars(0, signextender16_32tb);

      inp = 16'h00AA;
      #3;
      inp = 16'hA00A; 
      #3;

      inp = 16'h0012;
      #3;
      inp = 16'h8012; 
      #3;

      inp = 16'h00AA;
      #3;
      inp = 16'h700A; 
      #3;
    
      $finish;
    end

  endmodule
