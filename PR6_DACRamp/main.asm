.include "m328Pdef.inc"
.equ	PERIOD	=	16			; En milisegundos
.equ	FREQUENCY  =	60			; Hertz
.equ	DELAYCNTS=	PERIOD*(25000)/1000	; Cuentas para dicho periodo

.org	0
main:
	ldi	r16,0xFF
	out	DDRB,r16
	clr	r16
	out	PORTB,r16
loop:
	inc	r16
	out	PORTB,r16
	rcall	delay
	rjmp	loop

;	Funcion de retraso
delay:
	push	r16
	ldi	r16,1
exterior:
	ldi	XH,HIGH(1000)
	ldi	XL,LOW(1000)
interior:
	sbiw	XL,1
	brne	interior
	dec	r16
	brne	exterior
	pop	r16
	
	ret

