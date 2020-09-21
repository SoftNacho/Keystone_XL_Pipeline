ORIGIN 0
SEGMENT CodeSegment:

Start: 
	ADD R0, R0, -1
	TRAP TrapHouse
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	BRnzp Failed

BAD : DATA2 4xBADD
GOOD : DATA2 4x600D

Passed:
	LDR R7, R1, GOOD
	NOP
	NOP
	NOP
	NOP
	NOP
	BRnzp Passed
	NOP
	NOP
	NOP
	NOP
	NOP

Failed:
	LDR R7, R1, BAD
	BRnzp Failed

TrapHouse: DATA2 4x0016
