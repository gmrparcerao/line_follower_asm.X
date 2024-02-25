COMMENT @
    Sao Paulo State Technology College of Itaquera "Professor Miguel Reale"
    Sao Paulo, 2019/05/22
    Associate of Science in Industrial Automation

    Names of undergraduate students:
      Bruno Ryuiti Kitano
      Gabriel Liobino Sampaio
      Guilherme Matheus Rafael Parcer�o
      Matheus Batista Rodrigues Carvalho
      
    Lecturer:
      Eder Terceiro

    Goals: 
      Software to control a line follower robot using Assembly language

    Hardware:
      PIC16F648A
      Resistors
      Hbridge module
      DC motor
      LDR sensors
      Colorless high-brightness LED

    Reviews: 
      R000 - begin

    This code is for didatic purposes only. No warranty of any kind is provided.
@

#include "p16f648a.inc"

__CONFIG _FOSC_INTOSCIO & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF
    org 0x00
    cblock 0x20
    loop1, loop2
    endc
    radix dec	
    goto configure
    org 0x04
    btfss PIR1, CMIF	    ; OCCURRED AN INTERRUPTION?
    retfie		    ; IF NOT, RETURN FROM INTERRUPTION
    bcf PIR1, CMIF

test
    bsf PORTB,1
    bsf PORTB,0
    btfsc CMCON, C2OUT
    goto colorRight
    btfsc CMCON, C1OUT
    goto colorLeft
    retfie

colorRight
    btfss PORTB,4
    goto stopRight
    bcf PORTB, 1
    bsf PORTB, 0
    call delay
    
colorRight2
    btfsc CMCON, C2OUT
    goto colorRight2
    call delay
    retfie

colorLeft
    btfss PORTB, 4
    goto stopLeft
    bsf PORTB, 1
    bcf PORTB, 0
    call delay

colorLeft2
    btfsc CMCON, C1OUT
    goto colorLeft2
    call delay
    retfie
	
stopRight
    btfsc CMCON, C1OUT
    bcf PORTB, 0
    bcf PORTB, 1
    call delay
    goto test
	
stopLeft
    btfsc CMCON, C2OUT
    bcf PORTB, 1
    bcf PORTB, 0
    call delay
    goto test
	
delay
    movlw 250
    movwf loop2
    
exter
    movlw 250
    movwf loop1

intern
    nop
    decfsz loop1, 1
    goto intern
    decfsz loop2, 1
    goto exter
    return

configure
    bsf STATUS, RP0	    ; CHANGE TO BANK 1
    movlw b'11111111'
    movwf TRISA
    ; 2 = sensorLeft
    ; 3 = sensorRight
    movlw b'00011100'
    movwf TRISB
    ; 0 = motorLeft
    ; 1 = motorRight
    ; 2 = LEFT
    ; 3 = RIGHT
    ; 4 = STOP
    bsf PIE1, CMIE	    ; Comparator interruption enable
    bcf STATUS, RP0	    ; CHANGE TO BANK 0
    movlw 4		    ; MOVE LITERAL 0X04 TO WORK
    movwf CMCON		    ; ENABLE TWO DIFFERENT COMPARATORS
    movlw b'11000000'
    movwf INTCON	    ; ENABLE GLOBAL AND PERIPHERAL INTERRUPTION
    
loop
    goto loop

end
