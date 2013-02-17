;
; programmed by Deniel Buzas
; HexadecimalToOctal converter program
; 15. 03. 2012
;
; character is comment as well as in C/C++ the // and /*...*/
.model small
;
.stack 100h
;
.data
;
LSD db 0, DUP(0)
MSD db 0, DUP('$')
;
; for the hex digits: (A = 10, B = 11, C = 12, D = 13, E = 14, F = 15)
;
hex1 db 'A',13,'$'
hex2 db 'B',13,'$'
hex3 db 'C',13,'$'
hex4 db 'D',13,'$'
hex5 db 'E',13,'$'
hex6 db 'F',13,'$'
;
message db 'please input the two hexadecimal digits in order to convert it to octal'13,10,'$'
first_remainder db 'first remainder is: '13,'$'
last_remainder db 'last remainder is: '13,10,'$'
octal_number db 'please input the two hexadecimal digits in order to convert it to octal'13,'$'
;
.code
;
MOV AX, @data
MOV DS, AX
;
; initialize the stack
;
PUSH BP
MOV BP, SP
;
; write out to the console window the message
;
MOV AH, 09h
MOV DX, OFFSET message
INT 21h
;
; read in the two hexa digits from the user input
;
XOR AX, AX
MOV AH, 01h
INT21h
;
; check whether one of the given hex digits' character is alphabetic instead of numeric
; if one of the chars contain the letter 'A' or 'B' or 'C' or 'D' or 'E' or 'F' then convert it to decimal
;
CMP AL, 0
JNE convertToDecimal
JE convertASCIItoInteger
;
convertToDecimal:
CMP AL, OFFSET hex1
JNE Ato10
CMP AL, OFFSET hex2
JNE Bto11
CMP AL, OFFSET hex3
JNE Cto12
CMP AL, OFFSET hex4
JNE Dto13
CMP AL, OFFSET hex5
JNE Eto14
CMP AL, OFFSET hex6
JNE Eto15
JE convertASCIItoInteger
;
Ato10:
XOR AL, AL
MOV AL, 10
PUSH AL
XOR AL, AL
JMP convertASCIItoInteger
Bto11:
XOR AL, AL
MOV AL, 11
PUSH AL
XOR AL, AL
JMP convertASCIItoInteger
Cto12:
XOR AL, AL
MOV AL, 12
PUSH AL
XOR AL, AL
JMP convertASCIItoInteger
Dto13:
XOR AL, AL
MOV AL, 13
PUSH AL
XOR AL, AL
JMP convertASCIItoInteger
Eto14:
XOR AL, AL
MOV AL, 14
PUSH AL
XOR AL, AL
JMP convertASCIItoInteger
Fto15:
XOR AL, AL
MOV AL, 15
PUSH AL
XOR AL, AL
JMP convertASCIItoInteger
;
; convert the value in the stack which consists of ASCII character(s) to integer or rather decimal numeric
;
convertASCIItoInteger:
XOR AH, AH
POP AL
SUB AL, 48
PUSH AL
JMP convertToOctal
;
; hex has been converted to decimal already, now convert decimal to octal
;
; The conversion of a decimal number to its base 8 equivalent is done by the repeated division method. You simply divide the base 10 number by 8
; and extract the remainders. The first remainder will be the LSD, and the last remainder will be the MSD.
;
convertToOctal:
XOR AX, AX
POP AX
MOV CX, AX
PUSH CX
XOR DX, DX
XOR BX, BX
MOV BX, 0x8
DIV BX
LEA [LSD], DX
TEST DX, [LSD]
JE converted
XOR CX, CX
POP CX
XCHG AX, CX
PUSH DX
DIV BX
XCHG CX, AX
POP DX
JNE repeat
repeat:
DIV BX
CMP DX, 0x8
DEC CX
JNA repeat
LEA [MSD], DX
JMP converted
;
converted:
;
; write to the octal value to the output
;
MOV BX, AX
MOV AH, 09h
MOV DX, OFFSET first_remainder
INT 21h
MOV AH, 02h
LEA DL, [LSD]
INT 21h
MOV AH, 09h
MOV DX, OFFSET last_remainder
INT 21h
MOV AH, 02h
LEA DL, [MSD]
INT 21h
MOV AH, 09h
MOV DX, OFFSET octal_number
INT 21h
JMP exit
;
; quit from the program and return with termination code 0
;
exit:
XOR AX, AX
XOR BX, BX
XOR CX, CX
XOR DX, DX
MOV AH, 4Ch
MOV AL, 0
INT 21h
;
.end
;
