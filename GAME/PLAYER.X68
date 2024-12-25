* -----------------------------------------------------------------------------
* PLAYER MANAGEMENT
* -----------------------------------------------------------------------------

* -----------------------------------------------------------------------------
PLRINIT
* PLAYER INITIALIZATION
* INPUT     : NONE
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------                     
            MOVE.W  #SCRWIDTH/2,(PLRPOSX)           
            MOVE.L  #(SCRHEIGH/2)<<16,(PLRPOSY)     
            CLR.L   (PLRSPDY)                        
            RTS   
            
* -----------------------------------------------------------------------------
PLR13UPD
* UPDATES THE PLAYER IN LEVELS 1 & 3
* INPUT     : NONE
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------
            MOVEM.W D0-D2,-(A7)
            
            ; UPDATE PLAYER COORDINATES
            MOVE.L  (PLRSPDY),D2                    
            ADD.L   D2,(PLRPOSY)                      
            ADD.L   #PLRACC,D2                       
            
            MOVE.W  (PLRPOSX),D0
            MOVE.W  (PLRPOSY),D1  
            
            ; CHECK PLAYER MOVEMENT
            BTST.B  #0,(KBDVAL)                     
            BEQ     .CHKRIGHT
            SUB.W   #PLRHORSP,D0
    
.CHKRIGHT   BTST.B  #2,(KBDVAL)                     
            BEQ     .CHKHORZ
            ADD.W   #PLRHORSP,D0    
                   
            ; CHECK HORIZONTAL COLISIONS
.CHKHORZ    CMP.W   #SCRWIDTH,D0
            BGT     .COLRGT
            CMP.W   #0,D0
            BLT     .COLLFT
            
            ; CHECK VERTICAL COLLISIONS          
.CHKVERT    CMP.W   #SCRHEIGH-PLRHEIGH/2,D1
            BGT     .COLBOT
            BRA     .DONE
                       
            ; RIGHT COLLISION
.COLRGT     SUB.W   #SCRWIDTH,D0
            BRA     .CHKVERT
            
            ; LEFT COLLISION
.COLLFT     ADD.W   #SCRWIDTH,D0
            BRA     .CHKVERT
            
            ; BOTTOM COLLISION
.COLBOT     MOVE.W  #STAGOVR,(STANEXT)
                                     
            ; STORE POSITION
.DONE       MOVE.W  D0,(PLRPOSX)
            MOVE.W  D1,(PLRPOSY)
            MOVE.L  D2,(PLRSPDY)
            
            MOVEM.W (A7)+,D0-D2            
            RTS      
   
* -----------------------------------------------------------------------------
PLR2UPD
* UPDATES THE PLAYER IN LEVEL 2
* INPUT     : NONE
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------
            MOVEM.W D0-D2,-(A7)
            
            ; UPDATE PLAYER COORDINATES
            MOVE.L  (PLRSPDY),D2                    
            ADD.L   D2,(PLRPOSY)                      
            ADD.L   #PLRACC,D2                      
            
            MOVE.W  (PLRPOSX),D0
            MOVE.W  (PLRPOSY),D1  
            
            ; CHECK PLAYER MOVEMENT
            BTST.B  #0,(KBDVAL)                     
            BEQ     .CHKRIGHT
            SUB.W   #PLRHORSP,D0
    
.CHKRIGHT   BTST.B  #2,(KBDVAL)                     
            BEQ     .CHKHORZ
            ADD.W   #PLRHORSP,D0    
                   
            ; CHECK HORIZONTAL COLISIONS
.CHKHORZ    CMP.W   #SCRWIDTH,D0
            BGT     .COLRGT
            CMP.W   #0,D0
            BLT     .COLLFT
            
            ; CHECK VERTICAL COLLISIONS          
.CHKVERT    CMP.W   #SCRHEIGH-PLRHEIGH/2,D1
            BGT     .COLBOT
            BRA     .DONE
            
            ; RIGHT COLLISION
.COLRGT     SUB.W   #SCRWIDTH,D0
            BRA     .CHKVERT
            
            ; LEFT COLLISION
.COLLFT     ADD.W   #SCRWIDTH,D0
            BRA     .CHKVERT
            
            ; BOTTOM COLLISION
.COLBOT     MOVE.W  #STAGOVR,(STANEXT)
            BRA     .DONE
                       
            ; STORE POSITION
.DONE       MOVE.W  D0,(PLRPOSX)
            MOVE.W  D1,(PLRPOSY)
            MOVE.L  D2,(PLRSPDY)
            
            BTST.B  #4,(KBDEDGE)
            BEQ     .NOFIRE
            
            ; ADD SHOOT SOUND
            MOVE.B  #SNDSHOT,D7
            TRAP    #SNDPLTN
            MOVEM.L A1-A3/D0-D2,-(A7)
            LEA     PLRSHOI,A1
            LEA     PLRSHOU,A2
            LEA     PLRSHOP,A3
            MOVE.W  #SHTTYPE,D0
            MOVE.W  (PLRPOSX),D1
            MOVE.W  (PLRPOSY),D2
            JSR     AGLADD
            
            MOVEM.L (A7)+,A1-A3/D0-D2
                       
.NOFIRE     MOVEM.W (A7)+,D0-D2            
            RTS                     
* -----------------------------------------------------------------------------    
PLRPLOT
* PLAYER PLOT
* INPUT     : NONE
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------
            MOVEM.L  D0-D4,-(A7)
            
            UTLSPEN #PLRPCOL
            UTLSFIL #PLRFCOL
                        
            ;BODY
            CLR     D0
            MOVE.W  (PLRPOSX),D1          
            SUB.W   #PLRWIDTH/2,D1
            ADD.W   #4,D1
            MOVE.W  (PLRPOSY),D2
            MOVE.W  D1,D3
            ADD.W   #16,D3                       
            MOVE.W  D2,D4
            ADD.W   #18,D4
            MOVE.B  #87,D0
            TRAP    #15
                                  
            ;ARMS                        
            ;LEFT ARM
            MOVE.W  (PLRPOSX),D1          
            SUB.W   #PLRWIDTH/2,D1
            MOVE.W  (PLRPOSY),D2
            MOVE.W  D1,D3
            ADD.W   #4,D3
            MOVE.W  D2,D4
            ADD.W   #12,D4
            MOVE.B  #87,D0
            TRAP    #15
            
            ;RIGHT ARM
            MOVE.W  (PLRPOSX),D1          
            ADD.W   #PLRWIDTH/2,D1
            SUB.W   #4,D1
            MOVE.W  D1,D3
            ADD.W   #4,D3
            MOVE.B  #87,D0
            TRAP    #15
            
            ;HEAD 
            MOVE.W  (PLRPOSX),D1          
            SUB.W   #PLRWIDTH/2,D1
            MOVE.W  (PLRPOSY),D2
            SUB.W   #PLRHEIGH/2,D2
            MOVE.W  D1,D3
            ADD.W   #PLRWIDTH,D3                       
            MOVE.W  (PLRPOSY),D4
            MOVE.B  #87,D0
            TRAP    #15
            
            UTLSPEN #CLRBLACK
            UTLSFIL #CLRBLACK
           
            ;LEGS
            MOVE.W  (PLRPOSX),D1         
            SUB.W   #2,D1
            MOVE.W  (PLRPOSY),D2
            ADD.W   #16,D2
            MOVE.W  D1,D3
            ADD.W   #4,D3
            ADD.W   #18,D4
            MOVE.B  #87,D0
            TRAP    #15
            
            ; LEFT EYE
            MOVE.W  (PLRPOSX),D1          
            SUB.W   #PLRWIDTH/2,D1
            ADD.W   #6,D1
            MOVE.W  (PLRPOSY),D2
            SUB.W   #PLRHEIGH/2,D2
            ADD.W   #4,D2
            MOVE.W  D1,D3
            ADD.W   #4,D3
            MOVE.W  D2,D4
            ADD.W   #4,D4
            MOVE.B  #87,D0
            TRAP    #15
            ; RIGHT EYE
            ADD.W   #8,D1
            ADD.W   #8,D3
            MOVE.B  #87,D0
            TRAP    #15
            
            ; MOUTH
            MOVE.W  D1,D3
            SUB.W   #4,D1
            MOVE.W  D4,D2
            ADD.W   #6,D4
            MOVE.B  #87,D0
            TRAP    #15
            ; LEFT WHISKER
            SUB.W   #2,D1
            ADD.W   #2,D2
            SUB.W   #4,D3
            ADD.W   #2,D4
            MOVE.B  #87,D0
            TRAP    #15
            ; RIGHT WHISKER
            ADD.W   #6,D1
            ADD.W   #6,D3
            MOVE.B  #87,D0
            TRAP    #15
            
            ; HEAD DETAILS
            ; LEFT
            MOVE.W  (PLRPOSX),D1          
            SUB.W   #PLRWIDTH/2,D1
            MOVE.W  (PLRPOSY),D2
            SUB.W   #PLRHEIGH/2,D2
            MOVE.W  D1,D3
            ADD.W   #2,D3                       
            MOVE.W  D2,D4
            ADD.W   #2,D4
            MOVE.B  #87,D0
            TRAP    #15
            ; RIGHT
            ADD.W   #21,D1
            ADD.W   #21,D3
            MOVE.B  #87,D0
            TRAP    #15
            
            ;EDGES           
            ;LEFT ARM
            ;UP
            MOVE.W  (PLRPOSX),D1         
            SUB.W   #PLRWIDTH/2,D1
            MOVE.W  (PLRPOSY),D2
            SUB.W   #3,D2
            MOVE.W  D1,D3
            ADD.W   #4,D3
            MOVE.W  D2,D4
            ADD.W   #2,D4
            MOVE.B  #87,D0
            TRAP    #15            
            SUB.W   #2,D3
            ADD.W   #2,D4
            MOVE.B  #87,D0
            TRAP    #15
            ;DOWN
            ADD.W   #14,D2
            ADD.W   #10,D4
            MOVE.B  #87,D0
            TRAP    #15
            
            ;RIGHT ARM
            ;UP
            MOVE.W  (PLRPOSX),D1         
            ADD.W   #PLRWIDTH/2,D1
            SUB.W   #4,D1
            MOVE.W  (PLRPOSY),D2
            SUB.W   #3,D2
            MOVE.W  D1,D3
            ADD.W   #4,D3
            MOVE.W  D2,D4
            ADD.W   #2,D4
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #2,D1
            ADD.W   #2,D4
            MOVE.B  #87,D0
            TRAP    #15
            ;DOWN
            ADD.W   #14,D2
            ADD.W   #10,D4
            MOVE.B  #87,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D4
            RTS








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
