ORIGIN 0
SEGMENT CodeSegment:

Start: 
	LDR R2, R0, ADDRl2	;load line 1 to Way 0 set 0, get address l2		;cache line 0 address 0x0000
	LDR R3, R0, ADDRl3	;get address l3
	LDI R4, R2, 0		;load line 2 to Way 1 set 0, line 1 LRU
	STR R4, R0, NEG		;dirty up line 1, line 2 LRU
	STR R3, R2, 0		;dirty up line 2, line 1 LRU
	LDI R5, R3, 0		;evict line 1, write-back
	LDR R6, R2, 0
	NOP										;end cache line 0
	NOP										;cache line 1 address 0x0010
	NOP
	NOP
	NOP
	BRn Passed
	NOP
	NOP
	NOP										;end cache line 1
	NOP										;cache line 2 address 0x0020
	NOP
	BRnzp Failed
ADDRl2 : DATA2 4x00A6
ADDRl3 : DATA2 4x0126
ADDRPOS : DATA2 4x0024
NEG  : DATA2 4xFFFF
ZED : DATA2 4x0000									;end cache line 2
POS  : DATA2 4x0001									;cache line 3 address 0x0030
BAD  : DATA2 4xBADD
GOOD : DATA2 4x600D
Passed:
	LDR R7, R0, GOOD
	NOP
	NOP
	NOP
	NOP										;end cache line 3
	NOP										;cache line 4 address 0x0040
	BRnzp Passed
	NOP
	NOP
	NOP
	NOP
	NOP

Failed:
	LDR R7, R0, BAD									;end cache line 4
	NOP										;cache line 5 address 0x0050
	NOP
	NOP
	NOP
	NOP
	BRnzp Failed
	NOP
	NOP										;end cache line 5
	NOP										;cache line 6 address 0x0060
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP										;end cache line 6
	NOP										;cache line 7 address 0x0070
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP										;end cache line 7
	NOP										;cache line 8 address 0x0080
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP										;end cache line 8
	NOP										;cache line 9 address 0x0090
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP										;end cache line 9
	NOP										;cache line 10 address 0x00A0
	NOP
	NOP
DataE : DATA2 4xEEFF
DataF :	DATA2 4xFFEE
	NOP
	NOP
	NOP										;end cache line 10
	NOP										;cache line 11 address 0x00B0
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP										;end cache line 11
	NOP										;cache line 12 address 0x00C0
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP										;end cache line 12
	NOP										;cache line 13 address 0x00D0
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP										;end cache line 13
	NOP										;cache line 14 address 0x00E0
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP										;end cache line 14
	NOP										;cache line 15 address 0x00F0
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP										;end cache line 15
	NOP										;cache line 16 address 0x0100
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP										;end cache line 16
	NOP										;cache line 17 address 0x0110
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP										;end cache line 17
	NOP										;cache line 18 address 0x0120
	NOP
	NOP
DataA : DATA2 4xAABB
DataB : DATA2 4xBBAA
	NOP
	NOP
	NOP										;end cache line 18
	NOP
	NOP
	NOP
