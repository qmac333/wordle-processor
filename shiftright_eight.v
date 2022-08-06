module shiftright_eight(result, data_operand);

    input [31:0] data_operand;
    output [31:0] result;

    assign result[0] = data_operand[8];
    assign result[1] = data_operand[9];
    assign result[2] = data_operand[10];
    assign result[3] = data_operand[11];
    assign result[4] = data_operand[12];
    assign result[5] = data_operand[13];
    assign result[6] = data_operand[14];
    assign result[7] = data_operand[15];
    assign result[8] = data_operand[16];
    assign result[9] = data_operand[17];
    assign result[10] = data_operand[18];
    assign result[11] = data_operand[19];
    assign result[12] = data_operand[20];
    assign result[13] = data_operand[21];
    assign result[14] = data_operand[22];
    assign result[15] = data_operand[23];
    assign result[16] = data_operand[24];
    assign result[17] = data_operand[25];
    assign result[18] = data_operand[26];
    assign result[19] = data_operand[27];
    assign result[20] = data_operand[28];
    assign result[21] = data_operand[29];
    assign result[22] = data_operand[30];
    assign result[23] = data_operand[31];
    assign result[24] = data_operand[31];
    assign result[25] = data_operand[31];
    assign result[26] = data_operand[31];
    assign result[27] = data_operand[31];
    assign result[28] = data_operand[31];
    assign result[29] = data_operand[31];
    assign result[30] = data_operand[31];
    assign result[31] = data_operand[31];

endmodule