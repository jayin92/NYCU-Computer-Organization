module ALU( aluSrc1, aluSrc2, ALU_operation_i, result, zero, overflow );

    //I/O ports 
    input	[32-1:0] aluSrc1;
    input	[32-1:0] aluSrc2;
    input	 [4-1:0] ALU_operation_i;
    
    output	[32-1:0] result;
    output			 zero;
    output			 overflow;
    
    //Internal Signals
    wire			 zero;
    wire			 overflow;
    wire	[32-1:0] result;
    
    wire invertA;
    wire invertB;
    wire [1:0] operation;
    assign invertA = ALU_operation_i[3];
    assign invertB = ALU_operation_i[2];
    assign operation = ALU_operation_i[1:0];
    
    //Main function
    /*your code here*/
    wire[31:0] carries;
    wire alu31_set;
    wire dummy;
    
    ALU_1bit alu0(
        result[0],
        carries[0],
        dummy,
        aluSrc1[0],
        aluSrc2[0],
        invertA,
        invertB,
        operation,
        invertB,
        alu31_set
    );        
    
    genvar i;
    generate
      for(i=1;i<=30;i=i+1) begin: alu_inst
        ALU_1bit alu(
            result[i],
            carries[i],
            dummy,
            aluSrc1[i],
            aluSrc2[i],
            invertA,
            invertB,
            operation,
            carries[i-1],
            1'b0
        );
       end
    endgenerate
    
    ALU_1bit alu31(
        result[31],
        carries[31],
        alu31_set,
        aluSrc1[31],
        aluSrc2[31],
        invertA,
        invertB,
        operation,
        carries[30],
        1'b0
    );
    
    assign overflow = (operation[1] == 1'b1 ? carries[30] ^ carries[31] : 1'b0);
    assign zero = ~(|result[31:0]);



endmodule
