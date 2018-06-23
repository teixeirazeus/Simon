	list p=16f887

	org 0x00
	goto ini
	
	org 0x04
	goto inter

ini:	; BEGIN BIOS
		; PA
		; BIT 	BOTAO
		; 0  	00
		; 1		01
		; 2		10
		; 3 	11

		;PB
		;BIT 	LED
		;0		BOTAO START
		;1		00
		;2		01
		;3		10
		;4 		11		

		bcf 	0x03,6
		bsf 	0x03,5 	; BANCO 1

		movlw 	0x0f	; 0000 1111
		movwf 	0x85	; TRIS A
		movlw 	0x01	; 0000 0001
		movwf 	0x86 	; TRIS B
		clrf 	0x87 	; TRIS C
		clrf 	0x88	; TRIS D
		clrf 	0x89	; TRIS E
		
		movlw	0x01	; 0000 0001
		movwf	0x8c	; PIE1
		
		bcf 	0x03,6
		bcf 	0x03,5 	; BANCO 0
		
		clrf 	0x05	; PORT A
		clrf 	0x06	; PORT B
		clrf 	0x07	; PORT C
		clrf 	0x08	; PORT D
		clrf 	0x09	; PORT E
		
		clrf 	0x0c	; PIR1
		
		movlw 	0x00
		movwf 	0x0f	; TMR1H
		movlw 	0x00
		movwf 	0x0e	; TMR1L

		movlw 	0xd0	; 1101 0000
		movwf 	0x0b	; INTCON
		
		;Pre Escala 1:1
		movlw	0x01	; xx00 0001 
		movwf 	0x10	; T1CON
		
		; END BIOS

inter:	bcf 	0x0b,1 	; Apaga a flag INT EXT. -> RB0 (0x06,0)
	
		retfie
		
	end
