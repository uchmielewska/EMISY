;set variables
LCD_RS EQU P3.0	;RS pin connected to P3.0
LCD_E EQU P3.1		;E pin connected to P3.1
LCD_BUS EQU P1		;Data bus takes pins from P1.0 to P1.7

;wait for more than 30ms
mov	R2, #20
	delay_30:
		lcall	ms_delay
		djnz	R2, delay_30

mov	LCD_BUS, #00111000B			;function set
lcall	write_command	
lcall	us_delay

mov	LCD_BUS, #00001100B			;display ON/OFF control
lcall 	write_command
lcall	us_delay

mov	LCD_BUS, #00000001B			;display clear
lcall	write_command
lcall	ms_delay

mov	LCD_BUS, #00000110B			;entry mode set
lcall	write_command
lcall	us_delay

;end initialization
mov	LCD_BUS, #'U'				;sending letter 'U'
lcall	write_data
lcall	us_delay

jmp	$					;infinite loop (jumps to itself)


write_command:
	clr	LCD_RS
	setb	LCD_E
	clr	LCD_E
	ret

write_data:
	setb	LCD_RS
	setb	LCD_E
	clr	LCD_E
	ret

us_delay:
	mov	R0, #20			;delay is more than 39us so 20*2 (djnz takes 2us)
	djnz	R0, $				;decrement and jump if R0 reaches 0
	ret					;return from the subroutine
	
ms_delay:					;3*256*2 is more than 1,53ms as expected
	mov 	R1, #3				;load 3 to R1 to make 3 loops
	delay_jump:
		mov 	R0, #255		;256 - value to decrement
		djnz	R0, $			;djnz takes 2 cycles - 2us
		djnz	R1, delay_jump		;decrement R1 and loop if not yet 0
		ret
