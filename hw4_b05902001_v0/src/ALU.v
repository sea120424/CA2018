module ALU
(
	data1_i,
    	data2_i,
    	ALUCtrl_i,  
    	data_o,     
    	Zero_o    
);

input [31:0] data1_i, data2_i ;
input [3:0]   ALUCtrl_i ;
output [31:0] data_o ;
output Zero_o ;
/*
	001 addi
	011 sub
	100 mul
	101 or
	110 and
	111 add
*/
assign data_o = (
  	(ALUCtrl_i  == 3'b011) ? data1_i - data2_i :
	(ALUCtrl_i  == 3'b100) ? data1_i * data2_i :
	(ALUCtrl_i  == 3'b101) ? data1_i | data2_i :
	(ALUCtrl_i  == 3'b110) ? data1_i & data2_i :
	(ALUCtrl_i  == 3'b111) ? data1_i + data2_i :
	(ALUCtrl_i  == 3'b001) ? data1_i + (data2_i>>20):
	0
);

endmodule
 