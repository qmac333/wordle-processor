module register_64bit(out, clk, ie, indata, clr);

    input [63:0] indata;
    input ie, clk, clr;
    output [63:0] out;
    wire clkie;
    wire [63:0] outputwire;

    genvar i;
    generate
        for (i=0; i<64; i = i + 1) begin: loop1
            dffe dflipflop(.d(indata[i]), .q(out[i]), .clk(clk), .en(ie), .clr(clr));
        end
    endgenerate

endmodule