module decoder3to8(out, addr);

    input [2:0] addr; 
    output [7:0] out;
    wire not1, not2, not3;

    not n3(not3, addr[0]);
    not n4(not2, addr[1]);
    not n5(not1, addr[2]);

    and and1(out[0], not1, not2, not3);
    and and2(out[1], not1, not2, addr[0]);
    and and3(out[2], not1, addr[1], not3);
    and and4(out[3], not1, addr[1], addr[0]);
    and and5(out[4], addr[2], not2, not3);
    and and6(out[5], addr[2], not2, addr[0]);
    and and7(out[6], addr[2], addr[1], not3);
    and and8(out[7], addr[2], addr[1], addr[0]);

endmodule