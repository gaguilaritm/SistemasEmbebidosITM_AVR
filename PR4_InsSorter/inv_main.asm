;	PR4_InsSorter
;	Ordenar valores encontrados en memoria de forma ascendente y
;	descendente en direcciones de memoria alineados al siguiente 
;	numero de direcciones disponibles dadas la cantidad de elementos.

.include	"m48def.inc"

.org	0
.cseg

data: 	.DB 1,2,3,4,5,6,7,8,9,10

.equ	N 		= 10
.equ	dataOrg = 0
.equ	dataEnd	= N
.equ	ramOrg	= 0x100


main:
	ldi		XH, HIGH(ramOrg)
	ldi		XL, LOW(ramOrg)
	ldi		ZH, 0
	ldi		ZL, 0
	ldi		r17,N
	ldi		r18,N-1
	ldi		r19,N
init:
	lpm		r16,Z+
	st		X+,r16
	dec		r17
	breq	clean
	rjmp	init
clean:
	ldi		XH, HIGH(ramOrg)
	ldi		XL, LOW(ramOrg)
	ldi		r18,N-1
	dec		r19
	breq	idle	
compare:
	ld		r16,X+
	ld		r17,X
	sbiw	XL,1
	cp		r17,r16
	brlo	store
change:
	eor		r17,r16
	eor		r16,r17
	eor		r17,r16
store:
	st		X+,r16
	st		X,r17
	dec		r18
	breq	clean
	rjmp 	compare	
idle:
	nop
	rjmp	idle
