//*****************************************************************************
// Universidad del Valle de Guatemala
// IE2023: Programación de microcontroladores
// Proyecto: Laboratorio 2
// Created: 30/01/2024 23:12:46
// Author : Paul Mateo Castañeda Paredes
// Hardware: ATMEGA328P
//*****************************************************************************
//Encabezado
//*****************************************************************************
.include "M328PDEF.inc"
.cseg
.org 0x00
//*****************************************************************************
// Stack
//*****************************************************************************
LDI R16, LOW(RAMEND)
OUT SPL, R16
LDI R17, HIGH(RAMEND)
OUT SPH, R17

//*****************************************************************************
// Configuración
//*****************************************************************************



Setup:
LDI R16, (1<<CLKPCE)
STS CLKPR, R16
LDI R16, 0b0000_0001
STS CLKPR, R16 // Cambiar frecuencia del reloj 

LDI R16,0x00 
STS UCSR0B, R16 // Apagamos los bits RX Y TX


LDI R18, 0b0000_1100
LDI R19, 0b0001_1111
OUT DDRB, R19
OUT DDRC, R18
LDI R18, 0X00
OUT PORTC, R18
LDI R19, 0b1111_1111
OUT DDRD, R19
OUT PORTD, R19 // SALIDAS

CALL Timer0

LDI R17, 0
LDI R18, 0xFF

LDI R21, 0XFF
LDI R22, 0XFF
LDI R23, 0b0000_0011
LDI R24, 0b0000_0000 //Delay
MAIN:
LDI ZH, HIGH(TABLA7SEG<<1)
LDI ZL, LOW(TABLA7SEG<<1)
LPM R20, Z // TABLA




LOOP: 
IN R19, PINC
CPI R19, 0b0000_0000
BRNE Comp
IN R16, TIFR0
SBRS R16, TOV0 //Comprobación de condiciones
RJMP LOOP

LDI R16, 158
OUT TCNT0, R16

SBI TIFR0, TOV0
INC R17
CPI R17, 100
BRLT LOOP


CLR R17
INC R18


CP R18, R24
BREQ Total


OUT PORTB, R18
CPI R18, 0b0000_1111
BREQ Reinicio //Reinicio de contador de Leds



RJMP LOOP 
//*****************************************************************************
// Sub-rutinas
//*****************************************************************************

Timer0:
LDI R16, 0b0000_0011
OUT TCCR0A, R16

LDI R16, 0b0000_0101
OUT TCCR0B, R16

LDI R16, 158
OUT TCNT0, R16

RET


Reinicio:
LDI R18, 0b0000_0000
RJMP LOOP

SUMA:
INC R24
CPI R24, 15
BREQ LOOP
INC ZL
LPM R20, Z
OUT PORTD, R20
RJMP LOOP

RESTA:
DEC R24
CPI R24, 0
BREQ LOOP
DEC ZL
LPM R20, Z
OUT PORTD, R20
RJMP LOOP

Comp:
Call delay
CPI R19, 0b0000_0001
BREQ SUMA
CPI R19, 0b0000_0010

BREQ RESTA

RJMP LOOP



Delay:
CALL Timer0
DEC R21 
CPI R21, 0b0000_0000 
BRNE Delay 
LDI R21, 0b1111_1111
DEC R22
CPI R22, 0b0000_0000
BRNE DELAY
LDI R22, 0b1111_1111
DEC R23 
CPI R23, 0b0000_0000
BRNE DELAY
LDI R23, 0b0000_0011 // Delay
RET

TOTAL:
CALL DELAY
LDI R18, 0b0001_0000
OUT PORTB, R18
OUT PORTD, R22
RET

//*****************************************************************************
// Tabla de Valores
//*****************************************************************************
TABLA7SEG: .DB 0b1100_0000, 0b1111_1001, 0b1010_0100, 0b0011_0000, 0b1001_1001, 0b1001_0010, 0b1000_0010, 0b1111_1000, 0b1000_0000, 0b1001_0000, 0b1000_1000, 0b1000_0011, 0b1100_0110, 0b1010_0001, 0b1000_0110, 0b1000_1110

//TablaLeds: 0b0000_0000, 0b0000_0001, 0b0000_0010, 0b0000_0011, 0b0000_0100, 0b0000_0101, 0b0000_0110, 
//0b0000_0111, 0b0000_1000, 0b0000_1001, 0b0000_1010, 0b0000_1011,0b0000_1100,0b0000_1101, 0b0000_1110,
//0b0000_11110