*-----------------------------------------------------------
* Title      : JUMP-SPACE KNIGHT
* Written by : Gaizka Medina & Joaquin Esperon
* Date       : 02-02-24 last commit
* Description: Práctica final de la asignatura de Estructura
*              de Computadores II
*-----------------------------------------------------------
        ORG    $1000

        INCLUDE "GAME/CONST.X68"
        INCLUDE "GAME/SYSCONST.X68"
        INCLUDE "LIB/DMMCONST.X68"
        INCLUDE "LIB/UTLCONST.X68"
        INCLUDE "LIB/DMMCODE.X68"
        INCLUDE "LIB/AGLCODE.X68"
        INCLUDE "LIB/UTLCODE.X68"
        INCLUDE "GAME/PLAYER.X68"
        INCLUDE "GAME/SYSTEM.X68"
        INCLUDE "GAME/PLATFORM.X68"
        INCLUDE "GAME/SCORE.X68"
        INCLUDE "GAME/SPAWNER.X68"
        INCLUDE "GAME/STAR.X68"
        INCLUDE "GAME/PLRSHOT.X68"
        INCLUDE "GAME/ENEMY.X68"
        INCLUDE "GAME/STATES.X68"     
        INCLUDE "GAME/IMAGE.X68"           

; --- INITIALIZATION ---------------------------------------
        
START   ORI.W   #$0700,SR
        JSR     SYSINIT
        JSR     UTLINIT
        JSR     STAINIT         

; --- UPDATE -----------------------------------------------

.LOOP   TRAP    #KBDUPTN            ; READ INPUT DEVICES        
        JSR     STAUPD              ; UPDATE DEPENDING ON THE STATE
        
; --- SYNC -------------------------------------------------

.WINT   TST.B   (SCRINTCT)
        BEQ     .WINT
        CLR.B   (SCRINTCT) 

; --- PLOT -------------------------------------------------
  
        JSR     STAPLOT
        TRAP    #SCRUPTN              ; UPDATE DOUBLE BUFFER
        BRA     .LOOP
        SIMHALT             
            
; --- VARIABLES ---------------------------------------------------------------

        INCLUDE "GAME/VARS.X68"
        INCLUDE "LIB/UTLVARS.X68"
        INCLUDE "GAME/SYSVARS.X68"
        INCLUDE "LIB/DMMVARS.X68"
        END    START        

























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
