module Control
(
    	Op_i,
    	RegDst_o,
    	ALUOp_o,
    	ALUSrc_o,
    	RegWrite_o
);

input [6:0] Op_i ;
output RegDst_o;
output [1:0] ALUOp_o;
output ALUSrc_o;
output RegWrite_o ;


assign  ALUOp_o = ~Op_i[5] ? 2'b11 : 2'b00 ;
assign ALUSrc_o = ~Op_i[5] ;
assign RegWrite_o = 1 ;

endmodule
 