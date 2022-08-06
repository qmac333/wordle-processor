module register(out, clk, ie, indata, clr);

    input [31:0] indata;
    input ie, clk, clr;
    output [31:0] out;
    wire clkie;
    wire [31:0] outputwire;

    genvar i;
    generate
        for (i=0; i<32; i = i + 1) begin: loop1
            dffe dflipflop(.d(indata[i]), .q(out[i]), .clk(clk), .en(ie), .clr(clr));
        end
    endgenerate

endmodule

module register40(out, clk, ie, indata, clr);

    input [39:0] indata;
    input ie, clk, clr;
    output [39:0] out;
    wire clkie;
    wire [39:0] outputwire;

    genvar i;
    generate
        for (i=0; i<40; i = i + 1) begin: loop1
            dffe dflipflop(.d(indata[i]), .q(out[i]), .clk(clk), .en(ie), .clr(clr));
        end
    endgenerate

endmodule
