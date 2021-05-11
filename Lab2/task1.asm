DEC_CS      EQU     P0.7                ;pin for Display-select Decoder CS
A0A1_BUS    EQU     P3                  ;pin for Display-select Input 0 and Input 1
SEG_BUS     EQU     P1                  ;segment bus

clr	DEC_CS					        ;clear Chip Select
mov	SEG_BUS, #11111111b			;set to 1 all segment pins (then nothing is on the display)

mov	R0, #3					        ;display digit on the first place from the left
mov	R1, #10100100b				  ;load binary number which will display number "2" on the display

lcall	display

jmp	$

	display:
		mov	A0A1_BUS, R0		    ;set A0 and A1 to 1 (it will display on the first from the left position)
		
		mov	SEG_BUS, R1		      ;set segment busses in a way to display "2"
		
		setb	DEC_CS			      ;set Chip Select to 1 to enable decoder
