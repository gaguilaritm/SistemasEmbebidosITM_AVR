.org 	0
.include "m328Pdef.inc"
.equ DELAYCNTS = 25000
init:
	ser	r16
	out	DDRB,r16
	out	PORTB,r16
	ldi	r17,0x20
loop:
	eor	r16,r17
	out	PORTB,r16
	rcall 	delay
	rjmp	loop
delay:
        push    r16
        ldi     r16, 100                 ; 1 ciclo
exterior:
        ldi     XH, HIGH(DELAYCNTS)             ; 1 ciclo
        ldi     XL, LOW(DELAYCNTS)              ; 1 ciclo
interior:
        sbiw    XL, 1                   ; 2 ciclos
        brne    interior                ; 1/2 ciclos

        dec     r16                     ; 1 ciclo
        brne    exterior                ; 1/2 ciclos
        pop     r16
        ret
