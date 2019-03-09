module ALU_Control
(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);

input   [9:0]   funct_i;
input   [1:0]   ALUOp_i;
output  [3:0]   ALUCtrl_o;

reg     [3:0]   temp;

assign ALUCtrl_o = temp;

always@(funct_i or ALUOp_i) begin
    if (ALUOp_i == 2'b10) begin
        case (funct_i)
            10'b0100000000: temp <= 4'b0110;//SUB
            10'b0000000000: temp <= 4'b0010;//ADD
            10'b0000000111: temp <= 4'b0000;//AND
            10'b0000000110: temp <= 4'b0001;//OR
            10'b0000001000: temp <= 4'b0100;//MUL
        endcase
    end
    else if (ALUOp_i == 2'b00) begin
        temp <= 4'b0010;//ADD
    end
    else if (ALUOp_i == 2'b01) begin
        temp <= 4'b0110;//SUB
    end
end

endmodule