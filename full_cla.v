module full_cla(sum, carryout, data_operandA, data_operandB, carryin, p, g);

    input [31:0] p, g, data_operandA, data_operandB;
    input carryin;
    output [31:0] sum;
    output carryout;

    wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, 
         w21, w22, w23, w24, w25, w26, w27, w28, w29, w30, w31, w32, w33, w34, w35, w36, w37, w38;
    wire p0, p1, p2, p3, g0, g1, g2, g3;
    wire c8, c16, c24;

    and and1(p0, p[7], p[6], p[5], p[4], p[3], p[2], p[1], p[0]);
    and and2(p1, p[15], p[14], p[13], p[12], p[11], p[10], p[9], p[8]);
    and and3(p2, p[23], p[22], p[21], p[20], p[19], p[18], p[17], p[16]);
    and and4(p3, p[31], p[30], p[29], p[28], p[27], p[26], p[25], p[24]);

    and and5(w1, p[7], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
    and and6(w2, p[7], p[6], p[5], p[4], p[3], p[2], g[1]);
    and and7(w3, p[7], p[6], p[5], p[4], p[3], g[2]);
    and and8(w4, p[7], p[6], p[5], p[4], g[3]);
    and and9(w5, p[7], p[6], p[5], g[4]);
    and and10(w6, p[7], p[6], g[5]);
    and and11(w7, p[7], g[6]);
    or or1(g0, g[7], w1, w2, w3, w4, w5, w6, w7);

    and and12(w8, p[15], p[14], p[13], p[12], p[11], p[10], p[9], g[8]);
    and and13(w9, p[15], p[14], p[13], p[12], p[11], p[10], g[9]);
    and and14(w10, p[15], p[14], p[13], p[12], p[11], g[10]);
    and and15(w11, p[15], p[14], p[13], p[12], g[11]);
    and and16(w12, p[15], p[14], p[13], g[12]);
    and and17(w13, p[15], p[14], g[13]);
    and and18(w14, p[15], g[14]);
    or or2(g1, g[15], w8, w9, w10, w11, w12, w13, w14);

    and and42(w15, p[23], p[22], p[21], p[20], p[19], p[18], p[17], g[16]);
    and and19(w16, p[23], p[22], p[21], p[20], p[19], p[18], g[17]);
    and and20(w17, p[23], p[22], p[21], p[20], p[19], g[18]);
    and and21(w18, p[23], p[22], p[21], p[20], g[19]);
    and and22(w19, p[23], p[22], p[21], g[20]);
    and and23(w20, p[23], p[22], g[21]);
    and and24(w21, p[23], g[22]);
    or or3(g2, g[23], w15, w16, w17, w18, w19, w20, w21);

    and and25(w22, p[31], p[30], p[29], p[28], p[27], p[26], p[25], g[24]);
    and and26(w23, p[31], p[30], p[29], p[28], p[27], p[26], g[25]);
    and and27(w24, p[31], p[30], p[29], p[28], p[27], g[26]);
    and and28(w25, p[31], p[30], p[29], p[28], g[27]);
    and and29(w26, p[31], p[30], p[29], g[28]);
    and and30(w27, p[31], p[30], g[29]);
    and and31(w28, p[31], g[30]);
    or or4(g3, g[31], w22, w23, w24, w25, w26, w27, w28);

    and and32(w29, p0, carryin);
    or or5(c8, g0, w29);

    and and33(w30, p1, p0, carryin);
    and and34(w31, p1, g0);
    or or6(c16, w31, w30, g1);

    and and35(w32, p2, p1, p0, carryin);
    and and36(w33, p2, p1, g0);
    and and37(w34, p2, g1);
    or or7(c24, g2, w34, w33, w32);

    and and38(w35, p3, p2, p1, p0, carryin);
    and and39(w36, p3, p2, p1, g0);
    and and40(w37, p3, p2, g1);
    and and41(w38, p3, g2);
    or or8(carryout, g3, w38, w37, w36, w35);

    eightbit_adder first(sum[7:0], g[7:0], p[7:0], data_operandA[7:0], data_operandB[7:0], carryin);
    eightbit_adder second(sum[15:8], g[15:8], p[15:8], data_operandA[15:8], data_operandB[15:8], c8);
    eightbit_adder third(sum[23:16], g[23:16], p[23:16], data_operandA[23:16], data_operandB[23:16], c16);
    eightbit_adder fourth(sum[31:24], g[31:24], p[31:24], data_operandA[31:24], data_operandB[31:24], c24);

endmodule