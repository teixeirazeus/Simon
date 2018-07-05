;Thiago da Silva Teixeira <teixeira.zeus@gmail.com>
;Bruno Hideo Yamasaki Kinno 


list p=16f887

org 0x00
goto bios
endbios
goto main

org 0x04
goto inter

bios:	; BEGIN BIOS
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

movlw 0x06
movwf 0x9f; configuração digital das portas analógicas do PORTA ; ///////////////adcon1
		
		movlw	0x00	; 0000 0000
		movwf	0x8c	; PIE1
		
		bcf 	0x03,6
		bcf 	0x03,5 	; BANCO 0
		
		clrf 	0x05	; PORT A
		clrf 	0x06	; PORT B
		clrf 	0x07	; PORT C
		;clrf 	0x08	; PORT D
		;clrf 	0x09	; PORT E

		clrf 0x20;boleanos
		clrf 0x22;armazenamento do TMR1L
		clrf 0x23;armazenamento do TMR2H
		
		clrf    0x30    ;aux booleana usanda para o piscar do led
	
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
	
		
		goto endbios
		; END BIOS



;Heap indices
;Espelha item i no vetor em 0x26
; se zero deixa como está pois o registrador de retorno está zerado, senão seta o bit correspondente

H0:
	btfsc 0x22, 0
	bsf 0x26, 0
	btfsc 0x22, 1
	bsf 0x26,1

	goto endGetHeap

H1:
	btfsc 0x22, 2
	bsf 0x26, 0
	btfsc 0x22, 3
	bsf 0x26,1

	goto endGetHeap

H2:
	btfsc 0x22, 4
	bsf 0x26, 0
	btfsc 0x22, 5
	bsf 0x26,1

	goto endGetHeap

H3:
	btfsc 0x22, 6
	bsf 0x26, 0
	btfsc 0x22, 7
	bsf 0x26,1

	goto endGetHeap

	;A partir daqui começa o acesso ao registrador alto do vetor

H4:
	btfsc 0x23, 0
	bsf 0x26, 0
	btfsc 0x23, 1
	bsf 0x26,1

	goto endGetHeap

H5:
	btfsc 0x23, 2
	bsf 0x26, 0
	btfsc 0x23, 3
	bsf 0x26,1

	goto endGetHeap

H6:
	btfsc 0x23, 4
	bsf 0x26, 0
	btfsc 0x23, 5
	bsf 0x26,1

	goto endGetHeap

H7:
	btfsc 0x23, 6
	bsf 0x26, 0
	btfsc 0x23, 7
	bsf 0x26,1

	goto endGetHeap

getHeap:
;Função para leitura do vetor formado pelos registradores 0x22 e 0x23
;O registrador 0x25 é o argumento para esta função
; como o exemplo: return vetor[0x25] em C
;0x26 é o retorno
	;0x21 = 0x25, salva o argumento
	movf 0x25, 0
	movwf 0x21

	bsf 0x20, 7;seta verdadeiro o bit7 de 0x20 para usar como jumper	
	
	incf 0x25,1; 0x25++ para quando for zero, 0+1 = 1 entra no decfsz 1-1=0 e entra no H0

	clrf 0x26; limpa o registrador de retorno
	
	decfsz 0x25, 1
	btfss 0x20, 7;jumper
	goto H0

	decfsz 0x25, 1
	btfss 0x20, 7;jumper
	goto H1

	decfsz 0x25, 1
	btfss 0x20, 7;jumper
	goto H2

	decfsz 0x25, 1
	btfss 0x20, 7;jumper
	goto H3

	decfsz 0x25, 1
	btfss 0x20, 7;jumper
	goto H4

	decfsz 0x25, 1
	btfss 0x20, 7;jumper
	goto H5

	decfsz 0x25, 1
	btfss 0x20, 7;jumper
	goto H6
	
	decfsz 0x25, 1
	btfss 0x20, 7;jumper
	goto H7

	endGetHeap

	;retorna argumento como ele entrou na função
	movf 0x21, 0
	movwf 0x25
	return

b00:
;retorna 0 em x28
movlw .0
movwf 0x28
btfsc 0x05, 0;segura botao
goto b00
goto endb


b01:
;retorna 1 em x28
movlw .1
movwf 0x28
btfsc 0x05, 1;segura botao
goto b01
goto endb


b10:
;retorna 2 em x28
movlw .2
movwf 0x28
btfsc 0x05, 2;segura botao
goto b10
goto endb


b11:
;retorna 3 em x28
movlw .3
movwf 0x28
btfsc 0x05, 3;segura botao
goto b11
goto endb


entrada:
	; PA 0x05
		; BIT 	BOTAO
		; 0  	00
		; 1		01
		; 2		10
		; 3 	11
	;retorno em x28
	clrf 0x28

	entradaLoop:
		;Botão 00
		btfsc 0x05, 0
		goto b00
	
		;Botão 01
		btfsc 0x05, 1
		goto b01
	
		;Botão 10
		btfsc 0x05, 2
		goto b10
	
		;Botão 11
		btfsc 0x05, 3
		goto b11
	goto entradaLoop

	endb
	
	return

gameOver:
		bsf     0x06,1
		bsf     0x06,2
		bsf     0x06,3
		bsf     0x06,4
goto gameOver


win:
	call acendeled0	
	call acendeled1	
	call acendeled2	
	call acendeled3	
goto win		


main:
	
	lopstart:
	btfss 0x20, 0; se o botao de start for apertado na primeira vez
	goto lopstart

	;0x24 Nivel do Jogo começa em zero
	clrf 0x24

	loopGame:

		;x27 = 0
		clrf 0x27
		decf 0x27, 1; x27--, correção para o loop bot
		
		bot:
			;Piscar padrão
			incf 0x27, 1; x27++
			
			;x25 = x27
			movf 0x27, 0
			movwf 0x25
			call getHeap
			;retorna x26

			
			;pisca led correspondente a x26
			;ROTINA DE LED INICIO
			;led 0
			movlw .0
			subwf 0x26, 0
			btfsc 0x03, 2 ; x26 é igual a zero?			
			call acendeled0		

			;led 1
			movlw .1
			subwf 0x26, 0
			btfsc 0x03, 2 ; x26 é igual a um?			
			call acendeled1	

			;led 2
			movlw .2
			subwf 0x26, 0
			btfsc 0x03, 2 ; x26 é igual a dois?			
			call acendeled2	

			;led 3
			movlw .3
			subwf 0x26, 0
			btfsc 0x03, 2 ; x26 é igual a três?			
			call acendeled3	
			;ROTINA DE LED FIM
			
			;if x27 - x24 = 0, se x27 já passou por todos os indices do nivel x24
			movf 0x24, 0
			subwf 0x27, 0

		btfss 0x03, 2	;são igual?, bit z
		goto bot
		
		;x27 = 0
		clrf 0x27
		decf 0x27; x27--, correção para o loop player

		player:
		;Confere entradas do jogador
			incf 0x27, 1; x27++
			
			;x25 = x27
			movf 0x27, 0
			movwf 0x25
			call getHeap
			;retorna x26, numero no vetor

			call entrada
			;retorna x28, numero apertado

			;x26 == x28?, o jogador apertou o botão certo?
			movf 0x26, 0
			subwf 0x28, 0

			btfss 0x03, 2	;são igual?
			goto gameOver			
			;nop	;jogador acertou, continua o loop
			
			;if x27 - x24 = 0, se x27 já passou por todos os indices do nivel x24
			movf 0x24, 0
			subwf 0x27, 0

		btfss 0x03, 2	;são igual?, bit z
		goto player
		

		;sobe de nivel
		incf 0x24, 1

		;if nivel == 8, zerou o jogo
		movf 0x24, 0
		sublw .8
		
		btfss 0x03, 2	;são iguai? zerou o jogo
		goto loopGame

	;ZEROU A JOGO
	goto win
		
	
	goto main



inter:  btfss   0x0b,1      ; if (INTF == 1) SALT
        goto    inttmr1


intext: bcf     0x0b,1      ; Apaga a flag INT EXT. -> RB0 (0x06,0)
        movf    0x0e,0
        movwf   0x22        ;0x22 = tmr1Low
 
        movf    0x0f,0
        movwf   0x23        ;0x23 = tmr1High
       
        ;bcf     0x10,0      ; T1ON = 0 -> T1CON (0x10,0) DESLIGA O TMR1
       
        bsf     0x20, 0     ;Booleano do botao start
       
        retfie 
 
inttmr1:    bcf     0x0c,0  ; Apaga a flag TMR1IF -> PIR1 (0x0c,0)
            btfss   0x30,0  ; if (contarRestoDeTempo = 1) SALT
            goto 	contarestotmr1
            clrf    0x06    ; clear no PORT B -> Apaga todos os leds
            ;bcf     0x10,0      ; T1ON = 0 -> T1CON (0x10,0) DESLIGA O TMR1
            bsf     0x30,1  ; Retorna verdadeiro para o loop de leds
            retfie
           
contarestotmr1: 
				bsf     0x30,0  ; contarRestoDeTempo = 1
                movlw   .23
                movwf   0x0f    ; TMR1H = 23
                movlw   .184
                movwf   0x0e    ; TMR1L = 184
                retfie
 
acendeledini:   
				clrf    0x30
                bcf     0x03,6
                bsf     0x03,5  ; BANCO 01
                bsf     0x8c,0  ; TMR1IE = 1
                bcf     0x03,6 
                bcf     0x03,5  ; BANCO 00
                clrf    0x0f    ; clear TMR1H
                clrf    0x0e    ; clear TMR1L
                movlw   0x31    ; xx11 0001
                movwf   0x10    ; T1CON
                return
               
acendeled0:     bsf     0x06,1
                call acendeledini
				loopled0:
				btfss 0x30,1
				goto loopled0
				return

acendeled1:     bsf     0x06,2
                call acendeledini
				loopled1:
				btfss 0x30,1
				goto loopled1
				return

acendeled2:     bsf     0x06,3
                call acendeledini
				loopled2:
				btfss 0x30,1
				goto loopled2
				return

acendeled3:     bsf     0x06,4
                call acendeledini
				loopled3:
				btfss 0x30,1
				goto loopled3
				return
               
               
 
 
end
