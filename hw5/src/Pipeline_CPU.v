module Pipeline_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
// IF
wire [32-1:0] instr, PC_i, PC_o, PC_add1_IF;
// ID
wire RegWrite_ID, ALUSrc_ID, Jump_ID, Branch_ID, BranchType_ID, MemWrite_ID, MemRead_ID;
wire [2-1:0] RegDst_ID, MemtoReg_ID;
wire [3-1:0] ALUOp_ID;
wire [32-1:0] PC_add1_ID, instr_ID, ReadData1_ID, ReadData2_ID, sign_ID;
wire enable_ID;
// EX
wire [3-1:0] WB_EX;
wire [3-1:0] MEM_EX;

wire [2-1:0] RegDst_EX;
wire [3-1:0] ALUOp_EX;
wire ALUSrc_EX, zero_EX, overflow_EX;

wire [32-1:0] PC_add1_EX, ReadData1_EX, ReadData2_EX, sign_EX;
wire [5-1:0] instr_1_addr_EX, instr_2_addr_EX;

wire [4-1:0] ALU_operation;
wire [2-1:0] FURslt;

wire [32-1:0] ALUinput2;

wire [32-1:0] ALUResult_EX, PC_t_EX;

wire [5-1:0] WriteReg_addr_EX;
wire enable_EX;


// MEM
wire [3-1:0] WB_MEM;
wire [32-1:0] PC_t_MEM, ALUResult_MEM, ReadData2_MEM, DM_ReadData_MEM;
wire [5-1:0] WriteReg_addr_MEM;
wire PCSrc_MEM, zero_MEM;
wire Branch_MEM, MemRead_MEM, MemWrite_MEM;
wire enable_MEM;
// WB
wire RegWrite_WB;
wire [2-1:0] MemtoReg_WB;
wire [32-1:0] WriteData_WB, DM_ReadData_WB, ALUResult_WB;
wire [5-1:0] WriteReg_addr_WB;
wire enable_WB;
//modules
/*your code here*/

Program_Counter PC(
    .clk_i(clk_i),      
    .rst_n(rst_n),
    .pc_in_i(PC_i),
    .pc_out_o(PC_o)
);

Adder Adder1(
    .src1_i(PC_o),
    .src2_i(32'd4),
    .sum_o(PC_add1_IF)
);

Mux2to1 #(.size(32)) PC_IN (
    .data0_i(PC_add1_IF),
    .data1_i(PC_t_MEM),
    .select_i(PCSrc_MEM),
    .data_o(PC_i)
);

Instr_Memory IM(
    .pc_addr_i(PC_o),  
    .instr_o(instr)    
);

Reg_Pipe #(.size(32+32+1)) IFID(
    .clk_i(clk_i),
    .rst_n(rst_n),
    .data_i({PC_add1_IF, instr, (instr == 0 ? 1'b0 : 1'b1)}), 
    .data_o({PC_add1_ID, instr_ID, enable_ID})
);
// Mux2to1 #(.size(5)) Mux_Write_Reg(
//     .data0_i(instr[20:16]),
//     .data1_i(instr[15:11]),
//     .select_i(RegDst[0]),
//     .data_o(WriteReg_addr)
// );

Reg_File RF(
    .clk_i(clk_i),      
    .rst_n(rst_n) ,     
    .RSaddr_i(instr_ID[25:21]) ,  
    .RTaddr_i(instr_ID[20:16]) ,  
    .Wrtaddr_i(WriteReg_addr_WB) ,  
    .Wrtdata_i(WriteData_WB), 
    .RegWrite_i(RegWrite_WB & enable_WB),
    .RSdata_o(ReadData1_ID),  
    .RTdata_o(ReadData2_ID)   
);

Decoder Decoder(
    .instr_op_i(instr_ID[31:26]), 
    .RegWrite_o(RegWrite_ID), 
    .ALUOp_o(ALUOp_ID),
    .ALUSrc_o(ALUSrc_ID),
    .RegDst_o(RegDst_ID),
    .Jump_o(Jump_ID),
    .Branch_o(Branch_ID),
    .BranchType_o(BranchType_ID),
    .MemWrite_o(MemWrite_ID), 
    .MemRead_o(MemRead_ID), 
    .MemtoReg_o(MemtoReg_ID)
);

Sign_Extend SE(
    .data_i(instr_ID[15:0]),
    .data_o(sign_ID)
);


Reg_Pipe #(.size(1+2+1+1+1+2+3+1+32+32+32+32+5+5+1)) IDEX(
    .clk_i(clk_i),      
    .rst_n(rst_n),
    .data_i({RegWrite_ID, MemtoReg_ID, Branch_ID, MemRead_ID, MemWrite_ID, RegDst_ID, ALUOp_ID, ALUSrc_ID, PC_add1_ID, ReadData1_ID, ReadData2_ID, sign_ID, instr_ID[20:16], instr_ID[15:11], enable_ID}),
    .data_o({WB_EX, MEM_EX, RegDst_EX, ALUOp_EX, ALUSrc_EX, PC_add1_EX, ReadData1_EX, ReadData2_EX, sign_EX, instr_1_addr_EX, instr_2_addr_EX, enable_EX})
);

ALU_Ctrl AC(
    .funct_i(sign_EX[5:0]),
    .ALUOp_i(ALUOp_EX),   
    .ALU_operation_o(ALU_operation),
    .FURslt_o(FURslt)
);

Adder Adder2(
    .src1_i(PC_add1_EX),
    .src2_i({sign_EX[29:0], 2'b0}),
    .sum_o(PC_t_EX)
);
	
ALU ALU(
    .aluSrc1(ReadData1_EX),
    .aluSrc2(ALUinput2),
    .ALU_operation_i(ALU_operation),
    .result(ALUResult_EX),
    .zero(zero_EX),
    .overflow(overflow_EX)
);

Mux2to1 #(.size(32)) ALU_src2Src(
    .data0_i(ReadData2_EX),
    .data1_i(sign_EX),
    .select_i(ALUSrc_EX),
    .data_o(ALUinput2)
);	

Mux2to1 #(.size(5)) RegDstMux (
    .data0_i(instr_1_addr_EX),
    .data1_i(instr_2_addr_EX),
    .select_i(RegDst_EX[0]),
    .data_o(WriteReg_addr_EX)
);

Reg_Pipe #(.size(3+3+32+1+32+32+5+1)) EXMEM (
    .clk_i(clk_i),      
    .rst_n(rst_n),
    .data_i({WB_EX, MEM_EX, PC_t_EX, zero_EX, ALUResult_EX, ReadData2_EX, WriteReg_addr_EX, enable_EX}),
    .data_o({WB_MEM, Branch_MEM, MemRead_MEM, MemWrite_MEM, PC_t_MEM, zero_MEM, ALUResult_MEM, ReadData2_MEM, WriteReg_addr_MEM, enable_MEM})
);

assign PCSrc_MEM = (zero_MEM & Branch_MEM);

Data_Memory DM(
    .clk_i(clk_i),
    .addr_i(ALUResult_MEM),
    .data_i(ReadData2_MEM),
    .MemRead_i(MemRead_MEM),
    .MemWrite_i(MemWrite_MEM & enable_MEM),
    .data_o(DM_ReadData_MEM)
);

Reg_Pipe #(.size(3+32+32+5+1)) MEMWB (
    .clk_i(clk_i),      
    .rst_n(rst_n),
    .data_i({WB_MEM, DM_ReadData_MEM, ALUResult_MEM, WriteReg_addr_MEM, enable_MEM}),
    .data_o({RegWrite_WB, MemtoReg_WB, DM_ReadData_WB, ALUResult_WB, WriteReg_addr_WB, enable_WB})
);



Mux2to1 #(.size(32)) DM2RF (
    .data0_i(DM_ReadData_WB),
    .data1_i(ALUResult_WB),
    .select_i(MemtoReg_WB[0]),
    .data_o(WriteData_WB)
);

endmodule



