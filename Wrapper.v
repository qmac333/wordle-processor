`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (clock, reset, corr0, corr1, corr2, corr3, corr4, 
					guess0, guess1, guess2, guess3, guess4, 
					color0, color1, color2, color3, color4, rdy, counter);
	input clock, reset;
	input [4:0] counter;
	input [7:0] corr0, corr1, corr2, corr3, corr4, guess0, guess1, guess2, guess3, guess4;
	output [11:0] color0, color1, color2, color3, color4; 
	output rdy;

	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;
    wire[31:0] data_corr0, data_corr1, data_corr2, data_corr3, data_corr4,     //32 bit
	             data_guess0, data_guess1, data_guess2, data_guess3, data_guess4, 
	             data_color0, data_color1, data_color2, data_color3, data_color4;


	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "C:/Users/qmac2/OneDrive/Desktop/Second-Year/ECE350/final-project-team-20/ass";
	
	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut)
		
		// WORDLE
//		.corr0(corr0), .corr1(corr1), .corr2(corr2), .corr3(corr3), .corr4(corr4), //have to wait until processor is ready 
//				.guess0(guess0), .guess1(guess1), .guess2(guess2), .guess3(guess3), .guess4(guess4), //wait until procready
//				.color0(color0), .color1(color1), .color2(color2), .color3(color3), .color4(color4)
		
//		.data_corr0(data_corr0), .data_corr1(data_corr1), .data_corr2(data_corr2), 
//		.data_corr3(data_corr3), .data_corr4(data_corr4), 
//	    .data_guess0(data_guess0), .data_guess1(data_guess1), .data_guess2(data_guess2), 
//	    .data_guess3(data_guess3), .data_guess4(data_guess4),
//	    .data_color0(data_color0), .data_color1(data_color1), .data_color2(data_color2), .data_color3(data_color3), .data_color4(data_color4),
//	    .readysignal(rdy)
		
		
		); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
		
	assign color0 = data_color0[11:0]; //output to VGA
    assign color1 = data_color1[11:0];
    assign color2 = data_color2[11:0];
    assign color3 = data_color3[11:0];
    assign color4 = data_color4[11:0];	
    assign data_corr0 = {24'b0, corr0}; //input from VGA
    assign data_corr1 = {24'b0, corr1};
    assign data_corr2 = {24'b0, corr2};
    assign data_corr3 = {24'b0, corr3};
    assign data_corr4 = {24'b0, corr4};
    assign data_guess0 = {24'b0, guess0}; //input from VGA
    assign data_guess1 = {24'b0, guess1};
    assign data_guess2 = {24'b0, guess2};
    assign data_guess3 = {24'b0, guess3};
    assign data_guess4 = {24'b0, guess4};
    		
	
	// Register File
	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
		.data_corr0(data_corr0), .data_corr1(data_corr1), .data_corr2(data_corr2), 
		.data_corr3(data_corr3), .data_corr4(data_corr4), 
	    .data_guess0(data_guess0), .data_guess1(data_guess1), .data_guess2(data_guess2), 
	    .data_guess3(data_guess3), .data_guess4(data_guess4),
	    .data_color0(data_color0), .data_color1(data_color1), .data_color2(data_color2), .data_color3(data_color3), .data_color4(data_color4),
	    .readysignal(rdy), .counter(counter) );
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));

endmodule
