module alu32(
	input [31:0] A, B,		// Inputs
	input [1:0] Ctrl,			// For now only four operations supported
	output [31:0] Out,		// Operation result
	output zflg, ovflg, brwflg, negflg // Output characteristic flags
);

	reg [31:0] Out_;		// Operation result
	reg zflg_, ovflg_, brwflg_, negflg_; // Output characteristic flags

	always @(*) begin
		case (Ctrl)
			// OR reg3, reg1, reg2 -> A = reg1, B = reg2
			4'b00: begin
				Out_ = A | B;
			end
			// SUBI reg4, reg5, 21 -> A = reg5, B = 21
			4'b01: begin
				Out_  = A - B;
			end
			// SW reg6, 5 (reg7) -> ???
			4'b10: begin
				Out_ = 0;	// Setting to 0 for now
			end
			// BEQ reg9, reg8, 7 -> ???
			4'b11:begin
				Out_ = 0; // Setting to 0 for now
			end
		endcase

		// Check for zero
		if (Out_ == 0) begin
			zflg_ = 1;
		end else begin zflg_ = 0; end
		// Check for negative result
		if (Out_[31] == 1) begin
			negflg_ = 1;
		end else begin negflg_ = 0; end
		// Check if borrow was required
		if (A < B) begin
			brwflg_ = 1;
		end
		// Check if overflow was there -> Not required right now
		ovflg_ = 0;
	end

	// Assign all reg's outputs
	assign Out = Out_;
	assign zflg = zflg_;
	assign ovflg = ovflg_;
	assign negflg = negflg_;
	assign brwflg = brwflg_;

endmodule
