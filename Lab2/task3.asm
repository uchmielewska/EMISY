DEC_CS      EQU     P0.7               ;pin for Display-select Decoder CS
A0A1_BUS    EQU     P3                 ;pin for Display-select Input 0 and Input 1
SEG_BUS     EQU     P1                 ;segment bus

;4 last digits in my index numebr: 0167


	mov	R0, #000000001b		;set first from the left display at the beginning
	setb    DEC_CS              		;enable decoder

	jmp     skip_handler            	;skip interrupt handler


	ORG     0Bh                		;timer overflow interrupt handler
		
	mov	ACC, R0			;load current R0 value to accumulator 
	jb	ACC.0, display0		;check 0'th bit - first from the left display
	jb	ACC.1, display1		;check 1'st bit - second from the left display
	jb	ACC.2, display2		;check 2'nd bit - third from the left display
	jb	ACC.3, display3		;check 3'rd bit - fourth from the left display


	skip_handler:     
		setb    TR0                 	;turn T0 by setting it to 1
		mov	TMOD, #01h		;set Timer0 to mode 1
		setb    ET0                 	;ET0 set to 1 enables Timer0 Interrupt Bit
		setb    EA                  	;turn on global interrupt
		
		mov	TH0, #0B1h		;setting timer interval to 20ms - upper half
		mov	TL0, #0DFh		;setting timer interval to 20ms - lower half
		jmp     $
		
		
		
	display0:
		mov	R0, #00000010b			;load value which denoted display1
			
		mov	A0A1_BUS, #3			;first from the left display
		mov	SEG_BUS, #11000000b		;display "0"
		
		mov     TH0, #0B1h          		;reset timer - upper half
		mov     TL0, #0DFh			;reset timer - lower half
		
		reti
	
	display1:
		mov	R0, #00000100b			;load value which denoted display2
	
		mov	A0A1_BUS, #2			;second from the left display
		mov	SEG_BUS, #11111001b		;display "1"
	
		mov     TH0, #0B1h          		;reset timer - upper half
		mov     TL0, #0DFh			;reset timer - lower half
	
		reti
		
	display2:
		mov	R0, #00001000b			;load value which denoted display3
		
		mov	A0A1_BUS, #1			;third from the left display
		mov	SEG_BUS, #10000010b		;display "6"
		
		mov     TH0, #0B1h          		;reset timer - upper half
		mov     TL0, #0DFh			;reset timer - lower half
		
		reti
		
	display3:
		mov	R0, #000000001b		;load value which denoted display0
	
		mov	A0A1_BUS, #0			;fourth from the left display
		mov	SEG_BUS, #111111000b		;display "7"
	
		mov     TH0, #0B1h          		;reset timer - upper half
		mov     TL0, #0DFh			;reset timer - lower half
	
		reti
