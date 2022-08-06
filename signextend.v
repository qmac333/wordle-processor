module signextend(extended, input17bits);

    input [16:0] input17bits;
    output [31:0] extended;

    assign extended[16:0] = input17bits;
    assign extended[17] = input17bits[16];
    assign extended[18] = input17bits[16];
    assign extended[19] = input17bits[16];
    assign extended[20] = input17bits[16];
    assign extended[21] = input17bits[16];
    assign extended[22] = input17bits[16];
    assign extended[23] = input17bits[16];
    assign extended[24] = input17bits[16];
    assign extended[25] = input17bits[16];
    assign extended[26] = input17bits[16];
    assign extended[27] = input17bits[16];
    assign extended[28] = input17bits[16];
    assign extended[29] = input17bits[16];
    assign extended[30] = input17bits[16];
    assign extended[31] = input17bits[16];

endmodule