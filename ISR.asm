; ISR.asm
; Name: Sangcheol Kim
; UTEid: sk43688
; Keyboard ISR runs when a key is struck
; Checks for a valid RNA symbol and places it at x2600
	.ORIG x2000	
	ST R0, SR0
	ST R1, SR1	
	LDI R0, KBDR
; check if valid and then write to x2600
	LD R1, NegA
	ADD R1, R1, R0
	BRz Valid
	LD R1, NegC
	ADD R1, R1, R0
	BRz Valid
	LD R1, NegG
	ADD R1, R1, R0
	BRz Valid
	LD R1, NegU
	ADD R1, R1, R0
	BRz Valid
	BRnzp Invalid
Valid	STI R0, Glob
Invalid	LD R0, SR0
	LD R1, SR1
	RTI 
KBDR	.Fill xFE02
Glob	.Fill x2600
NegA	.Fill -65
NegC	.Fill -67
NegG	.Fill -71
NegU	.Fill -85
SR0	.BLKW 1
SR1	.BLKW 1
	.END
