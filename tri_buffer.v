module tri_buffer(out, oe, in);

    input [31:0] in;
    input oe;
    output [31:0] out;

    assign out[31] = oe ? in[31] : 1'bz;
    assign out[30] = oe ? in[30] : 1'bz;
    assign out[29] = oe ? in[29] : 1'bz;
    assign out[28] = oe ? in[28] : 1'bz;
    assign out[27] = oe ? in[27] : 1'bz;
    assign out[26] = oe ? in[26] : 1'bz;
    assign out[25] = oe ? in[25] : 1'bz;
    assign out[24] = oe ? in[24] : 1'bz;
    assign out[23] = oe ? in[23] : 1'bz;
    assign out[22] = oe ? in[22] : 1'bz;
    assign out[21] = oe ? in[21] : 1'bz;
    assign out[20] = oe ? in[20] : 1'bz;
    assign out[19] = oe ? in[19] : 1'bz;
    assign out[18] = oe ? in[18] : 1'bz;
    assign out[17] = oe ? in[17] : 1'bz;
    assign out[16] = oe ? in[16] : 1'bz;
    assign out[15] = oe ? in[15] : 1'bz;
    assign out[14] = oe ? in[14] : 1'bz;
    assign out[13] = oe ? in[13] : 1'bz;
    assign out[12] = oe ? in[12] : 1'bz;
    assign out[11] = oe ? in[11] : 1'bz;
    assign out[10] = oe ? in[10] : 1'bz;
    assign out[9] = oe ? in[9] : 1'bz;
    assign out[8] = oe ? in[8] : 1'bz;
    assign out[7] = oe ? in[7] : 1'bz;
    assign out[6] = oe ? in[6] : 1'bz;
    assign out[5] = oe ? in[5] : 1'bz;
    assign out[4] = oe ? in[4] : 1'bz;
    assign out[3] = oe ? in[3] : 1'bz;
    assign out[2] = oe ? in[2] : 1'bz;
    assign out[1] = oe ? in[1] : 1'bz;
    assign out[0] = oe ? in[0] : 1'bz;

endmodule