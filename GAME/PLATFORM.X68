*  ----------------------------------------------------------------------------
* PLATFORM MANAGEMENT (AGENT)
* PLTPOSX (W)  (A0)
* PLTPOSY (W) 2(A0)
* PLTVELX (W) 4(A0)  
* -----------------------------------------------------------------------------

* -----------------------------------------------------------------------------
PLTINIT
* INITIALIZE A PLATFORM
* INPUT     : A0 POINTER TO THE INSTANCE VARIABLES
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------           
            MOVE.W  (POSXLST),(A0)
            MOVE.W  (POSYLST),2(A0)            
            RTS

* -----------------------------------------------------------------------------
PLTUPD
* UPDATES A PLATFORM
* INPUT     : A0 POINTER TO THE INSTANCE VARIABLES
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------
            MOVEM.W D0-D5,-(A7)

            ; UPDATE PLATFORM COORDINATES
            MOVE.W  (A0),D0
            MOVE.W  2(A0),D1
            
            ; CHECK VERTICAL LEVEL       
            MOVE.W  #(SCRHEIGH/2)*1,D2  
            CMP.W   (PLRPOSY),D2    
            BGT     .BAJAR
            
            ; CHECK OUT OF SCREEN           
.CHKKILL    CMP.W   #SCRHEIGH,D1
            BGT     .KILL
            BRA     .CHKNEGVEL
            
.BAJAR      ADDI.W  #2,D1   
            BRA     .CHKKILL   
      
            ; CHECK IF VELOCITY IS NEGATIVE     
.CHKNEGVEL  MOVE.L  (PLRSPDY),D3                    
            CMP.L   #0,D3
            ; IF VEL <= 0 JUMP
            BLE     .DONE                            
            
            ; CHECK PLAYER COLLISION
.CHKPLR     MOVE.W  (A0),D4                         
            SUB.W   (PLRPOSX),D4                     
            BPL     .ISPOS
            NEG.W   D4
      
.ISPOS      CMP.W   #PLTWIDTH/2+PLRWIDTH/2,D4
            BGT     .DONE
            
            ; CHECK HORIZONTAL
            MOVE.W  2(A0),D5
            SUB.W   (PLRPOSY),D5
            BPL     .ISPOS2
            NEG.W   D5

.ISPOS2     CMP.W   #PLTHEIGH/2+PLRHEIGH/2,D5
            BGT     .DONE
            
            ; PLATFORM COLLISION
            ADDQ.W  #1,(SCOIN)
            ADDQ.W  #1,(PLRSCOR)                                 
            MOVE.B  #SNDWALL,D7                     
            TRAP    #SNDPLTN                        
    
            ; VELOCITY CHANGE(BOUNCE)
            CLR.L   D3                
            MOVE.L  #PLRJMPSP,(PLRSPDY)                   
            BRA     .DONE     

.KILL       JSR AGLKILL
            SUB.W   #1,(PLTSCR)
   
            ; STORE POSITION
.DONE       MOVE.W  D0,(A0)
            MOVE.W  D1,2(A0)
            *MOVE.L  D3,(PLRSPDY)

            MOVEM.W (A7)+,D0-D5
            RTS
            
* -----------------------------------------------------------------------------
PLTPLOT
* PLOT A PLATFORM
* INPUT     : A0 POINTER TO THE INSTANCE VARIABLES
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------
            MOVEM.L  D0-D4,-(A7)
           
            ; SET CONTOUR COLOR
            MOVE.B  #80,D0
            MOVE.L  #PLTPCOL,D1
            TRAP    #15
            
            ; SET FILL COLOR
            MOVE.B  #81,D0
            MOVE.L  #PLTFCOL,D1
            TRAP    #15

            ; FIRST RECTANGLE
            CLR     D0
            MOVE.W  (A0),D1          
            SUB.W   #PLTWIDTH/2,D1
            MOVE.W  2(A0),D2
            SUB.W   #PLTHEIGH/2,D2
            MOVE.W  D1,D3
            ADD.W   #PLTWIDTH,D3                       
            MOVE.W  D2,D4
            ADD.W   #PLTHEIGH/2,D4
            MOVE.B  #87,D0
            TRAP    #15
            
            ; SECOND RECTANGLE
            ADD.W   #PLTWIDTH/4,D1
            ADD.W   #PLTHEIGH/2,D2
            SUB.W   #PLTWIDTH/4,D3
            ADD.W   #PLTHEIGH/4,D4
            MOVE.B  #87,D0
            TRAP    #15
            
            ; THIRD RECTANGLE
            ADD.W   #PLTWIDTH/8,D1
            ADD.W   #PLTHEIGH/4,D2
            SUB.W   #PLRWIDTH/4,D3
            ADD.W   #PLTHEIGH/8,D4
            MOVE.B  #87,D0
            TRAP    #15
                       
            MOVEM.L D1,-(A7)
            ; SET CONTOUR COLOR
            MOVE.B  #80,D0
            MOVE.L  #PLTDCOL,D1
            TRAP    #15           
            ; SET FILL COLOR
            MOVE.B  #81,D0
            MOVE.L  #PLTDCOL,D1
            TRAP    #15
            MOVEM.L (A7)+,D1
            
            ; FOURTH RECTANGLE (DECORATION)
            SUB.W   #PLRHEIGH/8,D2
            SUB.W   #PLRHEIGH/8,D4
            MOVE.W  #87,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D4
            RTS

* -----------------------------------------------------------------------------
PLTFIRST
* INITIALIZE THE FIRST PLATFORM
* INPUT     : A0 POINTER TO THE INSTANCE VARIABLES
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------
            ; CLEARS PLATFORMS ON SCREEN
            CLR.W   (PLTSCR)            
            LEA     INITFIRST,A1
            LEA     PLTUPD,A2
            LEA     PLTPLOT,A3
            MOVE.W  #PLTTYPE,D0
            JSR     AGLADD                  
            RTS

INITFIRST
            MOVE.W  #SCRWIDTH/2,(POSXLST) 
            MOVE.W  #(SCRHEIGH/4)*3,(POSYLST)
            MOVE.W  #SCRWIDTH/2,(A0) 
            MOVE.W  #(SCRHEIGH/4)*3,2(A0)           
            RTS


















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
