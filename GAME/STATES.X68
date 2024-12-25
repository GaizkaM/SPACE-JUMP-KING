; =============================================================================
; GAME STATE MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
STAINIT
; INITALIZES THE STATE MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------            
            MOVE.W  #STANONE,(STACUR)
            MOVE.W  #STAISC,(STANEXT)
            RTS

; -----------------------------------------------------------------------------
STAUPD
; PERFORMS STATE UPDATE AND INIT IF NECESSARY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STANEXT),D0
            CMP.W   (STACUR),D0
            BEQ     .DOUPD
            ; IF STATE CHANGED, DO INIT
            MOVE.W  D0,(STACUR)             
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .INITBL(A0),A0
            JSR     (A0)
            ; IN ANY CASE DO UPDATE
.DOUPD      CLR.L   D0                      
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .UPDTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
            
.INITBL     DC.L    STAISCI,STAINSI,STALVI,STA12I,STALVI,STA23I,STALVI,STAWINI,STAGOVI  
.UPDTBL     DC.L    STAISCU,STAINSU,STALV1U,STA12U,STALV2U,STA23U,STALV3U,STAWINU,STAGOVU

; -----------------------------------------------------------------------------
STAPLOT
; PERFORMS STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .PLTTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
            
.PLTTBL     DC.L    STAISCP,STAINSP,STALV1P,STA12P,STALV2P,STA23P,STALV3P,STAWINP,STAGOVP

; -----------------------------------------------------------------------------
STAEMPTY
; EMPTY SUBROUTINE FOR CASES WITH NOTHING TO DO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A PLACEHOLDER. NOTHING TO DO.
; -----------------------------------------------------------------------------
            RTS
     
       
; =============================================================================
; INTRO STATE MANAGEMENT
; =============================================================================
            
* -----------------------------------------------------------------------------
STAISCI
* INTRO SCREEN INIT
* INPUT     : NONE
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------
            CLR.W   (ISCTIMER)
            ; RESET PLR SCORE 
            CLR.W   (PLRSCOR)
            ; STOP SOUND          
            JSR     SNDSTOP        
            ; PLAY INTRO SOUND                    
            MOVE.B  #SNDINTRO,D7
            TRAP    #SNDPLTN           
            RTS
             
* -----------------------------------------------------------------------------
STAISCU
* INTRO SCREEN UPDATE
* INPUT     : NONE
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            
            ; MOUSE LEFT BUTTON PRESSED?
            BTST.B  #0,(MOUSSTAT)                
            BEQ     .CONT                        
            ; CHECK X COORDINATES
            MOVE.W  (MOUSPOSX),D0                
            CMP.W   #SCRWIDTH/2-45,D0
            BLE     .CONT
            CMP.W   #SCRWIDTH/2+45,D0
            BGE     .CONT
            ; CHECK Y COORDINATES
            MOVE.W  (MOUSPOSY),D1                
            CMP.W   #3*SCRHEIGH/4-10,D1
            BLE     .CONT
            CMP.W   #3*SCRHEIGH/4+25,D1
            BGE     .CONT
            ; GAME STATE            
            MOVE.W  #STALVL1,(STANEXT)
            CLR.W   (MOUSPOSX)
            CLR.W   (MOUSPOSY)
            CLR.B   (MOUSSTAT)
            BRA     .DONE                         
.CONT       ADDQ.W  #1,(ISCTIMER)
            CMP.W   #ISCMAXTM,(ISCTIMER)
            BLT     .DONE
            ; INSTRUCTIONS STATE
            MOVE.W  #STAISTR,(STANEXT)                
.DONE       MOVEM.L (A7)+,D0-D1
            RTS
                      
* -----------------------------------------------------------------------------
STAISCP
* INTRO SCREEN PLOT
* INPUT     : NONE
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------
            MOVEM.L D0-D4/A0,-(A7)            
            
            UTLSPEN #CLRWHITE              
            UTLSFIL #CLRBLACK
            
            ; PRINT LINES
            LEA     .TXT0,A0
            MOVE.B  #10,D0
            JSR     UTLPRINT                                
            LEA     .TXT1,A0
            JSR     UTLPRINT                     
            
            ; PLOT RECTANGLE OF BUTTON
            MOVE.W  #SCRWIDTH/2-45,D1
            MOVE.W  #3*SCRHEIGH/4-10,D2
            MOVE.W  #SCRWIDTH/2+45,D3
            MOVE.W  #3*SCRHEIGH/4+25,D4
            MOVE.B  #87,D0
            TRAP    #15                     
            
            ;MAKE LINE BLINK
            BTST.B  #4,(SCRCYCCT)           
            BEQ     .DONE
            
            ; PRINT LINE
            LEA     .TXT2,A0
            MOVE.B  #24,D0
            JSR     UTLPRINT
            
.DONE       MOVEM.L (A7)+,D0-D4/A0
            RTS

.TXT0       DC.B    'SPACE-JUMP KNIGHT',0
.TXT1       DC.B    'JUMP OVER THE PLATFORMS TO ACHIEVE THE GLORY',0
.TXT2       DC.B    'START',0
            DS.W    0


; =============================================================================
; INSTRUCTIONS STATE MANAGEMENT
; =============================================================================            

; ------------------------------------------------------------------------------
STAINSI
; INSTRUCTIONS SCREEN INIT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            CLR.W   (INSTIMER)
            ; STOP ALL SOUNDS
            JSR     SNDSTOP            
            RTS

; ------------------------------------------------------------------------------
STAINSU
; INSTRUCTIONS SCREEN UPDATE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            
            ; SPACE KEYBOARD PRESSED?
            BTST.B  #4,(KBDVAL)
            BEQ     .DONE
            ; GAME STATE  
            MOVE.W  #STAISC,(STANEXT)                               
.DONE       MOVEM.L (A7)+,D0-D1
            RTS

; ------------------------------------------------------------------------------
STAINSP
; INSTRUCTIONS SCREEN PLOT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D1/A0-A1,-(A7)
            
            UTLSPEN #CLRWHITE              
            UTLSFIL #CLRBLACK
            
            MOVE.B  #10,D0
            ; LOOP TO PRINT LINES           
            LEA     .TXTLST,A1
.LOOP       MOVE.L  (A1)+,D1
            BEQ     .CONT
            MOVE.L  D1,A0
            JSR     UTLPRINT
            BRA     .LOOP
                                           
            ;MAKE LINE BLINK
.CONT       BTST.B  #4,(SCRCYCCT)           
            BEQ     .DONE
            
            ; PRINT LINE
            LEA     .TXT9,A0
            MOVE.B  #24,D0
            JSR     UTLPRINT
                                   
.DONE       MOVEM.L (A7)+,D0-D1/A0-A1
            RTS
            
.TXT1       DC.B    'WELCOME TO JUMP-SPACE KNIGHT!',0
.TXT2       DC.B    'YOUR GOAL IN THIS GAME IS TO COMPLETE ALL OF THE 3 STAGES',0
.TXT3       DC.B    'BY JUMPING FROM ONE PLATFORM TO ANOTHER WITHOUT FALLING',0
.TXT4       DC.B    'THE MOVEMENT IS PRETTY SIMPLE:',0
.TXT5       DC.B    'USE YOUR RIGHT AND LEFT KEYS TO MOVE THE PLAYER.',0
.TXT6       DC.B    'AND USE YOUR SPACEBOARD TO SHOOT',0
.TXT7       DC.B    'WHY? SOON YOU WILL DISCOVER IT...',0
.TXT8       DC.B    'GOOD LUCK!',0
.TXT9       DC.B    'PRESS SPACE TO CONTINUE',0
            DS.W    0
.TXTLST     DC.L    .TXT1,.TXT2,.TXT3,.TXT4,.TXT5,.TXT6,.TXT7,.TXT8,0


; =============================================================================
; LVL 1 STATE MANAGEMENT
; =============================================================================

STALVI
* INITIALIZE LEVEL 1
* INPUT     : NONE
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------
            ; STOP ALL SOUNDS
            JSR          SNDSTOP
            JSR     DMMINIT                
            JSR     PLRINIT
            ; INITIALIZE FIRST PLATFORM
            JSR     PLTFIRST    
            BRA     SCOINIT

* -----------------------------------------------------------------------------
STALV1U
* UPDATES LEVEL 1
* INPUT     : NONE
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------           
            ; CHECK WIN CONDITION
            CMP.W   #WINJUMPS,(SCOIN)
            BGE     .CHGSTA

            JSR     PLR13UPD
            JSR     SPWLV1
            BRA     AGLUPD
            
            RTS
            
.CHGSTA     
            MOVE.W  #STA1TO2,(STANEXT)      
            RTS
                        

* -----------------------------------------------------------------------------
STALV1P
* PLOTS LEVEL 1
* INPUT     : NONE
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------
            JSR     PLRPLOT
            JSR     AGLPLOT
            BRA     SCOPLOT
            
            RTS             
                       
; =============================================================================
; LEVEL 1 TO 2 STATE MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
STA12I
; GAME INTRODUCTION STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ; STOP ALL SOUNDS
            JSR     SNDSTOP    
            ; PLAY STATE SOUND                    
            MOVE.B  #SNDCHG,D7
            TRAP    #SNDPLTN           
            RTS

; -----------------------------------------------------------------------------
STA12U
; GAME INTRODUCTION STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            ; MOUSE LEFT BUTTON PRESSED?
            BTST.B  #0,(MOUSSTAT)                
            BEQ     .DONE                        
            ; CHECK X COORDINATES
            MOVE.W  (MOUSPOSX),D0              
            CMP.W   #SCRWIDTH/2-45,D0
            BLE     .DONE
            CMP.W   #SCRWIDTH/2+45,D0
            BGE     .DONE
            ; CHECK Y COORDINATES
            MOVE.W  (MOUSPOSY),D1                         
            CMP.W   #3*SCRHEIGH/4-10,D1
            BLE     .DONE
            CMP.W   #3*SCRHEIGH/4+25,D1
            BGE     .DONE
            ; GAME STATE  
            MOVE.W  #STALVL2,(STANEXT)
            CLR.W   (MOUSPOSX)
            CLR.W   (MOUSPOSY)
            CLR.B   (MOUSSTAT)
            BRA     .DONE                     
.DONE       MOVEM.L (A7)+,D0-D1
            RTS
            
; -----------------------------------------------------------------------------
STA12P
; GAME INTRODUCTION STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4/A0,-(A7)            
            
            UTLSPEN #CLRWHITE              
            UTLSFIL #CLRBLACK
            
            ; PRINT LINES
            LEA     .TXT0,A0
            MOVE.B  #10,D0
            JSR     UTLPRINT                                
            LEA     .TXT1,A0
            JSR     UTLPRINT
            LEA     .TXT2,A0
            JSR     UTLPRINT                     
            
            ; PLOT RECTANGLE OF BUTTON
            MOVE.W  #SCRWIDTH/2-45,D1
            MOVE.W  #3*SCRHEIGH/4-10,D2
            MOVE.W  #SCRWIDTH/2+45,D3
            MOVE.W  #3*SCRHEIGH/4+25,D4
            MOVE.B  #87,D0
            TRAP    #15                     
            
            ;MAKE LINE BLINK
            BTST.B  #4,(SCRCYCCT)           
            BEQ     .DONE
            
            ; PRINT LINE
            LEA     .TXT3,A0
            MOVE.B  #24,D0
            JSR     UTLPRINT
            
.DONE       MOVEM.L (A7)+,D0-D4/A0
            RTS

.TXT0       DC.B    'GOOD JOB WITH LEVEL 1',0
.TXT1       DC.B    'BUT BE CAREFUL, NOW THERE ARE ENEMIES TRYING TO STOP YOU',0
.TXT2       DC.B    'DONT HESITATE TO USE YOUR WEAPON!',0
.TXT3       DC.B    'GO!',0
            DS.W    0


; =============================================================================
; LEVEL 2 STATE MANAGEMENT
; =============================================================================

* -----------------------------------------------------------------------------
STALV2I
* INITIALIZE LEVEL 2
* INPUT     : NONE
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------
            JSR     DMMINIT     
            JSR     PLRINIT     
            ; STOP ALL SOUNDS
            JSR     SNDSTOP
            ; INIT ONLY FIRST PLATFORM
            JSR     PLTFIRST    
            BRA     SCOINIT
            
* -----------------------------------------------------------------------------
STALV2U
* UPDATES LEVEL 2
* INPUT     : NONE
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------
            ; CHECK IF WE WON LEVEL
            CMP.W   #WINJUMPS,(SCOIN)     
            BGE     .CHGSTA

            JSR     PLR2UPD
            JSR     SPWLV23
            BRA     AGLUPD
                                    
.CHGSTA     
           MOVE.W  #STA2TO3,(STANEXT)      
            RTS            

* -----------------------------------------------------------------------------
STALV2P
* PLOTS LEVEL 2
* INPUT     : NONE
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------
            JSR     AGLPLOT
            JSR     SCOPLOT
            BRA     PLRPLOT
             
; =============================================================================
; LEVEL 2 TO 3 STATE MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
STA23I
; GAME INTRODUCTION STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ; STOP ALL SOUNDS
            JSR     SNDSTOP
            ; PLAY STATE SOUND                    
            MOVE.B  #SNDCHG,D7
            TRAP    #SNDPLTN           
            RTS

; -----------------------------------------------------------------------------
STA23U
; GAME INTRODUCTION STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            ; MOUSE LEFT BUTTON PRESSED?
            BTST    #0,(MOUSSTAT)                
            BEQ     .END                         
            MOVE.W  (MOUSPOSX),D0                
            CMP.W   #SCRWIDTH/2-50,D0
            BLE     .END
            CMP.W   #SCRWIDTH/2+45,D0
            BGE     .END
            MOVE.W  (MOUSPOSY),D1                
            CMP.W   #3*SCRHEIGH/4-10,D1
            BLE     .END
            CMP.W   #3*SCRHEIGH/4+25,D1
            BGE     .END
            ; LEVEL 3 STATE
            MOVE.W  #STALVL3,(STANEXT)
            CLR.W   (MOUSPOSX)
            CLR.W   (MOUSPOSY)
            CLR.B   (MOUSSTAT)
.END        MOVEM.L (A7)+,D0-D1
            RTS
            
; -----------------------------------------------------------------------------
STA23P
; GAME INTRODUCTION STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4/A0,-(A7)            
            
            UTLSPEN #CLRWHITE              
            UTLSFIL #CLRBLACK
            
            ; PRINT LINES
            LEA     .TXT0,A0
            MOVE.B  #10,D0
            JSR     UTLPRINT                                
            LEA     .TXT1,A0
            JSR     UTLPRINT
            LEA     .TXT2,A0
            JSR     UTLPRINT                     
            
            ; PLOT RECTANGLE OF BUTTON
            MOVE.W  #SCRWIDTH/2-45,D1
            MOVE.W  #3*SCRHEIGH/4-10,D2
            MOVE.W  #SCRWIDTH/2+45,D3
            MOVE.W  #3*SCRHEIGH/4+25,D4
            MOVE.B  #87,D0
            TRAP    #15                     
            
            ;MAKE LINE BLINK
            BTST.B  #4,(SCRCYCCT)           
            BEQ     .DONE
            
            ; PRINT LINE
            LEA     .TXT3,A0
            MOVE.B  #24,D0
            JSR     UTLPRINT
            
.DONE       MOVEM.L (A7)+,D0-D4/A0
            RTS

.TXT0       DC.B    'WELL, YOU ARE REALLY GOOD...',0
.TXT1       DC.B    'BUT YOU THINK YOU CAN SURVIVE WITHOUT YOUR WEAPON?',0
.TXT2       DC.B    'GOOD LUCK,BECAUSE YOU REALLY NEED IT!',0
.TXT3       DC.B    'GO!',0
            DS.W    0
            
; =============================================================================
; LEVEL 3 STATE MANAGEMENT
; =============================================================================

* -----------------------------------------------------------------------------
STALV3I
* INITIALIZE LEVEL 3
* INPUT     : NONE
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------
            JSR     DMMINIT     
            JSR     PLRINIT     
            ; STOP ALL SOUNDS
            JSR     SNDSTOP
            ; INIT ONLY FIRST PLATFORM
            JSR     PLTFIRST    
            ; CLEARS PLATFORMS ON SCREEN
            CLR.W   (PLTSCR)    
            BRA     SCOINIT
            
* -----------------------------------------------------------------------------
STALV3U
* UPDATES THE LEVEL 3
* INPUT     : NONE
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------
            ;CHECK IF WE WON LEVEL
            CMP.W   #WINJUMPS,(SCOIN)     
            BGE     .CHGSTA

            JSR     PLR13UPD
            JSR     SPWLV23
            BRA     AGLUPD
                       
            
.CHGSTA     
            MOVE.W  #STAWON,(STANEXT)      
            RTS            

* -----------------------------------------------------------------------------
STALV3P
* PLOTS THE LEVEL 3
* INPUT     : NONE
* OUTPUT    : NONE
* MODIFIES  : NONE
* -----------------------------------------------------------------------------
            JSR     AGLPLOT
            JSR     SCOPLOT
            BRA     PLRPLOT
                        
; =============================================================================
; WIN STATE MANAGEMENT
; =============================================================================

; ------------------------------------------------------------------------------
STAWINI
; WIN SCREEN INITIALIZATION
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D4/A1-A2,-(A7)
            ; STOP ALL SOUNDS
            JSR     SNDSTOP                     
            ; PLAY WIN SOUND                                 
            MOVE.B  #SNDWIN,D7
            TRAP    #SNDPLTN
            
            ; PREPARE FOR FILES
            CLR.L   D1
            CLR.L   D2
            CLR.L   D3
            ;CLOSE ALL FILES
            JSR     UTLFILI
            
            ; READ FROM FILE
            LEA     .FILE,A1
            LEA     .BUFFER,A2
            MOVE.L  #2,D2
            JSR     UTLFILR           
            ; COPY FROM BUFFER TO VAR LASSCOR
            MOVE.W  (.BUFFER),D3
            MOVE.W  D3,(LASSCOR)
            CMP.W    #0,D3
            BNE     .NOT0
            MOVE.W  #0,(LASSCOR)
.NOT0       ;PREPARE TO WRITE
            CLR.W   (.BUFFER)
            CLR.W   D3
            MOVE.W  (PLRSCOR),D3
            MOVE.W  D3,(.BUFFER)
            
            ; WRITE TO FILE
            LEA     .FILE,A1
            LEA     .BUFFER,A2
            CLR.L   D2
            MOVE.L  #2,D2
            JSR     UTLFILW
            
            CLR.W   (.BUFFER)

            MOVEM.L (A7)+,D0-D4/A1-A2
            RTS           
.FILE       DC.B    'SAVE/scores.bin',0
            DS.W    0
.BUFFER     DS.W    1 
; ------------------------------------------------------------------------------
STAWINU
; GAME OVER SCREEN UPDATE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            ; MOUSE LEFT BUTTON PRESSED?
            BTST.B  #0,(MOUSSTAT)                
            BEQ     .DONE                        
            ; CHECK X COORDINATES
            MOVE.W  (MOUSPOSX),D0                
            CMP.W   #SCRWIDTH/2-45,D0
            BLE     .DONE
            CMP.W   #SCRWIDTH/2+45,D0
            BGE     .DONE
            ; CHECK Y COORDINATES
            MOVE.W  (MOUSPOSY),D1                
            CMP.W   #3*SCRHEIGH/4-10,D1
            BLE     .DONE
            CMP.W   #3*SCRHEIGH/4+25,D1
            BGE     .DONE
            ; INTRO STATE            
            MOVE.W  #STAISC,(STANEXT)
            CLR.W   (MOUSPOSX)
            CLR.W   (MOUSPOSY)
            CLR.B   (MOUSSTAT)                            
.DONE       MOVEM.L (A7)+,D0-D1
            RTS
; ------------------------------------------------------------------------------
STAWINP
; GAME OVER SCREEN PLOT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D4/A1,-(A7)            
            
            LEA     IMAGE,A1
            JSR     DRAW_IMAGE
            
            UTLSPEN #CLRWHITE              
            UTLSFIL #CLRBLACK   
                             
            ; PRINT LINES
            LEA     .TXT0,A0
            MOVE.B  #10,D0
            JSR     UTLPRINT                                
            LEA     .TXT1,A0
            JSR     UTLPRINT

            ; PRINT LINE + LAST SCORE
            LEA     .TXT2,A0
            JSR     UTLPRINT
            CLR.L   D1
            MOVE.W  (LASSCOR),D1
            MOVE.B  #40,D2
            MOVE.B  #20,D0
            TRAP    #15
            
            ; PRINT LINE + ACTUAL SCORE
            LEA     .TXT3,A0
            JSR     UTLPRINT
            CLR.L   D1
            MOVE.W  (PLRSCOR),D1
            MOVE.B  #40,D2
            MOVE.B  #20,D0
            TRAP    #15
                                                     
            ; PRINT RECTANGLE OF BUTTON
            MOVE.W  #SCRWIDTH/2-45,D1
            MOVE.W  #3*SCRHEIGH/4-10,D2
            MOVE.W  #SCRWIDTH/2+45,D3
            MOVE.W  #3*SCRHEIGH/4+25,D4
            MOVE.B  #87,D0
            TRAP    #15                     
            
            ;MAKE LINE BLINK
            BTST.B  #4,(SCRCYCCT)           
            BEQ     .DONE
            
            ; PRINT LINE
            LEA     .TXT4,A0
            MOVE.B  #24,D0
            JSR     UTLPRINT
.DONE       MOVEM.L (A7)+,D0-D4/A1
            RTS
            
.TXT0       DC.B    'GCONGRATULATIONS!',0
.TXT1       DC.B    'YOU ARE A MASTER',0 
.TXT2       DC.B    'YOUR LAST SCORE:',0
.TXT3       DC.B    'YOUR SCORE:',0
.TXT4       DC.B    'CONTINUE',0
            DS.W    0 

; =============================================================================
; GAME OVER STATE MANAGEMENT
; =============================================================================

; ------------------------------------------------------------------------------
STAGOVI
; GAME OVER SCREEN INITIALIZATION
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D4/A1-A2,-(A7)
            ; STOP ALL SOUNDS
            JSR     SNDSTOP                     
            ; PLAY WIN SOUND                                 
            MOVE.B  #SNDOVER,D7
            TRAP    #SNDPLTN
            
            ; PREPARE FOR FILES
            CLR.L   D1
            CLR.L   D2
            CLR.L   D3
            ;CLOSE ALL FILES
            JSR     UTLFILI
            
            ; READ FROM FILE
            LEA     .FILE,A1
            LEA     .BUFFER,A2
            MOVE.L  #2,D2
            JSR     UTLFILR           
            ; COPY FROM BUFFER TO VAR LASSCOR
            MOVE.W  (.BUFFER),D3
            MOVE.W  D3,(LASSCOR)
            CMP.W    #0,D3
            BNE     .NOT0
            MOVE.W  #0,(LASSCOR)
.NOT0       ;PREPARE TO WRITE
            CLR.W   (.BUFFER)
            CLR.W   D3
            MOVE.W  (PLRSCOR),D3
            MOVE.W  D3,(.BUFFER)
            
            ; WRITE TO FILE
            LEA     .FILE,A1
            LEA     .BUFFER,A2
            CLR.L   D2
            MOVE.L  #2,D2
            JSR     UTLFILW
            
            CLR.W   (.BUFFER)

            MOVEM.L (A7)+,D0-D4/A1-A2
            RTS           
.FILE       DC.B    'SAVE/scores.bin',0
            DS.W    0
.BUFFER     DS.W    1     

; ------------------------------------------------------------------------------
STAGOVU
; GAME OVER SCREEN UPDATE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            ; MOUSE LEFT BUTTON PRESSED?
            BTST.B  #0,(MOUSSTAT)                
            BEQ     .DONE                        
            ; CHECK X COORDINATES
            MOVE.W  (MOUSPOSX),D0                
            CMP.W   #SCRWIDTH/2-45,D0
            BLE     .DONE
            CMP.W   #SCRWIDTH/2+45,D0
            BGE     .DONE
            ; CHECK Y COORDINATES
            MOVE.W  (MOUSPOSY),D1                
            CMP.W   #3*SCRHEIGH/4-10,D1
            BLE     .DONE
            CMP.W   #3*SCRHEIGH/4+25,D1
            BGE     .DONE
            ; INTRO STATE            
            MOVE.W  #STAISC,(STANEXT)
            CLR.W   (MOUSPOSX)
            CLR.W   (MOUSPOSY)
            CLR.B   (MOUSSTAT)                            
.DONE       MOVEM.L (A7)+,D0-D1
            RTS

; ------------------------------------------------------------------------------
STAGOVP
; GAME OVER SCREEN PLOT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D4/A1-A0,-(A7)

            UTLSPEN #CLRWHITE              
            UTLSFIL #CLRBLACK   
                             
            ; PRINT LINES
            LEA     .TXT0,A0
            MOVE.B  #10,D0
            JSR     UTLPRINT                                
            LEA     .TXT1,A0
            JSR     UTLPRINT

            ; PRINT LINE + LAST SCORE
            LEA     .TXT2,A0
            JSR     UTLPRINT
            CLR.L   D1
            MOVE.W  (LASSCOR),D1
            MOVE.B  #40,D2
            MOVE.B  #20,D0
            TRAP    #15
            
            ; PRINT LINE + ACTUAL SCORE
            LEA     .TXT3,A0
            JSR     UTLPRINT
            CLR.L   D1
            MOVE.W  (PLRSCOR),D1
            MOVE.B  #40,D2
            MOVE.B  #20,D0
            TRAP    #15
                                                     
            ; PRINT RECTANGLE OF BUTTON
            MOVE.W  #SCRWIDTH/2-45,D1
            MOVE.W  #3*SCRHEIGH/4-10,D2
            MOVE.W  #SCRWIDTH/2+45,D3
            MOVE.W  #3*SCRHEIGH/4+25,D4
            MOVE.B  #87,D0
            TRAP    #15                     
            
            ;MAKE LINE BLINK
            BTST.B  #4,(SCRCYCCT)           
            BEQ     .DONE
            
            ; PRINT LINE
            LEA     .TXT4,A0
            MOVE.B  #24,D0
            JSR     UTLPRINT
.DONE       MOVEM.L (A7)+,D0-D4/A1-A0
            RTS
            
.TXT0       DC.B    'GAME OVER',0
.TXT1       DC.B    'YOU HAVE TO PRACTICE MORE...',0 
.TXT2       DC.B    'YOUR LAST SCORE:',0
.TXT3       DC.B    'YOUR SCORE:',0
.TXT4       DC.B    'TRY AGAIN',0
            DS.W    0          


 
    










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
