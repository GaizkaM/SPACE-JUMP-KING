*-----------------------------------------------------------
* SYSTEM VARIABLES
*-----------------------------------------------------------
    
; --- KEYBOARD RELATED VARIABLES ----------------------------------------------

KBDVAL      DS.B    1                       ; KEY PRESSED=1
KBDEDGE     DS.B    1                       ; KEY EDGE

; --- MOUSE RELATED VARIABLES -------------------------------------------------

MOUSEINF
MOUSPOSY    DS.W    1                       ; MOUSE Y POSITION
MOUSPOSX    DS.W    1                       ; MOUSE X POSITION
MOUSSTAT    DS.B    1                       ; MOUSE STATE
            DS.W    0


; --- TIMED INTERRUPT RELATED VARIABLES ---------------------------------------

SCRINTCT     DS.B    1                       ; INTERRUPT COUNTER
SCRCYCCT     DS.B    1                       ; CYCLE COUNTER
             DS.W    0




*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
