module Simple_Single_CPU( clk_i, rst_n );

    //I/O port
    input         clk_i;
    input         rst_n;
    
    //Internal Signles
    wire [31:0] pc_out;
    wire [31:0] pc_in;
    wire [31:0] instr;
    wire RegDst;
    wire RegWrite;
    wire [2:0] ALUOp;
    wire ALUSrc;
    wire [4:0] write_reg;
    wire [31:0] write_data;
    wire [31:0] rs_data;
    wire [31:0] rt_data;
    wire [3:0] ALU_operation;
    wire [1:0] FURslt;
    wire [31:0] sign_ext;
    wire [31:0] zero_fill;
    wire [31:0] ALU_in1;
    wire zero;
    wire overflow;
    wire [31:0] result;
    wire [31:0] shift_res;
    
    //modules
    Program_Counter PC(
            .clk_i(clk_i),      
            .rst_n(rst_n),
            .pc_in_i(pc_in),
            .pc_out_o(pc_out)
            );
        
    Adder Adder1(
            .src1_i(pc_out),
            .src2_i(32'd4),
            .sum_o(pc_in)    
            );
        
    Instr_Memory IM(
            .pc_addr_i(pc_out),  
            .instr_o(instr)    
            );
    
    Mux2to1 #(.size(5)) Mux_Write_Reg(
            .data0_i(instr[20:16]),
            .data1_i(instr[15:11]),
            .select_i(RegDst),
            .data_o(write_reg)
            );	
            
    Reg_File RF(
            .clk_i(clk_i),      
            .rst_n(rst_n) ,     
            .RSaddr_i(instr[25:21]) ,  
            .RTaddr_i(instr[20:16]) ,  
            .RDaddr_i(write_reg) ,  
            .RDdata_i(write_data), 
            .RegWrite_i(RegWrite),
            .RSdata_o(rs_data) ,  
            .RTdata_o(rt_data)   
            );
        
    Decoder Decoder(
            .instr_op_i(instr[31:26]), 
            .RegWrite_o(RegWrite), 
            .ALUOp_o(ALUOp),   
            .ALUSrc_o(ALUSrc),
            .RegDst_o(RegDst)   
            );
    
    ALU_Ctrl AC(
            .funct_i(instr[5:0]),   
            .ALUOp_i(ALUOp),   
            .ALU_operation_o(ALU_operation),
            .FURslt_o(FURslt)
            );
        
    Sign_Extend SE(
            .data_i(instr[15:0]),
            .data_o(sign_ext)
            );
    
    Zero_Filled ZF(
            .data_i(instr[15:0]),
            .data_o(zero_fill)
            );
            
    Mux2to1 #(.size(32)) ALU_src2Src(
            .data0_i(rt_data),
            .data1_i(sign_ext),
            .select_i(ALUSrc),
            .data_o(ALU_in1)
            );	
            
    ALU ALU(
            .aluSrc1(rs_data),
            .aluSrc2(ALU_in1),
            .ALU_operation_i(ALU_operation),
            .result(result),
            .zero(zero),
            .overflow(overflow)
            );
            
    Shifter shifter( 
            .result(shift_res), 
            .leftRight(ALU_operation[3]),
            .shamt(instr[10:6]),
            .sftSrc(ALU_in1) 
            );
            
    Mux3to1 #(.size(32)) RDdata_Source(
            .data0_i(result),
            .data1_i(shift_res),
            .data2_i(zero_fill),
            .select_i(FURslt),
            .data_o(write_data)
            );			

endmodule



