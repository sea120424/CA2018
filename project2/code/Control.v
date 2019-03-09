module Control
(
    Op_i,
    RegDst_o,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o,
    MemRead_o,
    MemWrite_o,
    MemToReg_o,
    Branch_o,
    Immediate_format_o
);

input   [6:0]   Op_i;

output          RegDst_o;
output  [1:0]   ALUOp_o;
output          ALUSrc_o;
output          RegWrite_o;
output          MemRead_o;
output          MemWrite_o;
output          MemToReg_o;
output          Branch_o;
output          Immediate_format_o;

reg             RegDst_o;
reg     [1:0]   ALUOp_o;
reg             ALUSrc_o;
reg             RegWrite_o;
reg             MemRead_o;
reg             MemWrite_o;
reg             MemToReg_o;
reg             Branch_o;
reg     [1:0]   Immediate_format_o;


always@(Op_i) begin
    
    RegDst_o <= 1'b0;
    MemRead_o <= 1'b0;
    MemWrite_o <= 1'b0;
    MemToReg_o <= 1'b0;
    Branch_o <= 1'b0;
    Immediate_format_o <= 2'b00;            //I-format

    if ( Op_i == 7'b0110011 ) begin         //R-format
        ALUSrc_o <= 1'b0;
        ALUOp_o <= 2'b10;
        RegWrite_o <= 1'b1;
    end
    else if ( Op_i == 7'b0010011 ) begin    //ADDI
        ALUSrc_o <= 1'b1;
        ALUOp_o <= 2'b00;
        RegWrite_o <= 1'b1;
    end
    else if ( Op_i == 7'b0000011 ) begin    //lw
        ALUSrc_o <= 1'b1;
        ALUOp_o <= 2'b10;
        RegWrite_o <= 1'b1;
        MemRead_o <= 1'b1;
        MemToReg_o <= 1'b1;
    end
    else if ( Op_i == 7'b0100011 ) begin    //sw
        ALUSrc_o <= 1'b1;
        ALUOp_o <= 2'b10;
        RegWrite_o <= 1'b0;
        MemWrite_o <= 1'b1;
        Immediate_format_o <= 2'b01;        //S-format
    end
    else if ( Op_i == 7'b1100011 ) begin    //beq
        ALUSrc_o <= 1'b0;
        ALUOp_o <= 2'b10;
        RegWrite_o <= 1'b0;
        Branch_o <= 1'b1;
        Immediate_format_o <= 2'b10;        //SB-format
    end
    
end

endmodule