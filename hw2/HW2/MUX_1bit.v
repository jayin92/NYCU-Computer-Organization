module MUX_1bit(out, in0, in1, operation);
    output wire out;
    
    input wire in0;
    input wire in1;
    input wire operation;
    
    wire neg_op;
    
    not n0(neg_op, operation);
    
    wire y0, y1;
    
    and a0(y0, in0, neg_op);
    and a1(y1, in1, operation);
    
    or o1(out, y0, y1);
    
endmodule
