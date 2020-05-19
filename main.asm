;
; Feu rouge v1.0
;
; Created: //20/05/2020
; Author : //DAMSIN SEBASTIEN
;


;***************************************************************************** 
;   DIRECTIVES D'ASSEMBLAGE 
;***************************************************************************** 
.DEVICE  atmega2560 ;Type de Microcontr�leur (d�finit dans l'include) 
.INCLUDE "m2560def.inc" ;Fichier de d�finition du microcontr�leur 

;***************************************************************************** 
;   PORTS D'ENTREES/SORTIES 
;***************************************************************************** 
; Port A0  Branch� sur une LED 
;     A1 � A7 Libre 
; Port B0 � B7 Libre 
; Port C0 � C7  Libre 
; Port D0 � D7 Libre 
 

 ;***************************************************************************** 
 ;   DEFINITIONS DE REGISTRES 
 ;***************************************************************************** 
 ; r0 � r15 Libre 
 ; r16 � r20 Utilis� par le programme 
 ; r21 � r25 Libre 
 ; r26 � r31 R�serv� pour registre X, Y, Z

 ;***************************************************************************** 
 ;   ORGANISATION RAM 
 ;***************************************************************************** 
 .DSEG 
 .ORG $200 ; d�but de la m�moire disponible pour l�utilisateur (vous) 
 ;Ici on peut d�finir des variables locales d�un octet pour stocker des valeurs quelconques. 
  
 
 ;***************************************************************************** 
 ;   INTERRUPTIONS ET RESET 
 ;***************************************************************************** 
 ; M�me si les interruptions ne sont pas utilis�es ces d�finitions doivent �tre d�clar�es 
 .CSEG		 ;Segment de Code 
 .ORG  $0000   ;Positionnement au d�but de la m�moire  
	jmp RESET   ;Reset Handler  
	jmp EXT_INT0   ;IRQ0 Handler  
	jmp EXT_INT1   ;IRQ1 Handler  
	jmp EXT_INT2   ;IRQ2 Handler  
	jmp TIM2_COMP  ;Timer2 Compare Handler  
	jmp TIM2_OVF   ;Timer2 Overflow Handler  
	jmp TIM1_CAPT   ;Timer1 Capture Handler  
	jmp TIM1_COMPA  ;Timer1 CompareA Handler  
	jmp TIM1_COMPB  ;Timer1 CompareB Handler  
	jmp TIM1_OVF   ;Timer1 Overflow Handler  
	jmp TIM0_COMP  ;Timer0 Compare Handler  
	jmp TIM0_OVF   ;Timer0 Overflow Handler  
	jmp SPI_STC   ;SPI Transfer Complete Handler  
	jmp USART_RXC  ;USART RX Complete Handler  
	jmp USART_UDRE  ;UDR Empty Handler  
	jmp USART_TXC  ;USART TX Complete Handler  
	jmp ADC_COMP  ;ADC Conversion Complete Handler  
	jmp EE_RDY   ;EEPROM Ready Handler  
	jmp ANA_COMP   ;Analog Comparator Handler  
	jmp TWI    ;Two-wire Serial Interface Handler  
	jmp SPM_RDY   ;Store Program Memory Ready Handler 

 ;***************************************************************************** 
 ;   PROGRAMME PRINCIPAL (RESET) 
 ;***************************************************************************** 
 ;Initialise la pile en bas de la m�moire RAM en adresse 16 bits 
RESET:	ldi r16, HIGH(RAMEND) ;Charge la valeur haute de l�adresse en fin m�moire RAM   
		out SPH, r16   ;Positionne le pointeur de pile haut sur cette adresse    
		ldi r16, LOW(RAMEND) ;Charge la valeur basse de l�adresse en fin m�moire RAM   
		out SPL, r16   ;Positionne le pointeur de pile bas sur cette adresse 
 

;-----------------------------------------------------------------------------
;Initialisation Port A ;PA0 = Led � PA1 � PA7 libres
	;ser r16 ;Port en sortie (les bits du port sont mis � 1, soit en sortie)
	;out DDRA, r16 ;Ecriture sur le
	;clr r16 ;Port en bas (les bits du port sont mis � 0, Led �teinte)
	;out PORTA, r16 ;Port A mis � z�ro

;-----------------------------------------------------------------------------
;Initialisation Port B ;PB0 = Led � PB1 � PB7 libres
	ser r16 ;Port en sortie (les bits du port sont mis � 1, soit en sortie)
	out DDRB, r16 ;Ecriture sur le
	clr r16 ;Port en bas (les bits du port sont mis � 0, Led �teinte)
	out PORTB, r16 ;Port A mis � z�ro

;-----------------------------------------------------------------------------
;Initialisation Port C ;PC0 = Led � PC1 � PC7 libres
	ser r16 ;Port en sortie (les bits du port sont mis � 1, soit en sortie)
	out DDRC, r16 ;Ecriture sur le 
	clr r16 ;Port en bas (les bits du port sont mis � 0, Led �teinte)
	out PORTC, r16 ;Port C mis � z�ro

;-----------------------------------------------------------------------------
;Initialisation Port D ;PD0 = Led � PD1 � PD7 libres
	;ser r16 ;Port en sortie (les bits du port sont mis � 1, soit en sortie)
	;out DDRD, r16 ;Ecriture sur le
	;clr r16 ;Port en bas (les bits du port sont mis � 0, Led �teinte)
	;out PORTD, r16 ;Port A mis � z�ro

;-----------------------------------------------------------------------------
;Fin d�initialisation
	jmp Debut ;Fin d'initialisation, saute au d�but

;_____________________________________________________________________________
;Interruptions non utilis�es
EXT_INT0: ;IRQ0
EXT_INT1: ;IRQ1
EXT_INT2: ;IRQ2
TIM2_COMP: ;Timer2 Comparaison
TIM2_OVF: ;Timer2 Overflow
TIM1_CAPT: ;Timer1 Capture
TIM1_COMPA: ;Timer1 CompareA
TIM1_COMPB: ;Timer1 CompareB
TIM1_OVF: ;Timer1 Overflow
TIM0_COMP: ;Timer0 Compare
TIM0_OVF: ;Timer0 Overflow
SPI_STC: ;SPI Transfer Complete
USART_RXC: ;USART RX Complete
USART_UDRE: ;UDR Empty
USART_TXC: ;USART TX Complete
EE_RDY: ;EEPROM Ready
ADC_COMP: ;ADC Conversion Compl�te
ANA_COMP: ;Analog Comparator
TWI: ;Two-wire Serial Interface
SPM_RDY: ;Store Program Memory Ready
nop ;Ne rien faire dans cette interruption
reti ;Fin de l�interruption

;*****************************************************************************
;_____________________________________________________________________________
;Programme principal
;_____________________________________________________________________________
Debut:					;Programme principal

;in r16, PORTB			;m�morise l'�tat de la pin
ldi r17, 0b10000000
;eor r16, r17			;OU exclusive entre 16 et 17 stock� dans r16
;allume rouge
out PORTB, r17
; Delais de 5 secondes
    ldi  r18, 2
    ldi  r19, 150
    ldi  r20, 216
    ldi  r21, 9
L1: dec  r21
    brne L1
    dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
    rjmp PC+1
;�teindre rouge
ldi r17, 0b00000000
out PORTB, r17
;Allume orange
ldi r18, 0b01000000
out PORTB, r18
; Delais de 2 secondes
    ldi  r18, 163
    ldi  r19, 87
    ldi  r20, 3
L2: dec  r20
    brne L2
    dec  r19
    brne L2
    dec  r18
    brne L2
    nop
;�teindre orange
ldi r18, 0b00000000
out PORTB, r18
;allume vert
ldi r16, 0b00100000
out PORTB, r16
; Delais de 5 secondes
    ldi  r18, 2
    ldi  r19, 150
    ldi  r20, 216
    ldi  r21, 9
L3: dec  r21
    brne L3
    dec  r20
    brne L3
    dec  r19
    brne L3
    dec  r18
    brne L3
    rjmp PC+1
;�teindre vert
ldi r16, 0b00000000
out PORTB, r16

rjmp Debut ;Boucle infini sur le programme principal
;_____________________________________________________________________________
;*****************************************************************************