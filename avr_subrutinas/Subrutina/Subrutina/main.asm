;
; Subrutina.asm
; rutina de retraso 1 s.
;
; Created: 08/09/2017 02:22:14 p. m.


; macro, con argumentos
.macro 	sumaR16
	ldi	r16, @0		; @0 es 5
	ldi	r17, @1		; @1 es 3
	adc	r16, r17
.endmacro
.org	0

; inclusion de macros desde archivo
.include "./macro.h"

ciclo:
	nop
	nop
	sumaR16 5, 3		; cada argumento viene del numero de indice
	rjmp	ciclo
