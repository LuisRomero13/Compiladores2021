.MODEL LARGE
.386
.STACK 200h
.DATA

MAXTEXTSIZE equ 50
$chain db MAXTEXTSIZE dup (?),?$?
$chain2 db MAXTEXTSIZE dup (?),?$?
$a dd ?
$z dd ?
$b dd ?
$zetach db MAXTEXTSIZE dup (?),?$?
$pepe dd ?
$juan dd ?
$pi dd ?
$yota db MAXTEXTSIZE dup (?),?$?
$5 equ 5
$"hola" equ "hola$"
$"manola" equ "manola$"
$7 equ 7
$6 equ 6
$3 equ 3
$22 equ 22
$"jaja" equ "jaja$"
$"jojo" equ "jojo$"

.CODE
MAIN:
mov AX,@DATA
mov DS,AX
mov es,ax



mov ax, 4C00h; termina la ejecuci?n.int 21hEND
int 21h
END MAIN