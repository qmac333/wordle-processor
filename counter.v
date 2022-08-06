module counter(out, clock, reset);

    input clock, reset;
    output [31:0] out;

    wire [31:0] indata;
    wire cout;

    full_cla adder(.sum(indata), .carryout(cout), .data_operandA(out), .data_operandB(32'b00000000000000000000000000000000), 
                   .carryin(1'b1), .p(out), .g(32'b00000000000000000000000000000000));

    register count(.clr(reset), .out(out), .clk(clock), .ie(1'b1), .indata(indata));

endmodule