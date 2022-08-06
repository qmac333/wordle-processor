module sll(result, data_operand, shamt);

    input [31:0] data_operand;
    input [4:0] shamt;
    output [31:0] result;
    wire [31:0] sixteen, eight, four, two, one, mux1, mux2, mux3, mux4;

    shiftleft_sixteen leftsixteen(sixteen, data_operand);
    mux_2 sixteenmux(mux1, shamt[4], data_operand, sixteen);
    shiftleft_eight lefteight(eight, mux1);
    mux_2 eightmux(mux2, shamt[3], mux1, eight);
    shiftleft_four leftfour(four, mux2);
    mux_2 fourmux(mux3, shamt[2], mux2, four);
    shiftleft_two lefttwo(two, mux3);
    mux_2 twomux(mux4, shamt[1], mux3, two);
    shiftleft_one leftone(one, mux4);
    mux_2 onemux(result, shamt[0], mux4, one);

endmodule