; =============================================================================
; STAR MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
;                  - +0 WORD X POSITION
;                  - +2 WORD Y POSITION
;                  - +4 WORD Y SPEED (ALSO AFFECTS SIZE)
; =============================================================================

; -----------------------------------------------------------------------------
STARINIT
; INITALIZES A STAR 
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
            MOVE.W  #1,2(A0)                            
            MOVE.W  #3,4(A0)
            BRA     .END           
            MOVE.W  #1,4(A0)             
.END        MOVE.W  (A7)+,D0
            RTS
            
; -----------------------------------------------------------------------------
STARUPDT
; UPDATES A STAR
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------          
            MOVE.W D0,-(A7)               
            MOVE.W  2(A0),D0
            ADD.W   4(A0),D0
            MOVE.W  D0,2(A0)                                           
            
            ; CHECK BOTTOM BOUNDARY
            CMP.W   #SCRHEIGH-1,2(A0)           
            BGT     .BOUNCEB                    
            BRA     .END

.BOUNCEB    JSR     AGLKILL            
.END        MOVE.W (A7)+,D0
            RTS

; -----------------------------------------------------------------------------
STARPLOT
; PLOTS A STAR
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D5,-(A7)
            UTLSPEN #CLRWHITE
            UTLSFIL #CLRWHITE
            CLR     D0
            MOVE.W  (A0),D1          
            MOVE.W  2(A0),D2           
            MOVE.W  D1,D3                       
            MOVE.W  D2,D4            
            MOVE.W  4(A0),D5
            
            ; PAINT STAR
            LSL     #1,D5
            ADD.W   D5,D3              
            ADD.W   D5,D4           
            MOVE.B  #87,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D5
            RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
