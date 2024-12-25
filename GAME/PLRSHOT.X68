; =============================================================================
; PLAYER SHOT MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
;                  - +0 WORD X COORDINATE
;                  - +2 WORD Y COORDINATE
; =============================================================================

; -----------------------------------------------------------------------------
PLRSHOI
; PLAYER SHOT INITIALIZATION
; INPUT: A0 POINTER TO THE LOCAL MEMORY
; OUTPUT: NONE
; MODIFIES: NONE
; -----------------------------------------------------------------------------    
        MOVE.W  (PLRPOSX),(A0)
        MOVE.W  (PLRPOSY),2(A0)
        SUB.W   #(PLRHEIGH/2),2(A0)
        RTS        
    
; -----------------------------------------------------------------------------
PLRSHOU
; PLAYER SHOT UPDATE
; INPUT: A0 POINTER TO THE LOCAL MEMORY
; OUTPUT: NONE
; MODIFIES: NONE
; -----------------------------------------------------------------------------
            ; MOVEMENT
            SUB.W   #PLRSHSP,2(A0)
            ; KILL IF OUT OF SCREEN
            TST.W   2(A0)                   
            BLT     AGLKILL
            
            MOVEM.L A0-A1/D0-D7,-(A7)
            MOVE.W  (A0),D2
            ; COLLISION CHECK     
            MOVE.W  2(A0),D3                
            MOVE.W  #PLRSHWI,D5
            MOVE.W  #PLRHEIGH,D7
            MOVE.L  A0,A1
            
            ; LOOP THROUGH ALL ENEMIES
            MOVE.W  #ENETYPE,D0             
            JSR     DMMFRSTO
.LOOP       CMP.L   #0,A0
            BEQ     .END
            MOVE.W  8(A0),D0
            MOVE.W  10(A0),D1
            MOVE.W  #ENEWIDTH,D4
            MOVE.W  #ENEHEIGH,D6
            JSR     UTLCHCOL
            TST.B   D0
            ; IF COLLISION, HIT IT
            BNE     .HIT                    
            MOVE.W  #ENETYPE,D0
            JSR     DMMNEXTO
            BRA     .LOOP

.END        MOVEM.L (A7)+,A0-A1/D0-D7
            RTS

.HIT        ADD.L   #8,A0
            ; DELETE ENEMY
            JSR     AGLKILL                 
            MOVE.L  A1,A0
            ; DESTROY SHOT
            JSR     AGLKILL                 
            BRA     .END
            
; -----------------------------------------------------------------------------
PLRSHOP
; PLAYER SHOT PLOT
; INPUT: A0 POINTER TO THE LOCAL MEMORY
; OUTPUT: NONE
; MODIFIES: NONE
; -----------------------------------------------------------------------------       
        MOVEM.L     A0/D0-D4,-(A7)
        
        UTLSPEN     #CLRWHITE
        UTLSFIL     #CLRWHITE
        
        MOVE.W      (A0)+,D1
        MOVE.W      (A0),D2
        MOVE.W      D1,D3
        MOVE.W      D2,D4
        ADD.W       #PLRSHWI,D3
        ADD.W       #PLRSHHE,D4
        MOVE.B      #87,D0
        TRAP        #15
        MOVEM.L     (A7)+,A0/D0-D4
        RTS




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
