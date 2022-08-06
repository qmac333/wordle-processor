module decoder5to32(out, addr);

    input [4:0] addr; 
    output [31:0] out;
    wire not1, not2, not3, not4, not5;

    not n1(not5, addr[0]);
    not n2(not4, addr[1]);
    not n3(not3, addr[2]);
    not n4(not2, addr[3]);
    not n5(not1, addr[4]);

    and and1(out[0], not1, not2, not3, not4, not5);
    and and2(out[1], not1, not2, not3, not4, addr[0]);
    and and3(out[2], not1, not2, not3, addr[1], not5);
    and and4(out[3], not1, not2, not3, addr[1], addr[0]);
    and and5(out[4], not1, not2, addr[2], not4, not5);
    and and6(out[5], not1, not2, addr[2], not4, addr[0]);
    and and7(out[6], not1, not2, addr[2], addr[1], not5);
    and and8(out[7], not1, not2, addr[2], addr[1], addr[0]);
    and and9(out[8], not1, addr[3], not3, not4, not5);
    and and10(out[9], not1, addr[3], not3, not4, addr[0]);
    and and11(out[10], not1, addr[3], not3, addr[1], not5);
    and and12(out[11], not1, addr[3], not3, addr[1], addr[0]);
    and and13(out[12], not1, addr[3], addr[2], not4, not5);
    and and14(out[13], not1, addr[3], addr[2], not4, addr[0]);
    and and15(out[14], not1, addr[3], addr[2], addr[1], not5);
    and and16(out[15], not1, addr[3], addr[2], addr[1], addr[0]);
    and and17(out[16], addr[4], not2, not3, not4, not5);
    and and18(out[17], addr[4], not2, not3, not4, addr[0]);
    and and19(out[18], addr[4], not2, not3, addr[1], not5);
    and and20(out[19], addr[4], not2, not3, addr[1], addr[0]);
    and and21(out[20], addr[4], not2, addr[2], not4, not5);
    and and22(out[21], addr[4], not2, addr[2], not4, addr[0]);
    and and23(out[22], addr[4], not2, addr[2], addr[1], not5);
    and and24(out[23], addr[4], not2, addr[2], addr[1], addr[0]);
    and and25(out[24], addr[4], addr[3], not3, not4, not5);
    and and26(out[25], addr[4], addr[3], not3, not4, addr[0]);
    and and27(out[26], addr[4], addr[3], not3, addr[1], not5);
    and and28(out[27], addr[4], addr[3], not3, addr[1], addr[0]);
    and and29(out[28], addr[4], addr[3], addr[2], not4, not5);
    and and30(out[29], addr[4], addr[3], addr[2], not4, addr[0]);
    and and31(out[30], addr[4], addr[3], addr[2], addr[1], not5);
    and and32(out[31], addr[4], addr[3], addr[2], addr[1], addr[0]);

endmodule