* -----------------------------------------------------------------------------
* SCOREBOARD MANAGEMENT
* -----------------------------------------------------------------------------

* -----------------------------------------------------------------------------
SCOINIT
* INITIALIZE SCOREBOARD
* INPUT     : NONE
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------
            CLR.W   (SCOIN)
            RTS
                       
* -----------------------------------------------------------------------------
SCOPLOT
* PLOT THE SCOREBOARD
* INPUT     : NONE
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------            
            MOVEM.L D0-D1/A1,-(A7)

            UTLSFIL #SCOFCOL
            
            ; SET LINE POSITION 
            MOVE.B  #11,D0
            MOVE.L  #SCOLINE,D1
            TRAP    #15
            
            ; PRINT LINE
            LEA     .TXT,A1
            CLR.L   D1
            MOVE.W  (SCOIN),D1
            MOVE.B  #17,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D1/A1
            
            RTS
.TXT        DC.B    'JUMPS :',0



*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
