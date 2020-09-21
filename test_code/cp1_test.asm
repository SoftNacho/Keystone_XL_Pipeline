ORIGIN 0
SEGMENT CodeSegment:

Start: 
	ADD R0, R0, -1
	NOP
	NOP
	NOP
	NOP
	NOP
	BRn TestZeroAdd
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	BRnzp Failed

BAD : DATA2 4xBADD
GOOD : DATA2 4x600D

TestZeroAdd:
	ADD R0, R0, 1
	NOP
	NOP
	NOP
	NOP
	NOP
	BRz TestPosAdd
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	BRnzp Failed

TestPosAdd:
	ADD R0, R0, 1
	NOP
	NOP
	NOP
	NOP
	NOP
	BRp Passed
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	BRnzp Failed

Passed:
	LDR R7, R1, GOOD
	BRnzp Passed

Failed:
	LDR R7, R1, BAD
	BRnzp Failed

