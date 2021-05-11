DEC_CS      EQU     P0.7               ;pin for Display-select Decoder CS
A0A1_BUS    EQU     P3                 ;pin for Display-select Input 0 and Input 1
SEG_BUS     EQU     P1                 ;segment bus


	jmp     skip_handler            	;skip interrupt handler

	ORG     0Bh                		;timer overflow interrupt handler
	
	mov     A0A1_BUS, #3			;display digit on the first place from the left
	
	mov	A, SEG_BUS			;load register A with segment bits
	xrl	A, #4h				;xor operation with segment bits vs #00000100
	mov	SEG_BUS, A			;only one segment bit will be changed (to 1 and 0 alternatively)
	
	setb    DEC_CS              		;enable decoder
		    
	mov     TH0, #0B1h          		;reset timer - upper half
	mov     TL0, #0DFh			;reset timer - lower half
	reti					;return


	skip_handler:     
		setb    TR0                 	;turn T0 by setting it to 1
		mov	TMOD, #01h		;set Timer0 to mode 1
		setb    ET0                 	;ET0 set to 1 enables Timer0 Interrupt Bit
		setb    EA                  	;turn on global interrupt
		
		mov	TH0, #0B1h		;setting timer interval to 20ms - upper half
		mov	TL0, #0DFh		;setting timer interval to 20ms - lower half

		jmp     $
