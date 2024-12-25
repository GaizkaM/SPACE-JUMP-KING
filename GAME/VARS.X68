*------------------------------------------------------------------------------
* GAME VARIABLES
*------------------------------------------------------------------------------

; --- PLAYER RELATED VARIABLES ------------------------------------------------

PLRPOSX     DS.W    1                       ; PLAYER'S X POSITION (PIXELS)
PLRPOSY     DS.L    1                       ; PLAYER Y POSITION (PIX, FIX. PNT)
PLRSPDY     DS.L    1                       ; PLAYER Y SPEED (PIX, FIX. PNT))
PLRSCOR     DS.W    1                       ; PLAYER'S SCORE
LASSCOR     DS.W    1                       ; LAST PLAYER'S SCORE

; --- PLATFORM RELATED VARIABLES ------------------------------------------------

POSXLST     DS.W    1                       ;ULTIMA POS PLATAFORMA GENERADA
POSYLST     DS.W    1                       ;ULTIMA POS PLATAFORMA GENERADA
PLTSCR      DS.W    1                       ; PLATFORMS ON SCREEN

; --- SCOREBOARD RELATED VARIABLES --------------------------------------------

SCOIN       DS.W    1                       ; NUMBER OF JUMPS

; --- INTRO STATE RELATED VARIABLES -------------------------------------------

ISCTIMER    DS.W    1                       ; INTRO TIMER

; --- INSTRUCTIONS STATE RELATED VARIABLES ------------------------------------

INSTIMER    DS.W    1                       ; INSTRUCTIONS TIMER

; --- STATE RELATED VARIABLES -------------------------------------------------

STACUR      DS.W    1                       ; CURRENT STATE
STANEXT     DS.W    1                       ; NEXT STATE














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
