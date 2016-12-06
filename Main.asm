; Main.asm
; Continuously reads from x2600 making sure its not reading duplicate
; symbols. Processes the symbol based on the program description
; of mRNA processing.
		.ORIG x4000

; initialize the stack pointer
		LD	R6, STACK

; set up the keyboard interrupt vector table entry
		LD	R0, ISR1
		STI	R0, INTERRUPT
		AND	R0, R0, #0
		STI	R0, CHAR

; enable keyboard interrupts
		LDI	R0, KBSR
		LD	R1, ADDVALUE
		AND	R0, R0, #0
		ADD	R0, R0, R1
		STI	R0, KBSR

; start of actual program
StartOver	AND	R0, R0, #0
		STI	R0, CHAR	; Clear x2600
Wait4A		LDI	R0, CHAR	; Poll x2600 for 
		BRz	Wait4A		; new symbol
		OUT			; Print Base
MaybeA		LD	R1, A
		ADD	R1, R1, R0
		BRnp	StartOver

; Here means A read
		STI	R1, CHAR	; Clear x2600
Wait4U		LDI	R0, CHAR	; poll x2600 for
		BRz	Wait4U		; new symbol
		OUT
MaybeU		LD	R1, U
		ADD	R1, R1, R0
		BRnp	MaybeA
		STI	R1, CHAR

; Here means U read
		STI	R1, CHAR	; Clear x2600
Wait4G		LDI	R0, CHAR	; Poll x2600 for
		BRz	Wait4G		; new symbol
		OUT
MaybeG		LD	R1, G
		ADD	R1, R1, R0
		BRnp	MaybeA
		STI	R1, CHAR

; Reached the end of a start codon
		LD	R0, PIPE
		OUT
		
Loop		AND	R1, R1, #0
						
		STI 	R1, CHAR
Wait4Char	LDI	R0, CHAR
		BRz	Wait4Char		
		OUT

IsU		LD	R1, U
		ADD	R1, R1, R0
		BRnp	Loop			
		STI	R1, CHAR
WAIT		LDI	R0, CHAR		
		BRz	WAIT
		OUT
		
		LD	R1, C
		ADD	R1, R1, R0
		BRz	Loop
		
		LD	R1, G
		ADD	R1, R1, R0
		BRz	IsG

		LD	R1, A
		ADD 	R1, R1, R0
		BRnp	IsU

		STI	R1, CHAR
WAIT1		LDI	R0, CHAR
		BRz	WAIT1
		OUT
		
		LD	R1, G
		ADD	R1, R1, R0
		BRz 	DONE
			
		LD	R1, A
		ADD 	R1, R1, R0
		BRz	DONE

		LD	R1, C
		ADD	R1, R1, R0
		BRz 	Loop
		BRnp	IsU

IsG		STI	R1, CHAR
WAIT2		LDI	R0, CHAR
		BRz	WAIT2
		OUT
		
		LD	R1, A
		ADD	R1, R1, R0
		BRz	DONE
		
		LD	R1, C
		ADD	R1, R1, R0
		BRz 	Loop
		
		LD	R1, G
		ADD	R1, R1, R0
		BRz	Loop
		
		BRnzp 	IsU
		
DONE		
		HALT
STACK		.FILL	x4000
ISR1		.FILL	X2000
INTERRUPT	.FILL	X0180
KBSR		.FILL 	XFE00
ADDVALUE	.FILL	X4000
CHAR		.FILL	X2600
A		.FILL	-65
U		.FILL	-85
G		.FILL	-71
C		.FILL	-67
PIPE		.FILL	x007C

		.END
