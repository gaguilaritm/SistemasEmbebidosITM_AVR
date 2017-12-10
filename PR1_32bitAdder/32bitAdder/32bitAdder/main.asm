;
; 32bitAdder.asm
;
; Created: 29/08/2017 08:59:21 p.m.
; Author : Gabriel
;
.org 0

	ldi		XH, 0x01
	ldi		XL, 0x04
	ldi		YH, 0x01
	ldi		YL, 0x08
	ldi		ZH, 0x01
	ldi		ZL, 0x0c

	ldi		r18, 4
	ldi		r19, 0

ciclo_suma:
	ld		r16, -X
	ld		r17, -Y
	add		r16, r17
	st		-Z, r16
	brcs	hay_carry
cont:
	dec		r18
	breq	fin
	rjmp	ciclo_suma
hay_carry:
	dec		XL
	inc		r19
	ld		r16, X
	inc		r16
	breq	hay_carry
	st		X, r16
	add		XL, r19
	clr		r19
	rjmp cont
fin:
	nop
	rjmp	fin
	
