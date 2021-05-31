LED EQU P1.0		;first LED from the right will be turned on/off
KEYPAD EQU P0		;keyboard row pins take from P0.0 uo to P0.3

jmp	begin		    ;skip interrupt handler to the beginning routine

org	0013h		    ;write to specified place in the memory
cpl	LED		      ;logically complements a given bit
reti

begin:
	setb	EA			;enable global interrupt
	setb	EX1			;enable INT1 interrupt
	setb	IT1			;set INT1 to work with falling edge

	mov	KEYPAD, #01110000B	  ;clear all keyboard row bits
	jmp	$			    ;waiting for the interrupt
