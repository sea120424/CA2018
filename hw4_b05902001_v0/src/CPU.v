module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire [31:0] inst_addr, inst;


Control Control(
    .Op_i       (inst[6:0]),
    .RegDst_o   (),
    .ALUOp_o    (ALU_Control.ALUOp_i),
    .ALUSrc_o   (MUX_ALUSrc.select_i),
    .RegWrite_o (Registers.RegWrite_i )
);

Adder Add_PC(
    .data1_in   (inst_addr),
    .data2_in  (32'd4),
    .data_o     (PC.pc_i)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (),
    .pc_o       (inst_addr)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    (inst)
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[19:15]),
    .RTaddr_i   (inst[24:20]),
    .RDaddr_i   (inst[11:7]), 
    .RDdata_i   (),
    .RegWrite_i (), 
    .RSdata_o   (ALU.data1_i), 
    .RTdata_o   (MUX_ALUSrc.data1_i) 
);

/*
MUX5 MUX_RegDst(
    .data1_i    (),
    .data2_i    (),
    .select_i   (),
    .data_o     ()
);
*/


MUX32 MUX_ALUSrc(
    .data1_i    (),
    .data2_i    (),
    .select_i   (),
    .data_o     (ALU.data2_i)
);


Sign_Extend Sign_Extend(
    .data_i     (inst[31:0]),
    .data_o     (MUX_ALUSrc.data2_i)
);


ALU ALU(
    .data1_i    (),
    .data2_i    (),
    .ALUCtrl_i  (),
    .data_o     (Registers.RDdata_i),
    .Zero_o     ()
);



ALU_Control ALU_Control(
    .funct_i    (inst[31:25]),
    .funct14_12_i    (inst[14:12]),
    .ALUOp_i    (),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);


endmodule

