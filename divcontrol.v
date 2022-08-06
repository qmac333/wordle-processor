module divcontrol(currentvalue, signA, aqReg, divisor);

    input [63:0] aqReg;
    input [31:0] divisor;
    input signA;
    output [63:0] currentvalue; 

    wire [63:0] shiftedquot, almostthere;
    wire [31:0] aminusm, aplusm, pee, gee, notdivisor, negdivisor, firststep, pp, gg;
    wire randcout, randcout2, randcout3, quotbit;

    assign shiftedquot[63:1] = aqReg[62:0];
    assign shiftedquot[0] = 1'b0;

    assign gee = shiftedquot[63:32] & divisor;
    assign pee = shiftedquot[63:32] | divisor;

    full_cla subadd(.sum(aplusm), .carryout(randcout), .data_operandA(shiftedquot[63:32]), .data_operandB(divisor), 
                    .carryin(1'b0), .p(pee), .g(gee));

    assign notdivisor = ~divisor;
    assign gg = shiftedquot[63:32] & notdivisor;
    assign pp = shiftedquot[63:32] | notdivisor;

    full_cla subdivisor(.sum(aminusm), .carryout(randcout3), .data_operandA(shiftedquot[63:32]), .data_operandB(notdivisor), 
                        .carryin(1'b1), .p(pp), .g(gg));

    mux_2 suboradd(.out(firststep), .select(shiftedquot[63]), .in0(aminusm), .in1(aplusm));

    onebitmux eachbit(.out(quotbit), .select(firststep[31]), .in0(1'b1), .in1(1'b0));

    assign almostthere = {firststep, shiftedquot[31:1], quotbit};
    assign currentvalue = almostthere;

endmodule

