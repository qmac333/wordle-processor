module programCounter(out, clock, reset, valuetoadd);

    input clock, reset;
    input [31:0] valuetoadd;
    output [31:0] out;

    wire [31:0] indata, pWire, gWire;
    wire cout;

    or or1(pWire, out, valuetoadd);
    and and1(gWire, out, valuetoadd);

    full_cla adder(.sum(indata), .data_operandA(out), .data_operandB(valuetoadd), 
                   .carryin(1'b0), .p(pWire), .g(gWire));

    register count(.clr(reset), .out(out), .clk(clock), .ie(1'b1), .indata(indata));


endmodule