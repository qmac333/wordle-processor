module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    wire [31:0] bValue, wNotB, gWire, pWire, andWire, orWire, left, right, sum;
    wire [31:0] lessthan, m;
    wire randomCout, anotherRandomCout, mainCout, w1, w2, w3, w4, w5, w6, w7;

    bitwise_not notB(wNotB, data_operandB);
    mux_2 decideB(bValue, ctrl_ALUopcode[0], data_operandB, wNotB);

    bitwise_and andgate(andWire, data_operandA, data_operandB);
    bitwise_or orgate(orWire, data_operandA, data_operandB);

    bitwise_and gValue(gWire, data_operandA, bValue);
    bitwise_or pValue(pWire, data_operandA, bValue);

    sll leftshift(left, data_operandA, ctrl_shiftamt);
    sra rightshift(right, data_operandA, ctrl_shiftamt);

    full_cla adder(sum, mainCout, data_operandA, bValue, ctrl_ALUopcode[0], pWire, gWire);

    not not1(w1, data_operandA[31]);
    not not2(w2, bValue[31]);
    and and1(w3, w1, w2, sum[31]);

    not not3(w4, sum[31]);
    and and2(w5, w4, data_operandA[31], bValue[31]);
    or or1(overflow, w5, w3);

    mux_8 finalchooser(data_result, ctrl_ALUopcode[2:0], sum, sum, andWire, orWire, left, right, 
        32'b00000000000000000000000000000000, 32'b00000000000000000000000000000000);

    full_cla lessthan_operation(lessthan, randomCout, data_operandA, wNotB, 1'b1, pWire, gWire);
    assign isLessThan = overflow ? mainCout : lessthan[31];

    full_cla minus_equal(m, anotherRandomCout, data_operandA, bValue, 1'b1, pWire, gWire);
    or or3(isNotEqual, m[0], m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8], m[9], m[10], m[11], m[12], m[13], m[14],
           m[15], m[16], m[17], m[18], m[19], m[20], m[21], m[22], m[23], m[24], m[25], m[26], m[27], m[28], m[29], m[30], m[31]);

endmodule