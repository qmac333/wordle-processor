module insndecoder(opcode, aluop, regWE, useimmed, dataWE, useDataMem, opcodezero, bne, blt, useRdAsB, useRdInsn, jump, jr, rori,
        roraddi, addi, setx, bex, jal, branchinsn);

    input [4:0] opcode, aluop;
    output regWE, useimmed, dataWE, useDataMem, opcodezero, bne, blt, useRdAsB, useRdInsn, jump, jr, rori, roraddi, addi, setx,
    bex, jal, branchinsn;

    wire [31:0] decoderout;

    // gonna give a one-hot value like 00000...01000
    decoder5to32 decode(.out(decoderout), .addr(opcode));

    nor op(opcodezero, opcode[0], opcode[1], opcode[2], opcode[3], opcode[4]);

    // write enable for the register if its any instr w opcode 0 or addi, or lw
    or writeenablegate(regWE, decoderout[0], decoderout[3], decoderout[5], decoderout[8], decoderout[21]);

    // use immediate
    or immedgate(useimmed, decoderout[5], decoderout[7], decoderout[8]);

    // dataWE only high if opcode is 00111 (7) which is a store word instruction
    assign dataWE = decoderout[7];

    // useDataMem only if opcode is 01000 (8) which is a load word instruction
    assign useDataMem = decoderout[8];

    // let processor know if we got a bne or blt instruction
    assign bne = decoderout[2];
    assign blt = decoderout[6];

    or rdb(useRdAsB, decoderout[7], decoderout[2], decoderout[6], decoderout[4]);

    or rdinsn(useRdInsn, decoderout[0], decoderout[5], decoderout[8]);

    assign jump = decoderout[1];

    assign jr = decoderout[4];

    or or1(rori, decoderout[0], decoderout[5], decoderout[7], decoderout[8], decoderout[2], decoderout[6]);

    or or2(roraddi, decoderout[0], decoderout[5]);

    assign addi = decoderout[5];

    assign setx = decoderout[21];

    assign bex = decoderout[22];

    assign jal = decoderout[3];

    assign branchinsn = (decoderout[2] || decoderout[6] || decoderout[22]);

endmodule