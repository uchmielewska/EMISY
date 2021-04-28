;set variables
LCD_RS EQU P3.0	;RS pin connected to P3.0
LCD_E EQU P3.1		;E pin connected to P3.1
LCD_BUS EQU P1		;Data bus takes pins from P1.0 to P1.7

;wait for more than 30ms
mov	R2, #20
	delay_30:
		lcall	ms_delay
		djnz	R2, delay_30

mov	LCD_BUS, #00100000B			;function set - setting to 4 bits mode
lcall	write_command	
lcall	us_delay
lcall	write_command				;function set - sending 4 most significant bits

mov	LCD_BUS, #10000000B			;function set - sending 4 least significant bits
lcall	write_command	
lcall	us_delay


mov	LCD_BUS, #00000000B			;display ON/OFF control - sending 4 most significant bits
lcall 	write_command

mov	LCD_BUS, #11000000B			;display ON/OFF control - sending 4 least significant bits
lcall 	write_command
lcall	us_delay


mov	LCD_BUS, #00000000B			;display clear - sending 4 most significant bits
lcall	write_command

mov	LCD_BUS, #00010000B			;display clear - sending 4 least significant bits
lcall	write_command
lcall	ms_delay


mov	LCD_BUS, #00000000B			;entry mode set - sending 4 most significant bits
lcall	write_command

mov	LCD_BUS, #01100000B			;entry mode set - sending 4 least significant bits
lcall	write_command
lcall	us_delay


;end initialization
mov	LCD_BUS, #01010000B			;sending 4 most significant bits of letter 'U'
lcall	write_data

mov	LCD_BUS, #01010000B			;sending 4 least significant bits of letter 'U'
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
