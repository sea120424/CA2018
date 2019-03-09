module Hazard_Detection
(
    IF_ID_Write_o,          //For stoping the next instruction to stored into the ID register. When hazard detected, output 0. Otherwise, output 1.
    PC_Write_o,             //For stoping the program counter from counting down. When hazard detected, output 0. Otherwise, output 1.
    Bubble_Insertion_o,     //For inserting the Bubble into the ID/EX register. When hazard detected, output 1. Otherwise, output 0.
    ID_Rs1_i,               //Source Register 1 for the ID operation.
    ID_Rs2_i,               //Source Register 2 for the ID operation.
    EX_MemRead_i,           //If the EX operation read data from memory.
    EX_Rd_i                 //The destination register for the ID/EX operation.
);

input           EX_MemRead_i;
input   [4:0]   ID_Rs1_i, ID_Rs2_i, EX_Rd_i;
output          IF_ID_Write_o, PC_Write_o, Bubble_Insertion_o;

reg             IF_ID_Write_o, PC_Write_o, Bubble_Insertion_o;


always @( EX_MemRead_i or ID_Rs1_i or ID_Rs2_i or EX_Rd_i ) begin
    
    IF_ID_Write_o <= 1'b1;
    PC_Write_o <= 1'b1;
    Bubble_Insertion_o <= 1'b0;
    
    //when hazard detected:
    if ( (EX_MemRead_i == 1'b1) && ((ID_Rs1_i == EX_Rd_i) || (ID_Rs2_i == EX_Rd_i)) ) begin
        IF_ID_Write_o <= 1'b0;
        PC_Write_o <= 1'b0;
        Bubble_Insertion_o <= 1'b1;
    end

end

endmodule
 