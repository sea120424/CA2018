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


wire [31:0] PC_Normal, pc_i, pc_pre, inst_addr, inst;
wire Zero;
wire [31:0] IF_ID_inst, IF_ID_inst_addr;

wire [31:0] reg_rd1, reg_rd2, imm_o, branch_length, PC_Branch;
wire [9:0] control;
wire [6:0] ID_EX_mux_i;

wire [1:0] ALUOp, ID_EX_MEM, ID_EX_WB;
wire [4:0]  forwarding_rs1, forwarding_rs2, ID_EX_hazard, ID_EX_rd;
wire [31:0] EX_imm;

wire [31:0] EX_rd1, EX_rd2, ALUInput1, ALUInput2, ALUInput2_pre, ALUResult, EX_inst;
wire [3:0]  ALUCtrl;
wire [1:0]  mux_forwardA, mux_forwardB;

wire [31:0] DataMemory_addr, DataMemory_writedata;
wire [4:0]  EX_MEM_Rd;
wire [1:0]  EX_MEM_wb; 

wire [31:0] read_data;

wire [31:0] WB_from_memory, WB_from_ALU;
wire [4:0]  MEM_WB_down_o;
wire [1:0]  MEM_WB_wb;

wire [31:0] mux_rightest_o;


/////*****IF*****/////

Adder Add_PC_IF(
    .data1_in   (inst_addr),
    .data2_in   (32'd4),
    .data_o     (PC_Normal)
);

MUX32 PC_SEL_Branch (
    .data1_i    (PC_Normal),
    .data2_i    (PC_Branch),
    .select_i   (branch),
    .data_o     (pc_pre)
);

MUX32 PC_SEL_Hazard (
    .data1_i    (inst_addr),
    .data2_i    (pc_pre),
    .select_i   (PC_Write),
    .data_o     (pc_i)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (pc_i),
    .pc_o       (inst_addr)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    (inst)
);

/////*****IF_ID*****/////

IF_ID IF_ID(
    .send_i     (IF_ID_Write),       // from hazrd_detect ( Bubble_Insertion_o)
    .clk_i      (clk_i),
    .inst_i     (inst),
    .pc_i       (inst_addr),
    .flush_i    (branch),         //
    .inst_o     (IF_ID_inst),
    .pc_o       (IF_ID_inst_addr)
);

/////*****ID*****/////

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (IF_ID_inst[19:15]),
    .RTaddr_i   (IF_ID_inst[24:20]),
    .RDaddr_i   (MEM_WB_down_o), 
    .RDdata_i   (mux_rightest_o),
    .RegWrite_i (MEM_WB_wb[1]), 
    .RSdata_o   (reg_rd1), 
    .RTdata_o   (reg_rd2) 
);

Control Control(
    .Op_i               (IF_ID_inst[6:0]),
    .RegDst_o           (),
    .ALUOp_o            (control[6:5]),
    .ALUSrc_o           (control[4]),
    .Branch_o           (control[7]),
    .MemRead_o          (control[3]),
    .MemWrite_o         (control[2]),
    .RegWrite_o         (control[1]),
    .MemToReg_o         (control[0]),
    .Immediate_format_o (control[9:8])
);

Hazard_Detection Hazard_Detection(
    .IF_ID_Write_o      (IF_ID_Write),
    .PC_Write_o         (PC_Write),
    .Bubble_Insertion_o (bubble),     
    .ID_Rs1_i           (IF_ID_inst[19:15]),               
    .ID_Rs2_i           (IF_ID_inst[24:20]),               
    .EX_MemRead_i       (ID_EX_hazard_memread),           
    .EX_Rd_i            (ID_EX_hazard)                 
);

Equality Equality(
    .data1_i    (reg_rd1),      // from Registers( RSdata_o)
    .data2_i    (reg_rd2),      // from Registers( RTdata_o)
    .data_o     (branch_pre)
);

and Branch ( branch, control[7], branch_pre);

Adder Adder_PC_ID (
    .data1_in   (IF_ID_inst_addr),
    .data2_in   (branch_length),
    .data_o     (PC_Branch)
);

Sign_Extend Sign_Extend(
    .data_i     (IF_ID_inst[31:0]),
    .ctrl_i     (control[9:8]),
    .data_o     (imm_o)
);

Shift_Left_1 Shift_Left_1 (
    .data_i     (imm_o),
    .data_o     (branch_length)
);

MUX7 mux_ID_EX(
    .data_o     (ID_EX_mux_i),      //  output to ID_EX
    .data1_i    (control[6:0]),
    .data2_i    (7'b0),
    .select_i   (bubble)            
);

/*
MUX5 MUX_RegDst(
    .data1_i    (),
    .data2_i    (),
    .select_i   (),
    .data_o     ()
);
*/

/////*****ID_EX*****/////

ID_EX ID_EX(
    .clk_i              (clk_i),
    .inst_i             (IF_ID_inst),
    .pc_i               (IF_ID_inst_addr),
    .rd1_i              (reg_rd1),          
    .rd2_i              (reg_rd2),          
    .sign_extend_i      (imm_o),            
    .mux_i              (ID_EX_mux_i),      
    .ALU_op_o           (ALUOp),            
    .WB_o               (ID_EX_WB),         
    .M_o                (ID_EX_MEM),        
    .mux_upper_o        (EX_rd1),           
    .mux_middle_o       (EX_rd2),           
    .ALU_src_o          (ALUSrc),           
    .forwarding_rs1_o   (forwarding_rs1),   
    .forwarding_rs2_o   (forwarding_rs2),   
    .inst_o             (EX_inst),                 
    .pc_o               (),                 
    .hazard_MEM_Read_o  (ID_EX_hazard_memread), 
    .hazard_rd_o        (ID_EX_hazard), 
    .mux_EX_MEM_Rd_o    (ID_EX_rd),
    .sign_extend_o      (EX_imm)
);

/////*****EX*****/////

MUX32_3 mux_ALU_RD1(
    .data_o     (ALUInput1),                // output to ALU_rd1    V
    .data1_i    (EX_rd1),                   //
    .data2_i    (mux_rightest_o),                         
    .data3_i    (DataMemory_addr),          // from EX_MEM
    .select_i   (mux_forwardA)              // from Forwarding
);

MUX32_3 mux_ALU_RD2(
    .data_o     (ALUInput2_pre),       
    .data1_i    (EX_rd2),   //
    .data2_i    (mux_rightest_o),             
    .data3_i    (DataMemory_addr),             // from EX_MEM
    .select_i   (mux_forwardB) // from Forwarding
);

MUX32 MUX_ALUSrc(
    .data1_i    (ALUInput2_pre),
    .data2_i    (EX_imm),
    .select_i   (ALUSrc),
    .data_o     (ALUInput2)
);

ALU ALU(
    .data1_i    (ALUInput1),
    .data2_i    (ALUInput2),
    .ALUCtrl_i  (ALUCtrl),
    .data_o     (ALUResult),
    .Zero_o     (Zero)
);

ALU_Control ALU_Control(
    .funct_i        ({EX_inst[31:25], EX_inst[14:12]}),		//
    //.funct14_12_i   (IF_ID_inst[14:12]),		
    .ALUOp_i        (ALUOp),	
    .ALUCtrl_o      (ALUCtrl)
);


Forwarding Forwarding(
    .mux_forwardA_o     (mux_forwardA), 
    .mux_forwardB_o     (mux_forwardB), 
    .ex_mem_control_i   (EX_MEM_wb[1]), 
    .mem_wb_control_i   (MEM_WB_wb[1]), 
    .ex_mem_rd_i        (EX_MEM_Rd),
    .mem_wb_rd_i        (MEM_WB_down_o),
    .id_ex_rs1_i        (forwarding_rs1),      
    .id_ex_rs2_i        (forwarding_rs2)       
);

/////*****EX_MEM*****/////

EX_MEM EX_MEM(	
    .clk_i          (clk_i),
    .WB_i           (ID_EX_WB), 
    .M_i            (ID_EX_MEM),		// from mux_EX_MEM_M
    .ALU_o_i        (ALUResult),
    .fw2_i          (ALUInput2_pre),
    .Rd_i           (ID_EX_rd),					
    .WB_o           (EX_MEM_wb), 
    .Memorywrite_o  (DataMemory_write_ctrl), 
    .Memoryread_o   (DataMemory_read_ctrl),
    .ALU_o_o        (DataMemory_addr),				
    .fw2_o          (DataMemory_writedata),
    .Rd_o           (EX_MEM_Rd)
);

/////*****MEM*****/////

Data_Memory Data_Memory(
    .clk_i(clk_i),
    .addr_d     (DataMemory_addr),  
    .write_data (DataMemory_writedata),
    .read_data  (read_data),
    .mem_read   (DataMemory_read_ctrl),
    .mem_write  (DataMemory_write_ctrl)
);

/////*****MEM_WB*****/////

MEM_WB MEM_WB(
	.clk_i         (clk_i),
	.WB_i          (EX_MEM_wb),
	.read_data_i   (read_data), 
	.ALU_o_i       (DataMemory_addr),
	.Rd_i          (EX_MEM_Rd),
	.WB_o          (MEM_WB_wb),
	.read_data_o   (WB_from_memory),	
	.ALU_o_o       (WB_from_ALU),	
	.Rd_o          (MEM_WB_down_o)
);





// MUX3 mux_EX_MEM_M(
//     .data_o     (),				// output to EX_MEM	V
//     .data1_i    (ID_EX.M_o),
//     .data2_i    (3'b0),
//     .select_i   ()				// from EX_flush
// );

// MUX2 mux_EX_MEM_WB(
//     .data_o     (),				// output to EX_MEM	V
//     .data1_i    (ID_EX.WB_o),
//     .data2_i    (2'b0),
//     .select_i   ()				// from EX_flush
// );


MUX32 rightest(
    .data_o     (mux_rightest_o),				
    .data1_i    (WB_from_ALU),
    .data2_i    (WB_from_memory),
    .select_i   (MEM_WB_wb[0])				

);

endmodule

