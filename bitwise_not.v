module bitwise_not(notB, data_operandB);

    input [31:0] data_operandB;
    output [31:0] notB;

    not not1(notB[0], data_operandB[0]);
    not not2(notB[1], data_operandB[1]);
    not not3(notB[2], data_operandB[2]);
    not not4(notB[3], data_operandB[3]);
    not not5(notB[4], data_operandB[4]);
    not not6(notB[5], data_operandB[5]);
    not not7(notB[6], data_operandB[6]);
    not not8(notB[7], data_operandB[7]);
    not not9(notB[8], data_operandB[8]);
    not not10(notB[9], data_operandB[9]);
    not not11(notB[10], data_operandB[10]);
    not not12(notB[11], data_operandB[11]);
    not not13(notB[12], data_operandB[12]);
    not not14(notB[13], data_operandB[13]);
    not not15(notB[14], data_operandB[14]);
    not not16(notB[15], data_operandB[15]);
    not not17(notB[16], data_operandB[16]);
    not not18(notB[17], data_operandB[17]);
    not not19(notB[18], data_operandB[18]);
    not not20(notB[19], data_operandB[19]);
    not not21(notB[20], data_operandB[20]);
    not not22(notB[21], data_operandB[21]);
    not not23(notB[22], data_operandB[22]);
    not not24(notB[23], data_operandB[23]);
    not not25(notB[24], data_operandB[24]);
    not not26(notB[25], data_operandB[25]);
    not not27(notB[26], data_operandB[26]);
    not not28(notB[27], data_operandB[27]);
    not not29(notB[28], data_operandB[28]);
    not not30(notB[29], data_operandB[29]);
    not not31(notB[30], data_operandB[30]);
    not not32(notB[31], data_operandB[31]);

endmodule