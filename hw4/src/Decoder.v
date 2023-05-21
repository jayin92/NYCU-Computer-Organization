module Decoder( instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o, Jump_o, Branch_o, BranchType_o, MemWrite_o, MemRead_o, MemtoReg_o);
     
//I/O ports
input	[6-1:0] instr_op_i;

output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
output	[2-1:0]	RegDst_o, MemtoReg_o;
output			Jump_o, Branch_o, BranchType_o, MemWrite_o, MemRead_o;
 
//Internal Signals
wire	[3-1:0] ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire	[2-1:0]	RegDst_o, MemtoReg_o;
wire			Jump_o, Branch_o, BranchType_o, MemWrite_o, MemRead_o;
//Main function
/*your code here*/

assign {RegWrite_o, ALUOp_o, ALUSrc_o, RegDst_o} = 
             (instr_op_i == 6'b000000) ? {1'b1, 3'b010, 1'b0, 2'b01} : // R-type
             (instr_op_i == 6'b001000) ? {1'b1, 3'b011, 1'b1, 2'b00} : // addi
             (instr_op_i == 6'b100001) ? {1'b1, 3'b000, 1'b1, 2'b00} : // lw
             (instr_op_i == 6'b100011) ? {1'b0, 3'b000, 1'b1, 2'b00} : // sw
             (instr_op_i == 6'b111011) ? {1'b0, 3'b001, 1'b0, 2'b00} : // beq
             (instr_op_i == 6'b100101) ? {1'b0, 3'b110, 1'b0, 2'b00} : // bne
             (instr_op_i == 6'b100010) ? {1'b0, 3'b000, 1'b0, 2'b00} : // jump
             0 ;
assign {MemtoReg_o, Jump_o, Branch_o, BranchType_o, MemWrite_o, MemRead_o} = 
             (instr_op_i == 6'b000000) ? {2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0} : // R
             (instr_op_i == 6'b001000) ? {2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0} : // addi
             (instr_op_i == 6'b100001) ? {2'b01, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1} : // lw
             (instr_op_i == 6'b100011) ? {2'b00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0} : // sw
             (instr_op_i == 6'b111011) ? {2'b00, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0} : // beq
             (instr_op_i == 6'b100101) ? {2'b00, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0} : // bne
             (instr_op_i == 6'b100010) ? {2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0} : // jump
             0 ;
endmodule
   