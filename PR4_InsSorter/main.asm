;	PR4_BubbleSorter
;	Ordenar valores encontrados en memoria de forma ascendente y
;	descendente en direcciones de memoria alineados al siguiente 
;	numero de direcciones disponibles dadas la cantidad de elementos.

.include	"m48def.inc"
.equ	N 		= 22
.equ	dataOrg 	= 0x0100
.equ	dataEnd		= dataOrg + N
.equ	ramOrg		= 0x100
.equ	ramOrgInv	= 0x100 + N


.org	dataOrg/2
.cseg

data: 	.DB 123,34,51,234,12,5,1,6,7,5,43,231,34,87,32,12,45,67,71,12,43,64

.org 0
.cseg
main:
	ldi		XH, HIGH(ramOrg)
	ldi		XL, LOW(ramOrg)
	ldi		YH, HIGH(ramOrgInv)
	ldi		YL, LOW(ramOrgInv)
	ldi		ZH, HIGH(dataOrg)
	ldi		ZL, LOW(dataOrg)
	ldi		r17,N
	ldi		r18,N-1
	ldi		r19,N
init:
	lpm		r16,Z+
	st		X+,r16
	st		Y+,r16
	dec		r17
	breq		clean
	rjmp		init
clean:
	ldi		XH, HIGH(ramOrg)
	ldi		XL, LOW(ramOrg)
	ldi		r18,N-1
	dec		r19
	breq		inv	
compare:
	ld		r16,X+
	ld		r17,X
	sbiw		XL,1
	cp		r16,r17
	brlo		store
change:
	eor		r16,r17
	eor		r17,r16
	eor		r16,r17
store:
	st		X+,r16
	st		X,r17
	dec		r18
	breq		clean
	rjmp 		compare	
inv:
	ldi		XH, HIGH(ramOrgInv)
	ldi		XL, LOW(ramOrgInv)
	ldi		r18,N-1
	ldi		r19,N
inv_clean:
	ldi		XH, HIGH(ramOrgInv)
	ldi		XL, LOW(ramOrgInv)
	ldi		r18,N-1
	dec		r19
	breq		idle	
inv_compare:
	ld		r16,X+
	ld		r17,X
	sbiw		XL,1
	cp		r17,r16
	brlo		inv_store
inv_change:
	eor		r17,r16
	eor		r16,r17
	eor		r17,r16
inv_store:
	st		X+,r16
	st		X,r17
	dec		r18
	breq		inv_clean
	rjmp 		inv_compare	
idle:
	nop
	rjmp		idle
	

