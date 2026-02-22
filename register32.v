module register32(
    input [31:0] ip, 
    input wen, resb,
    output [31:0] op
);

    reg [31:0] register;

    always @(posedge wen or negedge resb) begin
        if (wen == 1) begin
            register = ip;
        end 
        
        if (resb == 0) begin
            register = 0;
        end 

        if (wen == 1 && resb == 0) begin
            register = 32'bz;
        end
    end

    assign op = register;
endmodule