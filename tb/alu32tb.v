module alu32tb();

	reg [31:0] A, B;		// Inputs
	reg [1:0] Ctrl;			// For now only four operations supported
	wire [31:0] Out;		// Operation result
	wire zflg, ovflg, brwflg, negflg; // Output characteristic flags

	alu32 uut(
		.A(A), .B(B), .Ctrl(Ctrl),
		.Out(Out), .zflg(zflg), .ovflg(ovflg), .brwflg(brwflg), .negflg(negflg)
	);

	initial begin
		$dumpfile("build/alu32tb.vcd");   // Name of output file
    $dumpvars(0, alu32tb);
		A = 0; B = 0; Ctrl = 1; #3;		// SUBI
		A = 10; B = 5; Ctrl = 1; #3;	// SUBI

		A = 0; B = 0; Ctrl = 0; #3;		// OR
		A = 10; B = 5; Ctrl = 0; #3;	// OR

		// OTHER INSTRUCTIONS NOT IMPLEMENTED YET

		$finish;
	end

endmodule
