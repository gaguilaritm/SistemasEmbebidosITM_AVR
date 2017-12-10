; PR3_1sDelay
; Delay creado por ciclos anidados, a 1 us por instrucción
; Utilizando el puntero X como un contador 

delay:
	ldi	r16, 10			; 1 ciclo
exterior:
	ldi	XH, HIGH(10)		; 1 ciclo
	ldi	XL, LOW(10)		; 1 ciclo
interior:
	sbiw	XL, 1			; 2 ciclos
	brne	interior		; 1/2 ciclos

	dec 	r16			; 1 ciclo
	brne	exterior		; 1/2 ciclos

	ret
