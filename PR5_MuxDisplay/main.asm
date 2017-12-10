.include "m48def.inc"
.equ letrero1A=0xF6
.equ letrero1B=0x3F
.equ letrero1C=0x38
.equ letrero1D=0x77

.equ letrero2A=0xF3
.equ letrero2B=0x79
.equ letrero2C=0xF3
.equ letrero2D=0x79

.equ letrero3A=0xF3
.equ letrero3B=0x06
.equ letrero3C=0x39
.equ letrero3D=0x77

.equ letrero4A=0xF3
.equ letrero4B=0x77
.equ letrero4C=0xF3
.equ letrero4D=0x77

.equ disp1=0xFE
.equ disp2=0xFD
.equ disp3=0xFB
.equ disp4=0xF7

.equ N=255
.equ P=255
.equ U=5

.macro delay

    ldi r18,U
    rep1:
    ;1+1*N+2(N-1)+1
	
	    ldi r17,P
	rep2: 
        ldi r16,N ; 1
       rep: dec r16; 1*N
	   brne rep ; 2(N-1)+1

	   dec r17
	   brne rep2

	   dec r18
	   brne rep1
	  	   
.endmacro


ldi r16,0xFF        ;declaracion de entradas
out DDRB,r16        ;declaracion en puerto 16

ldi r17,0xFF
out DDRD,r17
ciclo:

       ldi r21,disp1
	   out PORTB,r21
	   ldi r20,letrero1A
	   out PORTD,r20
	   ldi r21,disp2
	   out PORTB,r21
	   ldi r20,letrero1B
	   out PORTD,r20
	   ldi r21,disp3
	   out PORTB,r21
	   ldi r20,letrero1C
	   out PORTD,r20
	   ldi r21,disp4
	   out PORTB,r21
	   ldi r20,letrero1D
	   out PORTD,r20

 ldi r18,U
    rep1:
    ;1+1*N+2(N-1)+1
	
	    ldi r17,P
	rep2: 
        ldi r16,N ; 1

       rep: dec r16; 1*N
	   ldi r21,disp1
	   out PORTB,r21
	   ldi r20,letrero1A
	   out PORTD,r20
	   ldi r21,disp2
	   out PORTB,r21
	   ldi r20,letrero1B
	   out PORTD,r20
	   ldi r21,disp3
	   out PORTB,r21
	   ldi r20,letrero1C
	   out PORTD,r20
	   ldi r21,disp4
	   out PORTB,r21
	   ldi r20,letrero1D
	   out PORTD,r20
	   brne rep ; 2(N-1)+1

	   dec r17
	   brne rep2

	   dec r18
	   brne rep1

;--------------------------------
 ldi r18,U
    rep1b:
    ;1+1*N+2(N-1)+1
	
	    ldi r17,P
	rep2b: 
        ldi r16,N ; 1

       repb: dec r16; 1*N
	   ldi r20,letrero2A
	   ldi r21,disp1
	   out PORTB,r21
	   out PORTD,r20
	   ldi r20,letrero2B
	   ldi r21,disp2
	   out PORTB,r21
	   out PORTD,r20
	   ldi r20,letrero2C
	   ldi r21,disp3
	   out PORTB,r21
	   out PORTD,r20
	   ldi r20,letrero2D
	   ldi r21,disp4
	   out PORTB,r21
	   out PORTD,r20
	   brne repb ; 2(N-1)+1

	   dec r17
	   brne rep2b

	   dec r18
	   brne rep1b

	   ;-------------------------
	    ldi r18,U
    rep1c:
    ;1+1*N+2(N-1)+1
	
	    ldi r17,P
	rep2c: 
        ldi r16,N ; 1

       repc: dec r16; 1*N
	   ldi r20,letrero3A
	   ldi r21,disp1
	   out PORTB,r21
	   out PORTD,r20
	   ldi r20,letrero3B
	   ldi r21,disp2
	   out PORTB,r21
	   out PORTD,r20
	   ldi r20,letrero3C
	   ldi r21,disp3
	   out PORTB,r21
	   out PORTD,r20
	   ldi r20,letrero3D
	   ldi r21,disp4
	   out PORTB,r21
	   out PORTD,r20
	   brne repc ; 2(N-1)+1

	   dec r17
	   brne rep2c

	   dec r18
	   brne rep1c

	   ;-----------------------------

	    ldi r18,U
    rep1d:
    ;1+1*N+2(N-1)+1
	
	    ldi r17,P
	rep2d: 
        ldi r16,N ; 1

       repd: dec r16; 1*N
	   ldi r20,letrero4A
	   ldi r21,disp1
	   out PORTB,r21
	   out PORTD,r20
	   ldi r20,letrero4B
	   ldi r21,disp2
	   out PORTB,r21
	   out PORTD,r20
	   ldi r20,letrero4C
	   ldi r21,disp3
	   out PORTB,r21
	   out PORTD,r20
	   ldi r20,letrero4D
	   ldi r21,disp4
	   out PORTB,r21
	   out PORTD,r20
	   brne repd ; 2(N-1)+1

	   dec r17
	   brne rep2d

	   dec r18
	   brne rep1d


 end: rjmp ciclo
