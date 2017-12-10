	.file	"insert_sort.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.section	.rodata
.LC0:
	.word	3
	.word	34
	.word	333
	.word	34
	.word	53
	.word	31
	.text
.global	main
	.type	main, @function
main:
	push r28
	push r29
	in r28,__SP_L__
	in r29,__SP_H__
	sbiw r28,18
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 18 */
/* stack size = 20 */
.L__stack_usage = 20
	ldi r24,lo8(12)
	ldi r30,lo8(.LC0)
	ldi r31,hi8(.LC0)
	mov r26,r28
	mov r27,r29
	adiw r26,7
	0:
	ld r0,Z+
	st X+,r0
	dec r24
	brne 0b
	ldi r24,lo8(1)
	ldi r25,0
	std Y+4,r25
	std Y+3,r24
	rjmp .L2
.L6:
	ldd r24,Y+3
	ldd r25,Y+4
	lsl r24
	rol r25
	mov r18,r28
	mov r19,r29
	subi r18,-1
	sbci r19,-1
	add r24,r18
	adc r25,r19
	adiw r24,6
	mov r30,r24
	mov r31,r25
	ld r24,Z
	ldd r25,Z+1
	std Y+6,r25
	std Y+5,r24
	ldd r24,Y+3
	ldd r25,Y+4
	sbiw r24,1
	std Y+2,r25
	std Y+1,r24
	rjmp .L3
.L5:
	ldd r24,Y+1
	ldd r25,Y+2
	adiw r24,1
	ldd r18,Y+1
	ldd r19,Y+2
	lsl r18
	rol r19
	mov r20,r28
	mov r21,r29
	subi r20,-1
	sbci r21,-1
	add r18,r20
	adc r19,r21
	subi r18,-6
	sbci r19,-1
	mov r30,r18
	mov r31,r19
	ld r18,Z
	ldd r19,Z+1
	lsl r24
	rol r25
	mov r20,r28
	mov r21,r29
	subi r20,-1
	sbci r21,-1
	add r24,r20
	adc r25,r21
	adiw r24,6
	mov r30,r24
	mov r31,r25
	std Z+1,r19
	st Z,r18
	ldd r24,Y+1
	ldd r25,Y+2
	sbiw r24,1
	std Y+2,r25
	std Y+1,r24
.L3:
	ldd r24,Y+1
	ldd r25,Y+2
	cp __zero_reg__,r24
	cpc __zero_reg__,r25
	brge .L4
	ldd r24,Y+1
	ldd r25,Y+2
	lsl r24
	rol r25
	mov r18,r28
	mov r19,r29
	subi r18,-1
	sbci r19,-1
	add r24,r18
	adc r25,r19
	adiw r24,6
	mov r30,r24
	mov r31,r25
	ld r18,Z
	ldd r19,Z+1
	ldd r24,Y+5
	ldd r25,Y+6
	cp r24,r18
	cpc r25,r19
	brlt .L5
.L4:
	ldd r24,Y+1
	ldd r25,Y+2
	adiw r24,1
	lsl r24
	rol r25
	mov r18,r28
	mov r19,r29
	subi r18,-1
	sbci r19,-1
	add r24,r18
	adc r25,r19
	adiw r24,6
	ldd r18,Y+5
	ldd r19,Y+6
	mov r30,r24
	mov r31,r25
	std Z+1,r19
	st Z,r18
	ldd r24,Y+3
	ldd r25,Y+4
	adiw r24,1
	std Y+4,r25
	std Y+3,r24
.L2:
	ldd r24,Y+3
	ldd r25,Y+4
	sbiw r24,7
	brge .+2
	rjmp .L6
	ldi r24,0
	ldi r25,0
/* epilogue start */
	adiw r28,18
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	pop r29
	pop r28
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 4.9.2"
.global __do_copy_data
