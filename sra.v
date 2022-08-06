module sra(result, data_operand, shamt);

    input [31:0] data_operand;
    input [4:0] shamt;
    output [31:0] result;
    wire [31:0] sixteen, eight, four, two, one, mux1, mux2, mux3, mux4;

    shiftright_sixteen rightsixteen(sixteen, data_operand);
    mux_2 sixteenmux(mux1, shamt[4], data_operand, sixteen);
    shiftright_eight righteight(eight, mux1);
    mux_2 eightmux(mux2, shamt[3], mux1, eight);
    shiftright_four rightfour(four, mux2);
    mux_2 fourmux(mux3, shamt[2], mux2, four);
    shiftright_two righttwo(two, mux3);
    mux_2 twomux(mux4, shamt[1], mux3, two);
    shiftright_one rightone(one, mux4);
    mux_2 onemux(result, shamt[0], mux4, one);

endmodule