LCD_RS EQU P3.0	;RS pin connected to P3.0
LCD_E EQU P3.1		;E pin connected to P3.1
LCD_BUS EQU P1		;Data bus takes pins from P1.0 to P1.7
SWITCH EQU P2.5	;switch five

;wait for more than 30ms
mov	R2, #20
	delay_30:
		lcall	ms_delay
		djnz	R2, delay_30

clr	LCD_RS

mov	LCD_BUS, #00111000B			;function set
lcall	write_command	
lcall	us_delay

mov	LCD_BUS, #00001110B			;display ON/OFF control
lcall 	write_command
lcall	us_delay

mov	LCD_BUS, #00000110B			;entry mode set
lcall	write_command
lcall	us_delay

switch_control:
	mov	LCD_BUS, #00000001B		;display clear
	lcall	write_command
	lcall	ms_delay
	jb	SWITCH, $			;waits for the switch to be pressed (if switch is 1-not pressed, routine jumps to itself)

	;send name
	mov	LCD_BUS, #'U'
	lcall	write_data
	lcall	us_delay

	mov	LCD_BUS, #'R'
	lcall	write_data
	lcall	us_delay

	mov	LCD_BUS, #'S'
	lcall	write_data
	lcall	us_delay

	mov	LCD_BUS, #'Z'
	lcall	write_data
	lcall	us_delay

	mov	LCD_BUS, #'U'
	lcall	write_data
	lcall	us_delay

	mov	LCD_BUS, #'L'
	lcall	write_data
	lcall	us_delay

	mov	LCD_BUS, #'A'
	lcall	write_data
	lcall	us_delay

	jnb	SWITCH, $			;waits for the switch to be turned off
	lcall	switch_control			;call function which waits for pressed button


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
