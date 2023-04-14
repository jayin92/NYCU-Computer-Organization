module MUX_2bit(out, in0, in1, in2, in3, operation[1:0]);
    output wire out;
    
    input wire in0;
    input wire in1;
    input wire in2;
    input wire in3;
    input wire[1:0] operation;
    
    wire op0, op1, neg_op0, neg_op1;
    
    assign op0 = operation[0];
    assign op1 = operation[1];
    not n0(neg_op0, op0);
    not n1(neg_op1, op1);
    
    wire y0, y1, y2, y3;
    
    and a0(y0, in0, neg_op0, neg_op1);
    and a1(y1, in1, op0, neg_op1);
    and a2(y2, in2, neg_op0, op1);
    and a3(y3, in3, op0, op1);
    
    or o1(out, y0, y1, y2, y3);
    
endmodule
