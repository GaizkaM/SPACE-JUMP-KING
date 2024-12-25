*------------------------------------------------------------------------------
* SYSTEM CONSTANTS
*------------------------------------------------------------------------------

; --- SCREEN RELATED CONSTANTS ------------------------------------------------

SCRWIDTH    EQU     640         ; SCREEN WIDTH     
SCRHEIGH    EQU     480         ; SCREEN HEIGHT
SCRFPS      EQU     100         ; SCREEN FRAMES PER SECOND

; --- KEY CODES (EASy68K) -----------------------------------------------------

KBDCHRSP    EQU     ' '                     ; SPACE KEY
KBDCHRMK    EQU     'M'                     ; M KEY
KBDCHRSH    EQU     $10                     ; SHIFT KEY
KBDCHRPK    EQU     'P'                     ; P KEY
KBDCHRLF    EQU     $25                     ; LEFT KEY
KBDCHRUP    EQU     $26                     ; UP KEY
KBDCHRRT    EQU     $27                     ; RIGHT KEY
KBDCHRDN    EQU     $28                     ; DOWN KEY

; --- KEYBOARD MAPPING --------------------------------------------------------

KBDLEFT     EQU     KBDCHRLF                ; LEFT BUTTON
KBDUP       EQU     KBDCHRUP                ; UP BUTTON
KBDRIGHT    EQU     KBDCHRRT                ; RIGHT BUTTON
KBDDOWN     EQU     KBDCHRDN                ; DOWN BUTTON
KBDFIRE1    EQU     KBDCHRSP                ; FIRE 1 BUTTON
KBDFIRE2    EQU     KBDCHRMK                ; FIRE 2 BUTTON
KBDFIRE3    EQU     KBDCHRSH                ; FIRE 3 BUTTON
KBDPAUSE    EQU     KBDCHRPK                ; PAUSE BUTTON

; --- SOUND IDENTIFIERS -------------------------------------------------------

SNDWALL     EQU     0
SNDCHG      EQU     1
SNDWIN      EQU     2
SNDINTRO    EQU     3
SNDOVER     EQU     4
SNDSHOT     EQU     5

; --- TRAP NUMBERS ------------------------------------------------------------

SCRUPTN     EQU     0                       ; SCREEN UPDATE TRAP NUMBER
KBDUPTN     EQU     1                       ; KEYBOARD UPDATE TRAP NUMBER
SNDPLTN     EQU     2                       ; SOUND PLAY TRAP NUMBER

; --- INTERRUPT NUMBERS -------------------------------------------------------

SCRINTN     EQU     1                       ; TIMED INTERRUPT NUMBER

; --- MOUSE RELATED CONSTANTS -------------------------------------------------

SYSMOUMV    EQU     %100
SYSMOUBU    EQU     %010
SYSMOUBD    EQU     %001










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
