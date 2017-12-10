; PR2_8bitDivider.asm
; 04/09/2017 9:45 AM
; Dividir el valor encontrado en 2 puertos del ATmega48 y guardar el valor en RAM

; Vale 100% hasta el miercoles

.org	0

.equ	tmp  =	r16
.equ	  a  =	r17
.equ	  b  =	r18
.equ    res  =	0x100

.equ opaddr  =	DDRB
.equ  opain  =  PINB
.equ opaout  =  PORTB

.equ opbddr  =	DDRD
.equ  opbin  =   PIND
.equ opbout  =   PORTD

; Port initialization

init:
	clr	tmp		; limpia la variable temporal
	out 	opaddr, tmp	; configura el puerto b como entrada
	out	opbddr, tmp	; configura el puerto d como entrada
	ser 	tmp
	out	opaout, tmp
	out	opbout, tmp

loop:
	in	opain, a
	in	opbin, b
div:
	sub	a, b
	cp	a, b
	breq    final
	brmi	final
	inc	tmp
	rjmp	div
final:
	sts	tmp, res
	rjmp 	idle
	;algo
idle:
	nop
	rjmp idle	
