module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    wire [63:0] firstwire, productwire, prod, shiftedprod, shiftedornot, quotientwire, divvalue, quot; 
    wire [31:0] divcounter, leftproduct, rightproduct, leftout, aluoutput, aluinright, andWire, orWire, 
                divaluout, divg, divp, leftquotient, rightquotient, posDivisor, posDividend, oppDivisor, oppDividend, divnegate,
                dividendnegate, dividenegative, negativeans, almostresult, multresult, divresult, intermeddiv;
    wire checkbit, outdff, cin, dffselect, overflow1, overflow2, w1, w2, w3, w4, w5, zeroinput, newquot,
         flipsign, div, mult, dataisgood, divcero, multexception, dffselect1, dffselect2, finishmult, finishdiv;
    wire [2:0] controlbits;

    assign firstwire[63:32] = 32'b00000000000000000000000000000000;
    assign firstwire[31:0] = data_operandB;

    dffe divide(.q(div), .d(ctrl_DIV), .clk(clock), .en(ctrl_DIV | ctrl_MULT));
    dffe multiply(.q(mult), .d(ctrl_MULT), .clk(clock), .en(ctrl_DIV | ctrl_MULT));

    // exception if we're dividing by zero
    nor divzero(divcero, data_operandB[31], data_operandB[30], data_operandB[29], data_operandB[28], data_operandB[27], 
                data_operandB[26], data_operandB[25], data_operandB[24], data_operandB[23], data_operandB[22], data_operandB[21], 
                data_operandB[20], data_operandB[19], data_operandB[18], data_operandB[17], data_operandB[16], data_operandB[15], 
                data_operandB[14], data_operandB[13], data_operandB[12], data_operandB[11], data_operandB[10], data_operandB[9], 
                data_operandB[8], data_operandB[7], data_operandB[6], data_operandB[5], data_operandB[4], data_operandB[3], 
                data_operandB[2], data_operandB[1], data_operandB[0]);

    // counter for the whole operation - runs 32 clock cycles (mult takes 16, division takes 32)
    counter divcount(.out(divcounter), .clock(clock), .reset(ctrl_DIV | ctrl_MULT));

    // tells when to output that data is ready based on whether it's multiplication or division algorithm
    and donemult(finishmult, mult, divcounter[3], divcounter[2], divcounter[1], divcounter[0]);
    and donediv(finishdiv, div, divcounter[4], divcounter[3], divcounter[2], divcounter[1], divcounter[0]);

    onebitmux divormult(.out(dataisgood), .select(div), .in0(finishmult), .in1(finishdiv));
    onebitmux divready(.out(data_resultRDY), .select(dataisgood), .in0(1'b0), .in1(1'b1)); 

    // get the positive version of dividend and divisor to use in division
    assign oppDividend = ~data_operandA;
    assign oppDivisor = ~data_operandB;

    full_cla negateDividend(.sum(dividendnegate), .data_operandA(oppDividend), .data_operandB(firstwire[63:32]), 
                    .carryin(1'b1), .p(oppDividend), .g(firstwire[63:32]));
    full_cla negateDivisor(.sum(divnegate), .data_operandA(oppDivisor), .data_operandB(firstwire[63:32]), 
                .carryin(1'b1), .p(oppDivisor), .g(firstwire[63:32]));

    mux_2 choosepos(.out(posDividend), .select(data_operandA[31]), .in0(data_operandA), .in1(dividendnegate));
    mux_2 chooseposagain(.out(posDivisor), .select(data_operandB[31]), .in0(data_operandB), .in1(divnegate));   

    // MULTIPLICATION
    assign controlbits = {productwire[1], productwire[0], outdff};
    multcontrol control(.data_added(aluinright), .carryinALU(cin), .inbits(controlbits), .multiplicand(data_operandA));

    assign andWire = productwire[63:32] & aluinright;
    assign orWire = productwire[63:32] | aluinright;

    full_cla addsub(.sum(aluoutput), .data_operandA(productwire[63:32]), .data_operandB(aluinright), 
                    .carryin(cin), .p(orWire), .g(andWire));

    mux_2 firstoperation(.out(leftproduct), .select(ctrl_MULT), .in0(aluoutput), .in1(firstwire[63:32])); 

    // BACK TO DIVISION
    mux_2 firstdivop(.out(leftquotient), .select(ctrl_DIV), .in0(quotientwire[63:32]), .in1(firstwire[63:32])); 


    // if counter is 0, choose data_operandB for right register. If counter is not 0, choose the last output of the right register
    mux_2 rightreg(.out(rightproduct), .select(ctrl_MULT), .in0(productwire[31:0]), .in1(firstwire[31:0])); 
    mux_2 seconddivop(.out(rightquotient), .select(ctrl_DIV), .in0(quotientwire[31:0]), .in1(posDividend)); 

    // MULTIPLICATION PRODUCT GOING INTO REGISTER
    assign prod = {leftproduct, rightproduct}; //concatenate the left and right registers to be prod

    assign shiftedprod[61:0] = prod[63:2];
    assign shiftedprod[62] = prod[63];
    assign shiftedprod[63] = prod[63];

    mux64bit decidetouseshift(.out(shiftedornot), .select(ctrl_MULT), .in0(shiftedprod), .in1(prod));

    // ASSIGNING THE DIVISION TO PUT INTO REGISTER
    assign quot = {leftquotient, rightquotient};

    divcontrol ctrldiv(.currentvalue(divvalue), .signA(quot[63]), .aqReg(quot), .divisor(posDivisor));

    //this is the 64 bit product register. outputs productwire
    register_64bit productreg(.out(productwire), .clk(clock), .ie(1'b1), .indata(shiftedornot));
    register_64bit quotientreg(.out(quotientwire), .clk(clock), .ie(1'b1), .indata(divvalue));

    // ANSWER FOR MULTIPLICATION
    assign multresult = shiftedprod;

    // RESULT CALCULATION FOR DIVISION
    assign negativeans = ~quotientwire[31:0];
    full_cla answernegative(.sum(dividenegative), .data_operandA(negativeans), .data_operandB(32'b00000000000000000000000000000000),
                            .carryin(1'b1), .p(negativeans), .g(32'b00000000000000000000000000000000));

    xor answersign(flipsign, data_operandA[31], data_operandB[31]);
    mux_2 changesign(.out(almostresult), .select(flipsign), .in0(quotientwire[31:0]), .in1(dividenegative));
    mux_2 exceptions(.out(divresult), .select(data_exception), .in0(almostresult), .in1(32'b00000000000000000000000000000000));

    // mux for choosing whether to output div result or mult result
    mux_2 yay(.out(data_result), .select(div), .in0(multresult), .in1(divresult));

    //dff for the last bit in MULTIPLICATION
    dffe lastbit(.q(outdff), .d(prod[1]), .clk(clock), .en(1'b1), .clr(ctrl_MULT)); 

    // overflow stuff for multiplication
    and and1(w4, shiftedprod[63], shiftedprod[62], shiftedprod[61], shiftedprod[60], shiftedprod[59], 
        shiftedprod[58], shiftedprod[57], shiftedprod[56], shiftedprod[55], shiftedprod[54], shiftedprod[53], shiftedprod[52], 
        shiftedprod[51], shiftedprod[50], shiftedprod[49], shiftedprod[48], shiftedprod[47], shiftedprod[46], shiftedprod[45], 
        shiftedprod[44], shiftedprod[43], shiftedprod[42], shiftedprod[41], shiftedprod[40], shiftedprod[39], shiftedprod[38], 
        shiftedprod[37], shiftedprod[36], shiftedprod[35], shiftedprod[34], shiftedprod[33], shiftedprod[32], shiftedprod[31]);

    nor nor1(w5, shiftedprod[63], shiftedprod[62], shiftedprod[61], shiftedprod[60], shiftedprod[59], 
        shiftedprod[58], shiftedprod[57], shiftedprod[56], shiftedprod[55], shiftedprod[54], shiftedprod[53], shiftedprod[52], 
        shiftedprod[51], shiftedprod[50], shiftedprod[49], shiftedprod[48], shiftedprod[47], shiftedprod[46], shiftedprod[45], 
        shiftedprod[44], shiftedprod[43], shiftedprod[42], shiftedprod[41], shiftedprod[40], shiftedprod[39], shiftedprod[38], 
        shiftedprod[37], shiftedprod[36], shiftedprod[35], shiftedprod[34], shiftedprod[33], shiftedprod[32], shiftedprod[31]);

    nor nor4(overflow1, w4, w5);

    xor xor2(w3, shiftedprod[31], data_operandA[31], data_operandB[31]);

    nor nor2(w1, data_operandA[31], data_operandA[30], data_operandA[29], data_operandA[28], data_operandA[27], data_operandA[26], 
             data_operandA[25], data_operandA[24], data_operandA[23], data_operandA[22], data_operandA[21], data_operandA[20], 
             data_operandA[19], data_operandA[18], data_operandA[17], data_operandA[16], data_operandA[15], data_operandA[14], 
             data_operandA[13], data_operandA[12], data_operandA[11], data_operandA[10], data_operandA[9], data_operandA[8], 
             data_operandA[7], data_operandA[6], data_operandA[5], data_operandA[4], data_operandA[3], data_operandA[2], 
             data_operandA[1], data_operandA[0]);

    nor nor3(w2, data_operandB[31], data_operandB[30], data_operandB[29], data_operandB[28], data_operandB[27], data_operandB[26], 
             data_operandB[25], data_operandB[24], data_operandB[23], data_operandB[22], data_operandB[21], data_operandB[20], 
             data_operandB[19], data_operandB[18], data_operandB[17], data_operandB[16], data_operandB[15], data_operandB[14], 
             data_operandB[13], data_operandB[12], data_operandB[11], data_operandB[10], data_operandB[9], data_operandB[8], 
             data_operandB[7], data_operandB[6], data_operandB[5], data_operandB[4], data_operandB[3], data_operandB[2], 
             data_operandB[1], data_operandB[0]);

    or or1(zeroinput, w1, w2);

    onebitmux decideoverflow(.out(overflow2), .select(zeroinput), .in0(w3), .in1(1'b0));

    or or2(multexception, overflow1, overflow2);

    onebitmux expc(.out(data_exception), .select(div), .in0(multexception), .in1(divcero));

endmodule