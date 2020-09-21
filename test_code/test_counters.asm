ORIGIN 0
SEGMENT CodeSegment:


Boot:
	LDR R2, R7, ICACHE_MISS
	LDR R3, R2, 0
	ADD R1, R1, 1
	ADD R1, R1, 1
	ADD R1, R1, 1
	BRnzp Start

ICACHE_MISS : DATA2 4xFFFF
ICACHE_HIT  : DATA2 4xFFFD
DCACHE_MISS : DATA2 4xFFFB
DCACHE_HIT  : DATA2 4xFFF9

Start:
	ADD R1, R1, 1
	ADD R1, R1, 1
	ADD R1, R1, 1
	ADD R1, R1, 1
	ADD R1, R1, 1
	ADD R1, R1, 1
	ADD R1, R1, 1
	ADD R1, R1, 1
	ADD R1, R1, 1
	ADD R1, R1, 1
	ADD R1, R1, 1
	ADD R1, R1, 1
	LDR R3, R2, 0
	STR R3, R2, 0
	LDR R3, R2, 0
	LDR R2, R7, ICACHE_HIT
	LDR R4, R2, 0
	STR R4, R2, 0
	LDR R2, R7, DCACHE_MISS
	LDR R5, R2, 0
	STR R5, R2, 0
	LDR R2, R7, DCACHE_HIT
	LDR R6, R2, 0
	STR R6, R2, 0

Halt:
	BRnzp Halt
