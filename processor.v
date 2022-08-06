/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */
    wire [31:0] counter, outROM, rsout, rtout, aluout, signeximmed, aluin2, pcplus1, dmemout, regin, pclatch1, 
    insnreg1, pclatch2, insnreg2, regS, regT, insnreg3, alureg, rTee, insnreg4, lastaluout, datalatch, pcbranch, pcnext, 
    aluA, aluAalmost, aluBalmost, bALU, datainmem, extendedjump, nextprogram, ir2, expvalue, excp, ovf4, aluin1,
    aluB, firstaluinp, secondaluinp, almostwb, bebebaba, ir1, jr, jrtojump, bypjr, almostregin, pcand1, pclatch3, pclatch4,
    inreg1, muldivresult, muldiv3, muldiv4, insnregmd;
    wire regWE, aluoverflow, immed, writeData, dmemOrNot, opcodezero, rdbinsn, blt, bne, takeltbranch, notequal, less,
    takenebranch, branchselect, inUsesRd, rsrdSame, MXSelect, rdinsn, rdinsn4, rsrdSame4, WXSelect, rsrtSame, MXSelectB, rsrtSame4,
    rtinsn, rtinsn4, wmbypass, rdrdSame, isnop4, isnop3, WXSelectB, isjump, dxlw, stallfirstpart, bpstall1, bpstall11,
    wehaveastore, secondlatchrd, rdrs2, roriins, stallplease, stall2, pcgreaterthan2, isnop1, ovf3, addir, excptn, 
    isnop2, addiinsn, detectexp, setxinsn, branchex, r30not0, jrinsn, bypassjr, aheadjr, jal4, jal2, jal3, jal1, jalstallmux, 
    branch2, minsn, dinsn, mdstall, muldivexcp, mdready, opzero3, minsn3, dinsn3;
    wire [4:0] aluop, breg, aluopintd, stallbits, addiop, wbreg, wbregsoon, properreg;

    // PROGRAM COUNTER is just a register
    register programcounter(.out(counter), .clk(!clock), .ie(!(bpstall1 || mdstall)), .indata(bebebaba), .clr(reset)); 
    full_cla addpc(.sum(pcplus1), .data_operandA(counter), .data_operandB(32'b0), 
    .carryin(1'b1), .p(counter), .g(32'b0));
    

    // ROM takes in the counter for the current instruction address
    assign address_imem = counter;

    // check if it's a jump insn and then change the pc
    insndecoder checkjump(.opcode(insnreg1[31:27]), .jump(isjump));
    assign extendedjump = jal4 ? {5'b0, insnreg4[26:0]} : {5'b0, insnreg1[26:0]};
    mux_2 jumpornah(.out(nextprogram), .select(isjump || jal4), .in0(pcplus1), .in1(extendedjump));
    mux_2 nextpc(.out(pcnext), .select(branchselect), .in0(nextprogram), .in1(pcbranch));
    mux_2 jumpreg(.out(jr), .select(jrinsn), .in0(pcnext), .in1(data_readRegB));
    mux_2 jrbypass2nd(.out(bypjr), .select(bypassjr), .in0(jr), .in1(aluout));
    mux_2 bexornah(.out(bebebaba), .select(r30not0), .in0(bypjr), .in1(extendedjump));

    assign jalstallmux = jal1 || jal2 || jal3 || jal4;
    mux_2 jalstall(.out(inreg1), .select(jalstallmux || branchselect), .in0(q_imem), .in1(32'b0));

    // FIRST LATCH
    register pcholder1(.out(pclatch1), .clk(!clock), .ie(!(bpstall1 || mdstall)), .indata(pcplus1), .clr(reset));
    register insnregister1(.out(insnreg1), .clk(!clock), .ie(!(bpstall1 || mdstall)), .indata(inreg1), .clr(reset));

    // regfile
    assign ctrl_writeEnable = regWE;
    assign ctrl_writeReg = wbreg;
    assign ctrl_readRegA = (insnreg1[31:27] == 5'b10110) ? 5'b11110 : insnreg1[21:17];
    insndecoder choosereadregB(.opcode(insnreg1[31:27]), .useRdAsB(rdbinsn), .dataWE(wehaveastore), .rori(roriins),
    .bex(branchex), .jr(jrinsn), .jal(jal1));
    mux_5bit chooseB(.out(breg), .select(rdbinsn), .in0(insnreg1[16:12]), .in1(insnreg1[26:22]));
    assign ctrl_readRegB = breg;
    assign data_writeReg = regin;

    // stall logic mux
    assign stallfirstpart = (breg == insnreg2[26:22]) ? 1'b1 : 1'b0;
    assign isnop1 = (insnreg1 == 32'b0) ? 1'b1 : 1'b0;
    assign isnop2 = (insnreg2 == 32'b0) ? 1'b1 : 1'b0;
    assign rdrs2 = (secondlatchrd && (roriins && !isnop1 && !isnop2 && (insnreg2[26:22] == insnreg1[21:17])));
    or or3(bpstall11, stallfirstpart, rdrs2);
    and and6(bpstall1, dxlw, bpstall11, !wehaveastore); 

    mux_2 stallornot(.out(ir2), .select(bpstall1 || aheadjr || branchselect || mdstall), .in0(insnreg1), .in1(32'b0));

    // if its a bex insn AND r30 isn't 0, set r30not0 to 1
    assign r30not0 = (branchex && data_readRegA != 32'b0) ? 1'b1 : 1'b0;
    

    // SECOND LATCH
    register pcholder2(.out(pclatch2), .clk(!clock), .ie(!(minsn3 || dinsn3)), .indata(pclatch1), .clr(reset));
    register insnregister2(.out(insnreg2), .clk(!clock), .ie(!(minsn3 || dinsn3)), .indata(ir2), .clr(reset));
    register a(.out(regS), .clk(!clock), .ie(!(minsn3 || dinsn3)), .indata(data_readRegA), .clr(reset));
    register b(.out(regT), .clk(!clock), .ie(!(minsn3 || dinsn3)), .indata(data_readRegB), .clr(reset));

    // mux to decide whether or not to use the sign extended immediate or $rt
    insndecoder signextension(.opcode(insnreg2[31:27]), .useimmed(immed), .opcodezero(opcodezero), .bne(notequal), .blt(less), 
    .useDataMem(dxlw), .useRdInsn(secondlatchrd), .jr(aheadjr), .jal(jal2), .branchinsn(branch2));
    signextend extension(.extended(signeximmed), .input17bits(insnreg2[16:0]));
    mux_2 immedORrt(.out(aluin2), .select(immed), .in0(aluB), .in1(signeximmed));

    // add immediate to PC for branch insns
    alu addimmd(.data_operandA(signeximmed), .data_operandB(pclatch2), .ctrl_ALUopcode(5'b0), .data_result(pcbranch));

    // jr bypassing1
    assign bypassjr = (jrinsn && secondlatchrd && (insnreg2[26:22] == insnreg1[26:22])) ? 1'b1 : 1'b0;

    // check if its a nop insn
    assign isnop3 = (insnreg3 == 32'b0) ? 1'b1 : 1'b0;
    assign isnop4 = (insnreg4 == 32'b0) ? 1'b1 : 1'b0;

    assign properreg = branch2 ? insnreg2[26:22] : insnreg2[16:12];

    // mux to decide about ALUinA bypassing
    assign rsrdSame4 = (insnreg4[26:22] == insnreg2[21:17]) ? 1'b1 : 1'b0;
    and and2(WXSelect, rsrdSame4, rdinsn4);
    mux_2 wx(.out(aluAalmost), .select(WXSelect), .in0(regS), .in1(regin));

    assign rsrdSame = (insnreg3[26:22] == insnreg2[21:17]) ? 1'b1 : 1'b0;
    and and1(MXSelect, rsrdSame, rdinsn, !isnop3);
    mux_2 mx(.out(aluA), .select(MXSelect), .in0(aluAalmost), .in1(alureg));

    assign firstaluinp = (excptn && (insnreg2[21:17] == 5'b11110)) ? expvalue : aluA;
    assign aluin1 = insnreg2[21:17] == 5'b0 ? 32'b0 : firstaluinp;


    // mux to decide about ALUinB bypassing
    assign rsrtSame = (insnreg3[26:22] == properreg) ? 1'b1 : 1'b0;
    and and4(MXSelectB, rsrtSame, rdinsn, !isnop3);
    mux_2 mxb(.out(aluBalmost), .select(MXSelectB), .in0(regT), .in1(alureg));

    assign rsrtSame4 = (insnreg4[26:22] == properreg) ? 1'b1 : 1'b0;
    and and5(WXSelectB, rsrtSame4, rdinsn4, !isnop4);
    mux_2 wxb(.out(bALU), .select(WXSelectB), .in0(aluBalmost), .in1(regin));

    assign secondaluinp = (excptn && (properreg == 5'b11110)) ? expvalue : bALU;
    assign aluB = ((properreg == 5'b0) && (insnreg2[31:27] == 5'b0)) ? 32'b0 : secondaluinp;



    mux_5bit decidealuop(.out(aluopintd), .select(opcodezero), .in0(5'b0), .in1(insnreg2[6:2]));
    assign aluop = (notequal | less) ? 5'b00001 : aluopintd;
    alu ayelyou(.data_operandA(aluin1), .data_operandB(aluin2), .ctrl_ALUopcode(aluop), 
    .ctrl_shiftamt(insnreg2[11:7]), .data_result(aluout), .overflow(aluoverflow), .isLessThan(blt), .isNotEqual(bne));

    // MULTDIV AND ITS LATCHES
    assign minsn = (opcodezero && (aluop == 5'b00110)) ? 1'b1 : 1'b0;
    assign dinsn = (opcodezero && (aluop == 5'b00111)) ? 1'b1 : 1'b0;
    multdiv md(.data_operandA(aluin1), .data_operandB(aluin2), .ctrl_MULT(minsn), .ctrl_DIV(dinsn), .clock(clock), 
    .data_result(muldivresult), .data_exception(muldivexcp), .data_resultRDY(mdready));
    assign mdstall = (!mdready && (minsn || dinsn)) ? 1'b1 : 1'b0;
    
    register md3(.out(muldiv3), .clk(!clock), .ie(!mdstall), .indata(muldivresult), .clr(reset));
    register mdins(.out(insnregmd), .clk(!clock), .ie(!mdstall), .indata(insnreg2), .clr(reset));




    // branching logic
    and branchlt(takeltbranch, less, (!blt && bne));
    and branchne(takenebranch, notequal, bne);
    or or1(branchselect, takeltbranch, takenebranch);

    // THIRD LATCH
    register insnregister3(.out(insnreg3), .clk(!clock), .ie(1'b1), .indata(insnreg2), .clr(reset));
    register o(.out(alureg), .clk(!clock), .ie(1'b1), .indata(aluout), .clr(reset));
    register b2(.out(rTee), .clk(!clock), .ie(1'b1), .indata(bALU), .clr(reset));
    dffe ovfbit(.q(ovf3), .d(aluoverflow), .clk(!clock), .en(1'b1), .clr(reset));
    register pc3(.out(pclatch3), .clk(!clock), .ie(1'b1), .indata(pclatch2), .clr(reset));

    insndecoder thirdlatch(.opcode(insnreg3[31:27]), .useRdInsn(rdinsn), .roraddi(addir), .addi(addiinsn), .jal(jal3),
    .opcodezero(opzero3));

    assign minsn3 = (opzero3 && (insnreg3[6:2] == 5'b00110)) ? 1'b1 : 1'b0;
    assign dinsn3 = (opzero3 && (insnreg3[6:2] == 5'b00111)) ? 1'b1 : 1'b0;

    // Bypass mux 
    assign rdrdSame = (insnreg3[26:22] == insnreg4[26:22]) ? 1'b1 : 1'b0;
    and and3(wmbypass, rdinsn4, rdrdSame, writeData);
    mux_2 wm(.out(datainmem), .select(wmbypass), .in0(rTee), .in1(regin));

    // DATA MEMORY 
    insndecoder dmemstage(.opcode(insnreg3[31:27]), .dataWE(writeData));
    assign address_dmem = alureg;
    assign data = datainmem;
    assign wren = writeData;

    and and8(excptn, addir, ovf3);
    mux_5bit addiornot(.out(addiop), .select(addiinsn), .in0(insnreg3[6:2]), .in1(insnreg3[31:27]));
    mux_8 decideexcp(.out(expvalue), .select(addiop[2:0]), .in0(32'b00000000000000000000000000000001), 
    .in1(32'b00000000000000000000000000000011), .in2(32'b0), .in3(32'b0), .in4(32'b0),
    .in5(32'b00000000000000000000000000000010), .in6(32'b00000000000000000000000000000100), .in7(32'b00000000000000000000000000000101));

    // FOURTH AND FINAL LATCH
    register insnregister4(.out(insnreg4), .clk(!clock), .ie(!mdstall), .indata(insnreg3), .clr(reset));
    register o2(.out(lastaluout), .clk(!clock), .ie(!mdstall), .indata(alureg), .clr(reset));
    register dater(.out(datalatch), .clk(!clock), .ie(!mdstall), .indata(q_dmem), .clr(reset));
    register exceptionvalue(.out(ovf4), .indata(expvalue), .ie(!mdstall), .clk(!clock), .clr(reset));
    dffe exc(.q(detectexp), .d(excptn), .clk(!clock), .en(!mdstall), .clr(reset));
    register pc4(.out(pclatch4), .clk(!clock), .ie(!mdstall), .indata(pclatch3), .clr(reset));

    insndecoder fourthlatch(.opcode(insnreg4[31:27]), .useRdInsn(rdinsn4), .setx(setxinsn), .jal(jal4));

    // PC + 1 for jal insns
    // full_cla onemore(.sum(pcand1), .data_operandA(pclatch4), .data_operandB(32'b0), .carryin(1'b1), .p(pclatch4), .g(32'b0));

    // mux to choose whether to write aluoutput or data memory output to regfile
    insndecoder writebackctrl(.opcode(insnreg4[31:27]), .regWE(regWE), .useDataMem(dmemOrNot));
    mux_2 excpornot(.out(excp), .select(detectexp), .in0(lastaluout), .in1(ovf4));
    mux_2 writeback(.out(almostwb), .select(dmemOrNot), .in0(excp), .in1(datalatch));
    assign almostregin = setxinsn ? {5'b0, insnreg4[26:0]} : almostwb;
	assign regin = jal4 ? pclatch4 : almostregin;
    assign wbregsoon = (detectexp | setxinsn) ? 5'b11110 : insnreg4[26:22];
    assign wbreg = jal4 ? 5'b11111 : wbregsoon;
	/* END CODE */

endmodule
