; PR2_8bitDivider.asm
; 04/09/2017 9:45 AM
; Dividir el valor encontrado en 2 puertos del ATmega48 y guardar el valor en RAM

; Vale 100% hasta el miercoles
.include m328Pdef.inc
;.equ	tmp  =	r16
;.equ     a  =	r17
;.equ	  b  =	r18
.equ    res  =	0x100

.equ opaddr  =	DDRB
.equ  opain  =  PINB
.equ opaout  =  PORTB

.equ opbddr  =	DDRD
.equ  opbin  =   PIND
.equ opbout  =   PORTD

.org	0

; Port initialization

init:
	in		r16, MCUCR		; guardamos el registro de control en r16
	cbr		r16, PUD		; aseguramos que no esten desactivadas las pullup
	out		MCUCR, r16		; guardamos r16 en MCUCR

	ser 	r16				; llenamos r16
	out		opaout, r16		; configuramos las pullup en PORTB
	out		opbout, r16		; configuramos las pullup en PORTD

	clr		r16				; limpia la variable temporal
	out 	opaddr, r16		; configura el puerto b como entrada
	out		opbddr, r16		; configura el puerto d como entrada

div:
	in		r17, PINB		; recibe el valor a en el registro 17
	in		r18, PIND		; recibe el valor b en el registro 18
	cp		r17, r18        ; los compara para checar los casos donde
	brlo	final			; a o b son cero 
	breq	final
loop:
	sub		r17, r18		; restamos b de a
	inc		r16				; incrementamos r16
	cp		r17, r18		; comparamos el residuo con el dividendo
	brlo	final			; si el residuo es menor que el dividendo terminamos
	rjmp	loop			; de otra manera continuamos las restas sucesivas
final:
	sts		0x100, r16		; al terminar guardamos el contador en la dir 0x100
	rjmp 	idle			; terminamos
idle:		
	nop	
	rjmp	idle	
