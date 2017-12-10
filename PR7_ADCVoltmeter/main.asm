; PR7_ADCVoltmeter
.include "m328Pdef.inc"
.org	0x80
.cseg
digitos: .db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F,0x77,0x7c,0x39,0x5e,0x79,0x73 
; Peripheral initialization 
.org 0x0
init:
	ldi	r16,HIGH(RAMEND)
	out	SPH,r16
	ldi	r16,LOW(RAMEND)
	out	SPL,r16
	ser	r16
	out	DDRB,r16			; I/O Ports init
	out	DDRD,r16
	ldi	r16, (1 << REFS0) | (1 << ADLAR) 		; ADC init, ADC0,Avcc
	sts	ADMUX,r16
	ldi	r16, 1 << ADEN | 1 << ADSC | 1 << ADATE | 1 << ADIE  
	sts 	ADCSRA,r16
	ldi	r17,1
loop:
	; mostrar conversion
	ldi	r16,1 << ADEN | 1 << ADSC | 1 << ADATE | 1 << ADIF
	sts	ADCSRA,r16
	lds	r19,ADCH
	tst	r19
	breq	loop
	mul	r19,r17
	rcall 	mostrar
mostrar:
	push 	r16
	push	r17
	movw	r27:r26,r1:r0
	clr	r16
	clr	r17
	ldi	r21,0xF7
	ldi	ZH,HIGH(0x100)
	ldi	ZL,LOW(0x100)
	rcall	div
	add	ZL,r18
	lpm	r17,Z
	out	PORTD,r17
	out	PORTB,r21
	rcall	delay
	ldi	ZH,HIGH(0x100)
	ldi	ZL,LOW(0x100)
	ldi	r21,0xFB
	rcall	div
	add	ZL,r18
	lpm	r17,Z
	ori	r17,0x80
	out	PORTD,r17
	out	PORTB,r21
	rcall	delay
	ldi	ZH,HIGH(0x100)
	ldi	ZL,LOW(0x100)
	ldi	r21,0xFD
	rcall	div
	add	ZL,r18
	lpm	r17,Z
 	out	PORTD,r17
	out	PORTB,r21
	rcall	delay
	ldi	ZH,HIGH(0x100)
	ldi	ZL,LOW(0x100)
	ldi	r21,0xFE
	rcall	div
	add	ZL,r18
	lpm	r17,Z
	out	PORTD,r17
	out	PORTB,r21
	rcall	delay
	pop	r16
	pop	r17
	ret
div:
	push	r16
	push	r17
	clr	r16
	clr	r17
divi:
	cpi	r26,10
	brlo	menor
	subi	r26,10
	inc	r16
	brvs	inc_resH
	rjmp	divi
inc_resH:
	inc	r17
	rjmp	divi
menor:
	tst	r27
	breq	final
	inc	r16
	subi	r26,10
	dec	r27
	rjmp	divi
final:
	mov	r18,r26
	movw	r27:r26,r17:r16
	pop	r16
	pop	r17
	ret

; ----- FUNCION DE RETRASO (MENTAL)
delay:
	push	r16
	ldi	r16, 10			; 1 ciclo
exterior:
	ldi	YH, HIGH(0xFF)	; 1 ciclo
	ldi	YL, LOW(0xFF)	; 1 ciclo
interior:
	sbiw	YL, 1			; 2 ciclos
	brne	interior		; 1/2 ciclos
	dec 	r16			; 1 ciclo
	brne	exterior		; 1/2 ciclos
	pop	r16
	ret

