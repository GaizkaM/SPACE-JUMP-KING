; =============================================================================
; LEVEL 1 ENEMY MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
;                  - +0 WORD X COORDINATE
;                  - +2 WORD Y COORDINATE
;                  - +4 WORD X SPEED
;                  - +6 WORD Y SPEED
; =============================================================================

; -----------------------------------------------------------------------------
ENEINIT
; INITALIZES AN ENEMY
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - ASSUMES SCRHEIGH IS GREATER THAN 255
; -----------------------------------------------------------------------------
            MOVE.W  D0,-(A7)
.OUT        JSR     UTLRAND   
            LSL     #2,D0  
            CMP.W   #SCRWIDTH,D0
            BGE     .OUT 
            
            ; X POSITION (PSEUDO-RANDOM)
            MOVE.W  D0,(A0)    
            ; Y POSITION 
            MOVE.W  #ENEHEIGH/2, 2(A0)         
            
            ; Y SPEED (PSEUDO-RANDOM)
            JSR     UTLRAND
            AND.W   #$0001,D0               
            ADDQ.B  #2,D0
            MOVE.W  D0,6(A0)
            
            JSR     UTLRAND
            AND.W   #$0001,D0
            ADDQ.B  #1,D0
            CMP     #1,D0
            BEQ     .LEFT  
         
            ; X SPEED (PSEUDO-RANDOM)
            JSR     UTLRAND
            AND.W   #$0005,D0
            MOVE.W  D0,4(A0)                
            BRA     .END
            
.LEFT       JSR     UTLRAND
            AND.W   #$0005,D0
            NEG     D0
            MOVE.W  D0,4(A0)           
.END        MOVE.W  (A7)+,D0
            RTS

; -----------------------------------------------------------------------------
ENEUPDT
; UPDATES AN ENEMY
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - A0
; -----------------------------------------------------------------------------         
            MOVEM.L D0-D7,-(A7)
            MOVE.W  (A0),D0
            ADD.W   4(A0),D0
            MOVE.W  D0,(A0)                     
            MOVE.W  2(A0),D0
            ADD.W   6(A0),D0
            MOVE.W  D0,2(A0)                    
            
            CLR.W   D0
            MOVE.W  (A0),D0
            MOVE.W  2(A0),D1
            MOVE.W  (PLRPOSX),D2
            MOVE.W  (PLRPOSY),D3
            MOVE.W  #PLRWIDTH,D5
            MOVE.W  #PLRHEIGH,D7
            MOVE.W  #ENEWIDTH,D4
            MOVE.W  #ENEHEIGH,D6
            JSR     UTLCHCOL
            TST.B   D0
            ; COLLISION?
            BNE     .COL
                        
            ; CHECK LEFT BOUNDARY
            CMP.W   #1,(A0)         
            BLT     .BOUNCEL
            
            ; CHECK RIGHT BOUNDARY                    
            CMP.W   #SCRWIDTH-1-ENEWIDTH,(A0)   
            BGT     .BOUNCER
            
            ; CHECK BOTTOM BOUNDARY                    
            CMP.W   #SCRHEIGH-1-ENEHEIGH,2(A0)  
            BGT     .BOUNCEB                    
            BRA     .END

.BOUNCEL    NEG 4(A0)                           
            BRA     .END   

.BOUNCER    MOVE.W  #SCRWIDTH-1-ENEWIDTH,(A0)   
            NEG     4(A0)                       
            BRA     .END

.BOUNCEB    JSR     AGLKILL
            BRA     .END

.COL        ; HIT = GAME OVER
            MOVE.W  #STAGOVR,(STANEXT)

.END        MOVEM.L (A7)+,D0-D7
            RTS

; -----------------------------------------------------------------------------
ENEPLOT
; PLOTS A LEVEL 1 ENEMY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)
            
            UTLSPEN #ENERED
            UTLSFIL #ENERED 
          
            MOVE.W  (A0),D1          
            MOVE.W  2(A0),D2          
            MOVE.W  D1,D3                       
            MOVE.W  D2,D4
            
            ; HEAD P11                               
            ADD.W   #(ENEWIDTH/4),D2                
            ADD.W   #(ENEWIDTH),D3            
            ADD.W   #(6*(ENEWIDTH)/8),D4           
            MOVE.B  #87,D0
            TRAP    #15
            
            ; HEAD P2            
            ADD.W   #(ENEWIDTH/8),D1                
            SUB.W   #(ENEWIDTH/8),D2
            SUB.W   #(ENEWIDTH/8),D3            
            ADD.W   #(ENEWIDTH/8),D4           
            MOVE.B  #87,D0
            TRAP    #15
            
            ; HEAD P3
            ADD.W   #(ENEWIDTH/8),D1                
            SUB.W   #(ENEWIDTH/8),D2
            SUB.W   #(ENEWIDTH/8),D3            
            ADD.W   #(ENEWIDTH/4),D4           
            MOVE.B  #87,D0
            TRAP    #15
            
            ; LEFT LEG
            SUB.W   #(ENEWIDTH/8),D1                
            ADD.W   #(ENEWIDTH),D2
            SUB.W   #(ENEWIDTH/2),D3            
            ADD.W   #(ENEWIDTH/8),D4           
            MOVE.B  #87,D0
            TRAP    #15
            
            ; LEFT FOOT
            SUB.W   #(ENEWIDTH/8),D1                
            ADD.W   #(ENEWIDTH/8),D2
            SUB.W   #(ENEWIDTH/8),D3            
            ADD.W   #(ENEWIDTH/8),D4           
            MOVE.B  #87,D0
            TRAP    #15
            
            ; RIGHT FOOT
            ADD.W   #(ENEWIDTH-ENEWIDTH/8),D1        
            ADD.W   #(ENEWIDTH-ENEWIDTH/8),D3            
            MOVE.B  #87,D0
            TRAP    #15
            
            ; RIGHT LEG
            SUB.W   #(ENEWIDTH/8),D1                
            SUB.W   #(ENEWIDTH/8),D2
            SUB.W   #(ENEWIDTH/8),D3            
            SUB.W   #(ENEWIDTH/8),D4           
            MOVE.B  #87,D0
            TRAP    #15
               
            UTLSPEN #CLRWHITE              
            UTLSFIL #CLRWHITE             
            
            MOVE.W  (A0),D1                       
            MOVE.W  D1,D3                   
            MOVE.W  D2,D4

            ; EYE
            ADD.W   #(2*(ENEWIDTH/8)),D1        
            ADD.W   #(2*(ENEWIDTH/8)),D2           
            ADD.W   #(6*(ENEWIDTH/8)),D3            
            ADD.W   #(7*(ENEWIDTH/8)),D4           
            MOVE.B  #88,D0
            TRAP    #15
            
            UTLSPEN #CLRBLACK
            UTLSFIL #CLRBLACK
            
            MOVE.W  (A0),D1          
            MOVE.W  2(A0),D2 
            MOVE.W  D1,D3                   
            MOVE.W  D2,D4
            
            ; PUPIL
            ADD.W   #(3*(ENEWIDTH/8)),D1         
            ADD.W   #(3*(ENEWIDTH/8)),D2           
            ADD.W   #(4*(ENEWIDTH/8)),D3            
            ADD.W   #(5*(ENEWIDTH/8)),D4
            MOVE.B  #87,D0
            TRAP    #15
            
            ; EYEBROW
            ADD.W   #(3*(ENEWIDTH/8)),D1         
            SUB.W   #(ENEWIDTH/4),D2
            SUB.W   #(ENEWIDTH/4),D3             
            SUB.W   #(3*(ENEWIDTH/8)),D4      
            MOVE.B  #87,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D4
            RTS




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
