module eightbit_adder(sum, g, p, data_operandA, data_operandB, carryin);

    input [7:0] data_operandA, data_operandB, g, p;
    input carryin;
    output [7:0] sum;
    wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, 
         w21, w22, w23, w24, w25, w26, w27, w28;
    output [7:0] c;

    xor sum1(sum[0], data_operandA[0], data_operandB[0], carryin);
    and and1(w1, p[0], carryin);
    or or1(c[1], g[0], w1);

    xor sum2(sum[1], data_operandA[1], data_operandB[1], c[1]);
    and and2(w2, p[1], p[0], carryin);
    and and3(w3, p[1], g[0]);
    or or2(c[2], g[1], w3, w2);

    xor sum3(sum[2], data_operandA[2], data_operandB[2], c[2]);
    and and4(w4, p[2], p[1], p[0], carryin);
    and and5(w5, p[2], p[1], g[0]);
    and and6(w6, p[2], g[1]);
    or or3(c[3], g[2], w6, w5, w4);

    xor sum4(sum[3], data_operandA[3], data_operandB[3], c[3]);
    and and7(w7, p[3], p[2], p[1], p[0], carryin);
    and and8(w8, p[3], p[2], p[1], g[0]);
    and and9(w9, p[3], p[2], g[1]);
    and and10(w10, p[3], g[2]);
    or or4(c[4], g[3], w10, w9, w8, w7);

    xor sum5(sum[4], data_operandA[4], data_operandB[4], c[4]);
    and and11(w11, p[4], p[3], p[2], p[1], p[0], carryin);
    and and12(w12, p[4], p[3], p[2], p[1], g[0]);
    and and13(w13, p[4], p[3], p[2], g[1]);
    and and14(w14, p[4], p[3], g[2]);
    and and15(w15, p[4], g[3]);
    or or5(c[5], g[4], w15, w14, w13, w12, w11);

    xor sum6(sum[5], data_operandA[5], data_operandB[5], c[5]);
    and and16(w16, p[5], p[4], p[3], p[2], p[1], p[0], carryin);
    and and17(w17, p[5], p[4], p[3], p[2], p[1], g[0]);
    and and18(w18, p[5], p[4], p[3], p[2], g[1]);
    and and19(w19, p[5], p[4], p[3], g[2]);
    and and20(w20, p[5], p[4], g[3]);
    and and21(w21, p[5], g[4]);
    or or6(c[6], g[5], w21, w20, w19, w18, w17, w16);

    xor sum7(sum[6], data_operandA[6], data_operandB[6], c[6]);
    and and22(w22, p[6], p[5], p[4], p[3], p[2], p[1], p[0], carryin);
    and and23(w23, p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
    and and24(w24, p[6], p[5], p[4], p[3], p[2], g[1]);
    and and25(w25, p[6], p[5], p[4], p[3], g[2]);
    and and26(w26, p[6], p[5], p[4], g[3]);
    and and27(w27, p[6], p[5], g[4]);
    and and28(w28, p[6], g[5]);
    or or7(c[7], g[6], w28, w27, w26, w25, w24, w23, w22);

    xor sum8(sum[7], data_operandA[7], data_operandB[7], c[7]);

endmodule