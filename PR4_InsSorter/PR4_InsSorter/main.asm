;	PR4_InsSorter
;	Ordenar valores encontrados en memoria de forma ascendente y
;	descendente en direcciones de memoria alineados al siguiente 
;	numero de direcciones disponibles dadas la cantidad de elementos.

;.include	"m48def.inc"

.org	0
.cseg
data: 	.DB 3,4,2,7,8,1,9,5

.equ	N 		= 8
.equ	dataOrg = 0
.equ	dataEnd	= N
.equ	ramOrg	= 0x100
.def	tmp		= r17
.def	key		= r18
main:
	ldi		XH, HIGH(ramOrg)
	ldi		XL, LOW(ramOrg)
	ldi		ZH, 0
	ldi		ZL, 0
	ldi		tmp,N

init:
	lpm		r16,Z+
	st		X+,r16
	dec		tmp
	breq	sort
	rjmp	init
sort:
	ld		tmp, X+
	ld		tmp, X+
	rjmp	sort