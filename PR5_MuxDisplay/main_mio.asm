; PR5_MuxDisplay.
; Mostrar letras en un display de 7 segmentos multiplexado de 4 displays.
.include "m328Pdef.inc"
.equ 	DISPORG		= 0x0040
.equ	DELAYCNTS	= 100
;.equ	LETRAS		= 

.equ 	DISPLAYS	= 4 + 1
.equ	LETRAS		= 22
.org	DISPORG
.cseg	

sentenceIn:  .db 0x39,0x77,0x39,0x77,0,0x39,0x3E,0x38,0x3F,0,0x73,0x79,0x5E,0x3F,0,0x73,0x06,0x73,0x06,0,0,0,
caca:	     .db 0x39,0x77,0x39,0x77

.org 	0
main:
	ldi	r16,0xFF			; inicializar puertos
	out	DDRB,r16
	out	DDRD,r16
	ldi	r21,HIGH(DISPORG*2)
	ldi	r20,LOW(DISPORG*2)
	ldi	r22,0
loop:
	rcall	loop_disp
	inc	r20
	cpi	r20,LOW(DISPORG*2+LETRAS)
	breq	main
	rjmp	loop

;--- funcion loop disp*255
loop_disp:
	push	r16
	ldi	r16,0x00
	ldi	YH,0x00
	ldi	YL,0x7F	
in_loop:
	rcall	show
	sbiw	YL,1
	brne	in_loop
	pop	r16
	ret
;----- FUNCION PARA MOSTRAR LAS 4 LOCALIDADES ADJACENTES QUE
;	APUNTAN r20:r21
show:
	mov	ZH,r21
	mov	ZL,r20
	ldi	r16,DISPLAYS
	ldi	r18,0x01
display:
	lpm	r17, Z+
	mov	r19,r18
	com	r19
	out	PORTD,r22
	out	PORTB,r19
	out	PORTD,r17
	lsl	r18
	rcall 	delay
	dec	r16
	brne	display	
	ret

; ----- FUNCION DE RETRASO (MENTAL)
delay:
	push	r16
	ldi	r16, 10			; 1 ciclo
exterior:
	ldi	XH, HIGH(DELAYCNTS)	; 1 ciclo
	ldi	XL, LOW(DELAYCNTS)	; 1 ciclo
interior:
	sbiw	XL, 1			; 2 ciclos
	brne	interior		; 1/2 ciclos
	dec 	r16			; 1 ciclo
	brne	exterior		; 1/2 ciclos
	pop	r16
	ret
