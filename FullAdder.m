;Boitumelo Chombo 
;########################### Global Declarations ###############################

        .global _wreg_init       ;Provide global scope to _wreg_init routine
                              

        .global __reset        		;The label for the first line of code. 


;############################ Variable declaration #############################   
.bss       ;instructs the assembler to place the following values in data memory
;Reserve two bytes (16 bits) for each variable using the ``.space`` directive.
; uint16_t u16_i;
u16_a:   .space 2
u16_b:   .space 2
u16_c:   .space 2
u16_sum: .space 2
u16_carry: .space 2
 


.text    ;Start of Code section
__reset:
       
; reset all w registers.
        CLR 	W0
        MOV 	W0, W14
        REPEAT 	#12
        MOV 	W0, [++W14]
        CLR 	W14 
;______________________________________________________________________________________________________
	CLR TRISA		  ; set PORT A as output 
	
	MOV #0x0007, W0               ; Configure PORTB<15:3> as outputs
	MOV W0, TRISB               ; and PORTB<2:0> as inputs
	
	
	
Main:
	CLR u16_a
	CLR u16_b
	CLR u16_c

	CLR u16_sum
	
	CLR u16_carry
	
	CLR PORTA
	
	BTSC PORTB,#0			;get pin RB0
	BSET u16_a,#0
	
	BTSC PORTB, #1			;get pin RB1
	BSET u16_b,#0
	
	BTSC PORTB, #2			;get pin RB2
	BSET u16_c,#0
	
; A xor B 
	MOV u16_a,W0
	MOV u16_b,W1
	XOR W0,W1,W2      ;W2= A XOR B
	
; S = (A xor B) xor C
	MOV u16_c,W3
	XOR W2,W3,W4	    
	MOV W4,u16_sum	    ; S=W4

; (A xor B) and C)	
	AND W2,W3,W2
	
; A and B
	AND W0,W1,W0

; CARRY = (A and B) or ((A xor B) and C)
	IOR W0,W2,W0
	MOV W0,u16_carry
	
; write to sum RA0
	BTSC u16_sum,#0
	BSET PORTA,#0
	NOP

; write to carry RA1
	BTSC u16_carry,#0
	BSET PORTA,#1
	NOP
	NOP

goto Main			    ;return to Main

.end




