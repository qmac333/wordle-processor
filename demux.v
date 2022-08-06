module mux_2_32bit(out, select, in0, in1);
    input select;
    input [12:0] in0, in1;
    output [12:0] out;
    assign out = select ? in1 : in0;
endmodule


module mux_4_32bit(out, select, in0, in1, in2, in3);
    input [1:0] select;
    input [12:0] in0, in1, in2, in3;
    output[12:0] out;
    wire [12:0] w1, w2;
    mux_2_32bit first_top(w1, select[0], in0, in1);
    mux_2_32bit first_bottom(w2, select[0], in2, in3);
    mux_2_32bit second(out, select[1], w1, w2);
endmodule 



module mux_8_32bit(out, select, in0, in1, in2, in3, in4, in5, in6, in7);
    input [2:0] select;
    input [12:0] in0, in1, in2, in3, in4, in5, in6, in7;
    output[12:0] out;
    wire[12:0] w1, w2;
    mux_4_32bit top(w1, select[1:0], in0, in1, in2, in3);
    mux_4_32bit bottom(w2, select[1:0], in4, in5, in6, in7);
    mux_2_32bit last(out, select[2], w1, w2);
endmodule


module mux_32_32bit(out, select, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31);

    input [4:0] select;
    input [12:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31;
    output [12:0] out;
    wire [12:0] w1, w2, w3, w4;

    mux_8_32bit first(w1, select[2:0], in0, in1, in2, in3, in4, in5, in6, in7); 
    mux_8_32bit second(w2, select[2:0], in8, in9, in10, in11, in12, in13, in14, in15);
    mux_8_32bit third(w3, select[2:0], in16, in17, in18, in19, in20, in21, in22, in23);
    mux_8_32bit fourth(w4, select[2:0], in24, in25, in26, in27, in28, in29, in30, in31);
    mux_4_32bit final_mux(out, select[4:3], w1, w2, w3, w4);

endmodule 