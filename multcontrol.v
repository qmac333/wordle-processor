module multcontrol(inbits, carryinALU, multiplicand, data_added);

    input [2:0] inbits;
    input [31:0] multiplicand;
    output carryinALU;
    output [31:0] data_added;

    wire [7:0] decoderout;
    wire shift, donothing;
    wire w1, w2, w3, w4, w5, w6;
    wire not2, not1, not0;
    wire [31:0] wNotM, shiftmux, shiftedmult, sub;

    not first(not2, inbits[2]);
    not second(not1, inbits[1]);
    not third(not0, inbits[0]);

    and and1(w1, inbits[2], not1, not0);
    and and2(w2, inbits[2], inbits[1], not0);
    and and3(w3, inbits[2], not1, inbits[0]);
    or or1(carryinALU, w1, w2, w3);

    and and4(w4, not2, inbits[1], inbits[0]);
    or toshiftornot(shift, w1, w4);

    assign shiftedmult = multiplicand << 1;

    mux_2 shifted(.out(shiftmux), .select(shift), .in0(multiplicand), .in1(shiftedmult));

    assign wNotM = ~shiftmux;

    mux_2 subtractornot(.out(sub), .select(carryinALU), .in0(shiftmux), .in1(wNotM));

    and and5(w5, not0, not1, not2);
    and and6(w6, inbits[0], inbits[1], inbits[2]);
    or or2(donothing, w5, w6);

    mux_2 donothingornot(.out(data_added), .select(donothing), .in0(sub), .in1(32'b00000000000000000000000000000000));


endmodule