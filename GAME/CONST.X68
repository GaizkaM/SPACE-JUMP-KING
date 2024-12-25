*------------------------------------------------------------------------------
* GAME CONSTANTS
*------------------------------------------------------------------------------

; --- GAME RELATED STATES -----------------------------------------------------

STANONE     EQU     -1                  ; NON-EXISTENT STATE NUMBER (PLACEHOLDER)
STAISC      EQU     0                   ; INTRODUCTION STATE
STAISTR     EQU     1                   ; INSTRUCTIONS STATE
STALVL1     EQU     2                   ; LEVEL 1 GAME STATE
STA1TO2     EQU     3                   ; SCREEN BETWEEN LVL1 AND LVL2
STALVL2     EQU     4                   ; LEVEL 2 GAME STATE
STA2TO3     EQU     5                   ; SCREEN BETWEEN LVL2 AND LVL3
STALVL3     EQU     6                   ; LEVEL 3 GAME STATE
STAWON      EQU     7                   ; WINNING SCREEN STATE
STAGOVR     EQU     8                   ; GAME OVER STATE         
        
; --- STATE RELATED CONSTANTS -------------------------------------------------         
                     
ISCMAXTM    EQU     500                 ; INTRO SCREEN WAITING CYCLES
        
; --- AGENT TYPES -------------------------------------------------------------

PLTTYPE     EQU     1
SHTTYPE     EQU     2
ENETYPE     EQU     3
STARTYPE    EQU     4

; --- PLAYER RELATED CONSTANTS ------------------------------------------------  

PLRWIDTH    EQU     24                  ; PLAYER WIDTH (PIXELS)  
PLRHEIGH    EQU     36                  ; PLAYER HEIGHT (PIXELS) 
PLRPCOL     EQU     $00000000           ; PLAYER CONTOUR COLOR
PLRFCOL     EQU     $0000FF00           ; PLAYER FILL COLOR
PLRHORSP    EQU     6                   ; PLAYER HORIZONTAL SPEED
PLRACC      EQU     $00003FFF           ; PLAYER ACCELERATION  
PLRJMPSP    EQU     $FFF8C000           ; JUMPING INITIAL JUMP SPEED

; --- PLAYER SHOT RELATED CONSTANTS -------------------------------------------

PLRSHWI    EQU     5                    ; PLAYER SHOT WIDTH IN PIXELS
PLRSHHE    EQU     13                   ; PLAYER SHOT HEIGHT IN PIXELS
PLRSHSP    EQU     8                    ; PLAYER SHOT SPEED

; --- PLATFORM RELATED CONSTANTS ----------------------------------------------

PLTWIDTH    EQU     60                  ; PLATFROM WIDTH
PLTHEIGH    EQU     10                  ; PLATFROM HEIGHT
PLTPCOL     EQU     $009E9E9E           ; PLATFROM CONTOUR COLOR
PLTFCOL     EQU     $009E9E9E           ; PLATFROM FILL COLOR
PLTDCOL     EQU     $00FFAE00           ; PLATFORM DECORATION COLOR
MAXPLT      EQU     7                   ; MAXIMUM PLATFORMS ON SCREEN    

; --- ENEMY RELATED CONSTANTS -----------------------------------------------

ENEHEIGH    EQU     33                  ; ENEMY  HEIGHT (PIXELS)
ENEWIDTH    EQU     24                  ; ENEMY  WIDTH (PIXELS)
ENERED      EQU     $000000FF           ; ENEMY  RED COLOR (PEN & FILL)

; --- SCOREBOARD RELATED CONSTANTS --------------------------------------------

SCOFCOL     EQU     $00000000           ; TEXT BACKGROUND COLOR
SCOLINE     EQU     $0101               ; FIRST TEXT LINE COORDINATES 

; --- COLOR RELATED CONSTANTS -------------------------------------------------

CLRWHITE    EQU     $00FFFFFF           ; COLOR WHITE   
CLRBLACK    EQU     $00000000           ; COLOR BLACK

; --- VICTORY RELATED CONSTANTS -----------------------------------------------

WINJUMPS    EQU     50                  ; NUMBER OF JUMPS TO WIN


























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
