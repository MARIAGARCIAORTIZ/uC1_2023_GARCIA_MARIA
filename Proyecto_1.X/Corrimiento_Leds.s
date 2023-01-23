;-------------------------------------------------------------------------------
    ;@file    P1_Corrimiento_Leds.s
    ;@brief   //corrimiento de leds conectados al puerto C, con un retardo de 500 ms en un numero de corrimientos pares 
	     //un retardo de 250ms en un numero de corrimientos impares.
    ;@date    14/01/2023
    ;@author  Garcia Ortiz Maria del Carmen
    ;Frecuencia = 4MHz
;-------------------------------------------------------------------------------
; IMPAR 500ms(rapido)---- PAR 250ms(lento)
PROCESSOR 18F57Q84
#include "Bit_configure.inc"  // config statements should precede project file includes.
#include <xc.inc>  
PSECT PROYECTO_1,class=CODE,reloc=2 ;SESION DEL PROGRAMA 
PROYECTO_1:
    goto Main
    
PSECT udata_acs ; declaramOS las variables 
valor_contador1: DS 1   
valor_contador2: DS 1            ; BYTE RESERVADO EN ACCESS RAM 
valor_contador3: DS 1    
 
PSECT CODE
Main:
     CALL Config_OSC,1
     CALL Config_Port,1

Pulsador:
    BANKSEL   LATA
    CLRF      LATC,b
    BCF       LATE,1,b ;prende el led cuando hay corrimiento par
    BCF       LATE,0,b ;prende el led cuando hay corrimiento impar
    BTFSC     PORTA,3,b ; salta si es 0, cuando el pulsador está presionado va saltar una instrucción(se debe por la resistencia pull UP)
    goto      Pulsador //EN CASO DE  NO PRESIONAR EJECUTA ESTA INSTRUCCIÓN
    goto      PAR
     
PAR:
    CLRF  LATC,b; INICIA CON TODOS LOS LED APAGADOS 
    BCF   LATE,0,b; APAGA EL LED IMPAR
    BSF   LATE,1,b ;PRENDE EL LED PAR 
    MOVLW 00000010B ;CARGA W CON VALOR DE 2 
    MOVWF LATC,1 ;PRENDE LED2
    CALL  Delay_500ms,1; HAY EL RETARDO 
    BTFSS PORTA,3,0;SALTA SI EL LED NO ESTÁ PRECIONADO 
    GOTO  Pulsador1; EJECUTA CUANDO ESTÁ PRESIONADO EL PULSADOR 
    
    BSF   LATE,1,b; PRENDE EL LED DE CORRIMIENTO PAR 
    BCF   LATE,0,b; APAGA ELL LED DE CORRIMIENTO IMPAR 
    MOVLW 00001000B; CARGA AL W CON VALOR DE 8 
    MOVWF LATC,1; PRENDERÁ EL LED 4 
    CALL  Delay_500ms,1; HAY RETARDO 
    BTFSS PORTA,3,0; SI ES 1 SALTA 
    GOTO  Pulsador1
    
    BSF   LATE,1,b
    BCF   LATE,0,b
    MOVLW 00100000B   ;CARGA EL VALOR DE 32 
    MOVWF LATC,1    ; PRENDE EL LED 8
    CALL  Delay_500ms,1;RETARDO
    BTFSS PORTA,3,0
    GOTO  Pulsador1
    
    BSF   LATE,1,b
    BCF   LATE,0,b
    MOVLW 10000000B ; CARGA EL VALOR 128
    MOVWF LATC,1
    CALL  Delay_500ms,1 ;RETARDO
    BTFSS PORTA,3,0
    GOTO  Pulsador1
    
 IMPAR:
    CLRF  LATC,b ; limpio los puertos C 
    BCF   LATE,1,b
    BSF   LATE,0,b
    MOVLW 00000001B ; CARGA EL VALOR DE 1
    MOVWF LATC,1 ; PRENDE EL LED 1
    CALL  Delay_250ms,1 ;RETARDO
    BTFSS PORTA,3,0
    GOTO  Pulsador2
    
    BCF   LATE,1,b
    BSF   LATE,0,b
    MOVLW 00000100B ; CARGA EL VALOR DE 4
    MOVWF LATC,1 ; PRENDE EL LED 3
    CALL  Delay_250ms,1 ;RETARDO
    BTFSS PORTA,3,0
    GOTO  Pulsador2
    
    BCF   LATE,1,b
    BSF   LATE,0,b
    MOVLW 00010000B ; CARGA EL VALOR DE 16
    MOVWF LATC,1 ; PRENDE EL 5 
    CALL  Delay_250ms,1 ;RETARDO
    BTFSS PORTA,3,0
    GOTO  Pulsador2
    
    BCF   LATE,1,b
    BSF   LATE,0,b
    MOVLW 01000000B ; CARGA EL VALOR DE 64
    MOVWF LATC,1 ;PRENDE EL VALOR 7
    CALL  Delay_250ms,1 ;RETARDO
    BTFSS PORTA,3,0
    GOTO  Pulsador2
    GOTO  PAR
    
Pulsador1:
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0
    GOTO    Pulsador1
    GOTO    PAR ; EL PAR VA AL PULSADOR 1
    
Pulsador2:
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0
    GOTO    Pulsador1
    GOTO    IMPAR   ; VA AL PULSADOR 2  
    
Config_OSC:
    ;LA FRENCUENCIA DEL OSCILADOR INTERNO ESTÁ CONFIGURADO EN 4Mhz   
         BANKSEL OSCCON1
	 MOVLW 0X60     ;EL BLOQUE SELECIONADO DEL OSC CON UN Div:1
	 MOVWF OSCCON1,1
	 MOVLW 0X02    
	 ;LO CONFIGURAMOS CON LA FRECUENCIA DE 4Mhz 
	 MOVWF OSCFRQ ,1
         RETURN

Config_Port:   ;PORT-LAT-ANSEL-TRIS  LED:RF3,  PULSADOR:RA3
    ;Configuración de Leds
    BANKSEL  PORTF
    //ENTONCES...	CLRF     PORTF,b    ;PORTF = 0
		    ;    BSF      LATF,3,b   ;LATF<3> = 1 - Led off
		    ;    CLRF     ANSELF,b   ;ANSELF<7:0> = 0 - Port F digital
		    ;    BCF      TRISF,3,b  ;TRISF<3> = 0  RF3 como Salida

    CLRF     TRISC,b    ;TRISC = 0 Como salida
    CLRF     ANSELC,b   ;ANSELC<7:0> = 0 - Port C digital
    BCF      TRISE,1,b  ;TRISF<1> = 0  RE1 como SALIDA//TRABAJA 
    BCF      TRISE,0,b  ;TRISF<0> = 0  RF0 como SALIDA//TRABAJA 
    BCF      ANSELE,1,b  ;TRISF<1> = 0  RE1 como Digital
    BCF      ANSELE,0,b  ;TRISF<0> = 0  RE0 como Digital
    
    ;CONFIGURAMOS EL PULSADOR 
    BANKSEL PORTA
    CLRF    PORTA,b     ;PORTA7:0> = 0 
    CLRF    ANSELA,b    ;PORTA DIGITAL
    BSF     TRISA,3,b   ;RA3 como entrada
    BSF     WPUA,3,b    ;Se activa la resistencia  Pull-up del pin RA3
    RETURN   
    
    //CONFIGURACIÓN DE RATARDOS               
Delay_500ms:	;1Tcy=1us	T= (6 + 4k1)(k2)(k3)us
    MOVLW   2			    ;1Tcy--k3
    MOVWF   valor_contador3,0	    ;1Tcy
D_500ms:			    ;2Tcy--call
    MOVLW   250			    ;1Tcy--k2
    MOVWF   valor_contador2,0	    ;1Tcy
    
Ext500ms_Loop:                  
    MOVLW   249			    ;1Tcy--k1
    MOVWF   valor_contador1,0	    ;1Tcy
Int500ms_Loop:
    NOP				    ;K1*Tcy
    DECFSZ  valor_contador1,1,0	    ;(k1-1)+ 3Tcy           
    GOTO    Int500ms_Loop	    ;2Tcy
    DECFSZ  valor_contador2,1,0	    ;2Tcy
    GOTO    Ext500ms_Loop	    ;2Tcy 
    DECFSZ  valor_contador3,1,0
    GOTO    D_500ms
    RETURN			    ;2Tcy   

		;1Tcy=1us   T= (6 + 4k1)k2us              
Delay_250ms:			    ;2Tcy--CALL
    MOVLW   250			    ;1Tcy--k2
    MOVWF   valor_contador2,0	    ;1Tcy
    
Ext250ms_Loop:                  
    MOVLW   249			    ;1Tcy--k1
    MOVWF   valor_contador1,0	    ;1Tcy
Int250ms_Loop:
    NOP                     ;K1*Tcy
    DECFSZ  valor_contador1,1,0	    ;(k1-1)+ 3Tcy           
    GOTO    Int250ms_Loop	    ;2Tcy
    DECFSZ  valor_contador2,1,0	    ;2Tcy
    GOTO    Ext250ms_Loop	    ;2Tcy   
    RETURN			    ;2Tcy     
    
END PROYECTO_1


