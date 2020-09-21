ORIGIN 0
SEGMENT CodeSegment:

Start: 
	LDR R0, R1, NEG
	NOP
	NOP
	NOP
	NOP
	NOP
	BRn TestZeroLoad
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	BRnzp Failed

POS  : DATA2 4x0001
ZERO : DATA2 4x0000
NEG  : DATA2 4xFFFF

BAD  : DATA2 4xBADD
GOOD : DATA2 4x600D

TestZeroLoad:
	LDR R0, R1, ZERO
	NOP
	NOP
	NOP
	NOP
	NOP
	BRz TestPosLoad
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	BRnzp Failed

TestPosLoad:
	LDR R0, R1, POS
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

