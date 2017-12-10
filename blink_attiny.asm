.include "tn2313def.inc"

.org 0

rjmp main

main:
    ldi     r16,    0xff    
    out     DDRB,   r16
    out     PORTB,  r16
setup:
    ldi     r16,    0xff
loop:
    dec     r16
    breq    setup
    rjmp    loop

