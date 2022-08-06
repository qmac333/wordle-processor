module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB, 

	data_corr0, data_corr1, data_corr2, data_corr3, data_corr4, 
	data_guess0, data_guess1, data_guess2, data_guess3, data_guess4,
	data_color0, data_color1, data_color2, data_color3, data_color4,
	readysignal, counter

);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB, counter;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	wire[31:0] outdecoder, write_enable, outrs1, outrs2;
	wire[1023:0] outofreg;

	//WORDLE
	input [31:0] data_corr0, data_corr1, data_corr2, data_corr3, data_corr4, 
		data_guess0, data_guess1, data_guess2, data_guess3, data_guess4; 
	output [31:0] data_color0, data_color1, data_color2, data_color3, data_color4;
	output readysignal;
	
	assign readysignal = outofreg[32];

    assign data_color0 = outofreg[32*17+31:32*17];
    assign data_color1 = outofreg[32*18+31:32*18];
    assign data_color2 = outofreg[32*19+31:32*19];
    assign data_color3 = outofreg[32*20+31:32*20];
    assign data_color4 = outofreg[32*21+31:32*21];

	decoder5to32 dec1(.out(outdecoder), .addr(ctrl_writeReg));

	genvar i;
    generate
        for (i=0; i<32; i = i + 1) begin: loop1
            and andgate(write_enable[i], ctrl_writeEnable, outdecoder[i]);
        end
    endgenerate

	decoder5to32 dec2(.out(outrs1), .addr(ctrl_readRegA));
	decoder5to32 dec3(.out(outrs2), .addr(ctrl_readRegB));
	register reg0(.ie(write_enable[0]), .indata(32'b00000000000000000000000000000000), .clk(clock), .clr(ctrl_reset), .out(outofreg[31:0]));

	genvar j;
    generate
        for (j=1; j<22; j = j + 1) begin: loop2
            register reggie(.ie(write_enable[j]), .indata(data_writeReg), .clk(clock), .clr(ctrl_reset), .out(outofreg[32*j+31:32*j]));
		end
    endgenerate

	register r22 (.ie(counter==0), .indata(data_corr0), .clk(clock), .clr(ctrl_reset), .out(outofreg[32*22+31:32*22]) ); 
	register r23 (.ie(counter==0), .indata(data_corr1), .clk(clock), .clr(ctrl_reset), .out(outofreg[32*23+31:32*23]) );
	register r24 (.ie(counter==0), .indata(data_corr2), .clk(clock), .clr(ctrl_reset), .out(outofreg[32*24+31:32*24]) ); 
	register r25 (.ie(counter==0), .indata(data_corr3), .clk(clock), .clr(ctrl_reset), .out(outofreg[32*25+31:32*25]) );
	register r26 (.ie(counter==0), .indata(data_corr4), .clk(clock), .clr(ctrl_reset), .out(outofreg[32*26+31:32*26]) ); 
	register r27 (.ie(counter%5==4), .indata(data_guess0), .clk(clock), .clr(ctrl_reset), .out(outofreg[32*27+31:32*27]) );
	register r28 (.ie(counter%5==4), .indata(data_guess1), .clk(clock), .clr(ctrl_reset), .out(outofreg[32*28+31:32*28]) ); 
	register r29 (.ie(counter%5==4), .indata(data_guess2), .clk(clock), .clr(ctrl_reset), .out(outofreg[32*29+31:32*29]) );
	register r30 (.ie(counter%5==4), .indata(data_guess3), .clk(clock), .clr(ctrl_reset), .out(outofreg[32*30+31:32*30]) ); 
	register r31 (.ie(counter%5==4), .indata(data_guess4), .clk(clock), .clr(ctrl_reset), .out(outofreg[32*31+31:32*31]) );

	genvar k;
    generate
        for (k=0; k<32; k = k + 1) begin: loop3
            tri_buffer buff1(.in(outofreg[32*k+31:32*k]), .out(data_readRegA), .oe(outrs1[k]));
		end
    endgenerate

	genvar p;
    generate
        for (p=0; p<32; p = p + 1) begin: loop4
            tri_buffer buff2(.in(outofreg[32*p+31:32*p]), .out(data_readRegB), .oe(outrs2[p]));
		end
    endgenerate

endmodule
