module ALU_Control
(
	funct_i,
	funct14_12_i,
    	ALUOp_i,
    	ALUCtrl_o
);

input [6:0] funct_i;
input [2:0] funct14_12_i;
input [1:0] ALUOp_i;
output [3:0] ALUCtrl_o;

assign ALUCtrl_o = (
	(ALUOp_i == 2'b11) 	  ? 3'b001 : 	// addi
	(funct_i == 7'b0100000)    ? 3'b011 : 	// sub
	(funct_i == 7'b0000001)    ? 3'b100:	// mul
	(funct14_12_i == 3'b110)   ? 3'b101:	// or
	(funct14_12_i == 3'b111)   ? 3'b110:	// and
	(ALUOp_i == 2'b00)         ? 3'b111:	// add
	3'b000					// error
);

endmodule
 