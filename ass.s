#reg 22,23,24,25,26 correct chars, 0 padded
#reg 27,28,29,30,31 guess chars, 0 padded
#reg 17,18,19,20,21 color vals 

_beforestart:
addi $r1, $r0, 0
bne $r0, $r31, _startgame
j _beforestart
nop
nop
nop
nop

_startgame: #_check0:
bne $r22, $r27, _ng0
addi $r17, $r0, 1477

_check1:
bne $r23, $r28, _ng1
addi $r18, $r0, 1477 # pc = 12

_check2: # pc = 12
bne $r24, $r29, _ng2
addi $r19, $r0, 1477

_check3:
bne $r25, $r30, _ng3
addi $r20, $r0, 1477

_check4: 
bne $r26, $r31, _ng4
addi $r21, $r0, 1477


_donecheck: 
addi $r31, $r0, 0
addi $r1, $r0, 1
j _beforestart
nop
nop
nop
nop





_ng0: #_check0_1 pc = 24
bne $r27, $r23, _check0_2
addi $r17, $r0, 4033
j _check1
nop
nop
nop
nop
_check0_2: 
bne $r27, $r24, _check0_3
addi $r17, $r0, 4033
j _check1
nop
nop
nop
nop
_check0_3: 
bne $r27, $r25, _check0_4
addi $r17, $r0, 4033
j _check1
nop
nop
nop
nop
_check0_4: 
bne $r27, $r26, _black0
addi $r17, $r0, 4033
j _check1
nop
nop
nop
nop
_black0:
addi $r17, $r0, 0
j _check1
nop
nop
nop
nop

_ng1: #_check1_0 pc = 48
bne $r28, $r22, _check1_2
addi $r18, $r0, 4033
j _check2
nop
nop
nop
nop
_check1_2: 
bne $r28, $r24, _check1_3
addi $r18, $r0, 4033
j _check2
nop
nop
nop
nop
_check1_3: 
bne $r28, $r25, _check1_4
addi $r18, $r0, 4033
j _check2
nop
nop
nop
nop
_check1_4: 
bne $r28, $r26, _black1
addi $r18, $r0, 4033
j _check2
nop
nop
nop
nop
_black1:
addi $r18, $r0, 0
j _check2
nop
nop
nop
nop

_ng2: #_check2_0  pc = 41
bne $r29, $r22, _check2_1
addi $r19, $r0, 4033
j _check3
nop
nop
nop
nop
_check2_1: 
bne $r29, $r23, _check2_3
addi $r19, $r0, 4033
j _check3
nop
nop
nop
nop
_check2_3: 
bne $r29, $r25, _check2_4
addi $r19, $r0, 4033
j _check3
nop
nop
nop
nop
_check2_4: 
bne $r29, $r26, _black2
addi $r19, $r0, 4033
j _check3
nop
nop
nop
nop
_black2:
addi $r19, $r0, 0
j _check3
nop
nop
nop
nop

_ng3: #_check3_0
bne $r30, $r22, _check3_1
addi $r20, $r0, 4033
j _check4
nop
nop
nop
nop
_check3_1: 
bne $r30, $r23, _check3_2
addi $r20, $r0, 4033
j _check4
nop
nop
nop
nop
_check3_2: 
bne $r30, $r24, _check3_4
addi $r20, $r0, 4033
j _check4
nop
nop
nop
nop
_check3_4: 
bne $r30, $r26, _black3
addi $r20, $r0, 4033
j _check4
nop
nop
nop
nop
_black3:
addi $r20, $r0, 0
j _check4
nop
nop
nop
nop

_ng4: #_check4_0
bne $r31, $r22, _check4_1
addi $r21, $r0, 4033
j _donecheck
nop
nop
nop
nop
_check4_1: 
bne $r31, $r23, _check4_2
addi $r21, $r0, 4033
j _donecheck
nop
nop
nop
nop
_check4_2: 
bne $r31, $r24, _check4_3
addi $r21, $r0, 4033
j _donecheck
nop
nop
nop
nop
_check4_3: 
bne $r31, $r25, _black4
addi $r21, $r0, 4033
j _donecheck
nop
nop
nop
nop
_black4:
addi $r21, $r0, 0
j _donecheck
nop
nop
nop
nop
