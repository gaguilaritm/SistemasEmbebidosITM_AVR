;
; PR3_1sCounter.asm
;
; Created: 11/09/2017 02:31:12 p. m.
; Author : Gabriel
;
; char const SEGDISP[10] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F,0x77,0x7c,0x39,0x5e,0x79,0x73};

.include "m48def.inc"

.org	0x00
.equ	segPtr =	0x100


init:
	ser		r16
	out		DDRB, r16
;	out	    PORTB, r17

	ldi		YL, LOW(segPtr)
	ldi		YH, HIGH(segPtr)
    ldi     r16, 16


store:
	ldi		r17, 0x3f
	st		Y+, r17
	ldi		r17, 0x06
	st		Y+, r17
	ldi		r17, 0x5b
	st		Y+, r17
	ldi		r17, 0x4f
	st		Y+, r17
	ldi		r17, 0x66
	st		Y+, r17
	ldi		r17, 0x6d
	st		Y+, r17
	ldi		r17, 0x7d
	st		Y+, r17
	ldi		r17, 0x07
	st		Y+, r17
	ldi		r17, 0x7f
	st		Y+, r17
	ldi		r17, 0x6f
	st		Y+, r17
	ldi		r17, 0x77
	st		Y+, r17
	ldi		r17, 0x7c
	st		Y+, r17
	ldi		r17, 0x39
	st		Y+, r17
	ldi		r17, 0x5e
	st		Y+, r17
	ldi		r17, 0x79
	st		Y+, r17
	ldi		r17, 0x71
	st		Y+, r17
	ldi		r17, 67
	st		Y+, r17
	ldi		r17, 65
	st		Y+, r17
	ldi		r17, 67
	st		Y+, r17
	ldi		r17, 65
	st		Y+, r17
	ldi		YL, LOW(segPtr)
	ldi		YH, HIGH(segPtr)
	
cuenta:
	ld		r17, Y+
	out		PORTB, r17
	rcall	delay
    dec     r16
	breq	limpiar
	rjmp cuenta

limpiar:
    ldi     r16, 16
	ldi		YL, LOW(segPtr)
	ldi		YH, HIGH(segPtr)
	rjmp	cuenta
	
delay:
	push	r16
	ldi		r16, 10			; 1 ciclo
exterior:
	ldi		XH, HIGH(25000)		; 1 ciclo
	ldi		XL, LOW(25000)		; 1 ciclo
interior:
	sbiw	XL, 1			; 2 ciclos
	brne	interior		; 1/2 ciclos

	dec 	r16			; 1 ciclo
	brne	exterior		; 1/2 ciclos
	pop		r16
	ret
