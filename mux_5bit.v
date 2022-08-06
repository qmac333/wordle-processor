module mux_5bit(out, select, in0, in1);
    input select;
    input [4:0] in0, in1;
    output [4:0] out;
    assign out = select ? in1 : in0;
endmodule