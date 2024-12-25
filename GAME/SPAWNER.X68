; =============================================================================
; SPAWNER MANAGEMENT.
; =============================================================================

; -----------------------------------------------------------------------------
SPWLV1
; UPDATES THE SPAWNER ON LEVEL 1
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; ----------------------------------------------------------------------------- 
            MOVEM.L D0-D3/A1-A3,-(A7)
            ; EVERY 32 CYCLES
            MOVE.B  (SCRCYCCT),D0
            AND     #%00011111,D0               
            BNE     .END
            
.CRESTAR    LEA     STARINIT,A1
            LEA     STARUPDT,A2
            LEA     STARPLOT,A3
            MOVE.W  #STARTYPE,D0
            ; ADD STAR
            JSR     AGLADD              
            ;CHECK MAX. NUM. PLATFORMS
            CMP.W   #MAXPLT,(PLTSCR)    
            BGE     .END
            
.CREPLT     JSR     UTLRAND
            AND.L   #$00000006,D0
            LEA     .X,A1
            MOVE.W  (A1,D0),D1
            MOVE.W  (POSXLST),D2
            ADD.W   D1,D2
            
            ; RIGHT SIDE
            CMP.W   #SCRWIDTH,D2
            BGT     .CREPLT                          
            
            ; LEFT SIDE
            CMP.W   #0,D2
            BLE     .CREPLT                          
            MOVE.W  D2,(POSXLST)            
            
            ;UPDATE Y
            JSR     UTLRAND
            AND.L   #$00000006,D0
            LEA     .Y,A2
            MOVE.W  (A2,D0),D2
            MOVE.W  (POSYLST),D3
            ADD.W   D2,D3
            
            CMP.W   #0,D3
            ; IF SPAWN = UP -> DONT PLOT
            BLE     .SETY             
            
            ADD.W   D2,(POSYLST)
            BRA     .CALL

.SETY       MOVE.W   #200,(POSYLST)
          
.CALL       LEA     PLTINIT,A1
            LEA     PLTUPD,A2
            LEA     PLTPLOT,A3
            MOVE.W  #PLTTYPE,D0
            JSR     AGLADD
            ADD.W  #1,(PLTSCR)

.END        MOVEM.L (A7)+,D0-D3/A1-A3
            RTS
            
.X          DC.W    150, -75, 75, -150 
  
.Y          DC.W    0, -50, -75, -100 

; -----------------------------------------------------------------------------
SPWLV23
; UPDATES THE SPAWNER ON LEVELS 2 & 3
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; ----------------------------------------------------------------------------- 
            MOVEM.L D0-D3/A1-A3,-(A7)
            ; EVERY 32 CYCLES
            MOVE.B  (SCRCYCCT),D0
            AND     #%00011111,D0               
            BNE     .END
            
.CRESTAR    LEA     STARINIT,A1
            LEA     STARUPDT,A2
            LEA     STARPLOT,A3
            MOVE.W  #STARTYPE,D0
            ; ADD STAR
            JSR     AGLADD              
            ;CHECK MAX. NUM. PLATFORMS
            CMP.W   #MAXPLT,(PLTSCR)    
            BGE     .END
            
.CREPLT     JSR     UTLRAND
            AND.L   #$00000006,D0
            LEA     .X,A1
            MOVE.W  (A1,D0),D1
            MOVE.W  (POSXLST),D2
            ADD.W   D1,D2
            
            ; RIGHT SIDE
            CMP.W   #SCRWIDTH,D2
            BGT     .CREPLT                          
            CMP.W   #0,D2
            ; LEFT SIDE
            BLE     .CREPLT                          
            MOVE.W  D2,(POSXLST)            
            
            ;UPDATE Y
            JSR     UTLRAND
            AND.L   #$00000006,D0
            LEA     .Y,A2
            MOVE.W  (A2,D0),D2
            MOVE.W  (POSYLST),D3
            ADD.W   D2,D3
            
            CMP.W   #0,D3
            ; IF SPAWN = UP -> DONT PLOT
            BLE     .SETY             
            
            ADD.W   D2,(POSYLST)
            BRA     .CALL

.SETY       MOVE.W   #150,(POSYLST)
          
.CALL       LEA     PLTINIT,A1
            LEA     PLTUPD,A2
            LEA     PLTPLOT,A3
            MOVE.W  #PLTTYPE,D0
            JSR     AGLADD
            ADD.W  #1,(PLTSCR)
   
            ; EVERY 128 CYCLES
.CREENE     MOVE.B  (SCRCYCCT),D0
            AND     #%01111111,D0               
            BNE     .END
            CMP.W   #10,(SCOIN)   
            BLT     .END                
            
            ; +10 JUMPS
            LEA     ENEINIT,A1          
            LEA     ENEUPDT,A2
            LEA     ENEPLOT,A3
            MOVE.W  #ENETYPE,D0
            JSR     AGLADD
 
.END        MOVEM.L (A7)+,D0-D3/A1-A3
            RTS
            
                        
.X          DC.W    150, -75, 75, -150 
  
.Y          DC.W    0, -50, -75, -100           



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
