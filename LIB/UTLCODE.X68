; =============================================================================
; UTILITY CODE
; =============================================================================

; -----------------------------------------------------------------------------
UTLINIT
; INITIALIZES UTILITY CODE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            MOVE.B  #8,D0
            TRAP    #15
            MOVE.B  D1,(UTLRNDIX)
            MOVEM.L (A7)+,D0-D1
            RTS
            
; -----------------------------------------------------------------------------
UTLPRINT
; PRINT SCREEN CENTERED TEXT
; INPUT    - A0 POINTER TO ZERO-TERMINATED STRING
;            D0.B SCREEN ROW TO PRINT TEXT
; OUTPUT   - D0.B NEXT ROW
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------          
            MOVEM.L D0-D1/A0-A1,-(A7)
            CLR.B   D1
            MOVE.L  A0,A1
.LOOP       TST.B   (A0)+
            BEQ     .ENDLOOP
            ADDQ.B  #1,D1
            BRA     .LOOP
            
.ENDLOOP    LSR.B   #1,D1
            SUB.B   #(SCRWIDTH/UTLCHRWD)/2,D1
            NEG.B   D1
            ASL.W   #8,D1
            OR.W    D0,D1
            MOVE.B  #11,D0
            TRAP    #15
            MOVE.B  #13,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D1/A0-A1
            ADDQ.B  #1,D0
            RTS

; -----------------------------------------------------------------------------
UTLCHCOL
; CHECKS COLLISION
; INPUT    - D0.W X0 COORDINATE
;            D1.W Y0 COORDINATE
;            D2.W X1 COORDINATE
;            D3.W Y1 COORDINATE
;            D4.W WIDTH 0
;            D5.W WIDTH 1
;            D6.W HEIGHT 0
;            D7.W HEIGHT 1
; OUTPUT   - D0.B=FF - COLLISION, =0 - NO COLLISION
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.W D4-D7,-(A7)
            ADD.W   D0,D4
            CMP.W   D2,D4
            BLE     .NOCOL
            ADD.W   D2,D5
            CMP.W   D0,D5
            BLE     .NOCOL
            ADD.W   D1,D6
            CMP.W   D3,D6
            BLE     .NOCOL
            ADD.W   D3,D7
            CMP.W   D1,D7
            BLE     .NOCOL
            MOVE.B  #$FF,D0
            BRA     .END
.NOCOL      CLR.B   D0
.END        MOVEM.W (A7)+,D4-D7
            RTS
            
; -----------------------------------------------------------------------------
UTLRAND
; PROVIDES A PSEUDO-RANDOM BYTE
; INPUT    - NONE
; OUTPUT   - D0.L RANDOM VALUE (ONLY BYTE)
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.L  A0,-(A7)
            LEA     .RANDVEC,A0
            CLR.L   D0
            MOVE.B  (UTLRNDIX),D0
            MOVE.B  (A0,D0.L),D0
            ADDQ.B  #1,(UTLRNDIX)
            MOVE.L  (A7)+,A0
            RTS


.RANDVEC    DC.B    162, 238, 154, 12 , 245, 36 , 32 , 103
            DC.B    42 , 163, 81 , 38 , 224, 172, 19 , 69
            DC.B    117, 81 , 202, 253, 51 , 235, 108, 154
            DC.B    96 , 204, 231, 184, 154, 235, 34 , 203
            DC.B    29 , 118, 181, 149, 176, 137, 62 , 108
            DC.B    57 , 21 , 72 , 201, 110, 202, 159, 41
            DC.B    67 , 231, 226, 124, 55 , 37 , 84 , 62
            DC.B    233, 148, 206, 233, 228, 82 , 243, 78
            DC.B    55 , 109, 154, 132, 162, 40 , 30 , 39
            DC.B    25 , 226, 198, 119, 128, 212, 232, 225
            DC.B    10 , 90 , 50 , 103, 51 , 194, 222, 40
            DC.B    89 , 128, 220, 14 , 87 , 252, 243, 252
            DC.B    138, 171, 188, 247, 7  , 77 , 29 , 234
            DC.B    239, 213, 119, 110, 30 , 187, 131, 23
            DC.B    214, 224, 42 , 143, 189, 40 , 212, 130
            DC.B    19 , 79 , 102, 236, 10 , 100, 122, 188
            DC.B    86 , 82 , 154, 22 , 155, 144, 7  , 199
            DC.B    6  , 138, 164, 247, 1  , 218, 166, 82
            DC.B    242, 231, 119, 40 , 177, 118, 220, 102
            DC.B    164, 66 , 227, 129, 177, 103, 165, 108
            DC.B    191, 206, 250, 22 , 191, 56 , 30 , 161
            DC.B    209, 139, 80 , 12 , 95 , 73 , 168, 56
            DC.B    222, 76 , 20 , 162, 64 , 220, 93 , 12
            DC.B    182, 155, 10 , 56 , 93 , 171, 89 , 6
            DC.B    226, 27 , 221, 117, 21 , 130, 101, 18
            DC.B    138, 38 , 81 , 48 , 159, 71 , 57 , 21
            DC.B    30 , 138, 187, 113, 198, 110, 185, 152
            DC.B    159, 71 , 229, 52 , 148, 39 , 77 , 6
            DC.B    125, 6  , 214, 186, 48 , 15 , 212, 22
            DC.B    236, 127, 126, 3  , 207, 45 , 193, 2
            DC.B    148, 91 , 35 , 242, 139, 205, 248, 237
            DC.B    116, 51 , 236, 185, 15 , 213, 221, 6
            
; =============================================================================
; FILE RELATED UTILITY CODE
; =============================================================================

; ------------------------------------------------------------------------------
UTLFILI
; INITIALIZE FILE OPERATIONS
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVE.W  D0,-(A7)
            ; CLOSE ALL FILES
            MOVE.B  #50,D0
            TRAP    #15
            MOVE.W  (A7)+,D0
            RTS

; ------------------------------------------------------------------------------
UTLFILW
; WRITES A FILE
; INPUT    : A1 - POINTER TO THE FILE NAME
;            A2 - POINTER TO THE BUFFER
;            D2.L - NUMBER OF BYTES TO WRITE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D1/A1,-(A7)
            ; OPEN FILE POINTED BY A1
            MOVE.B  #52,D0
            TRAP    #15
            ; WRITE DATA FROM BUFFER TO FILE
            MOVE.L  A2,A1
            MOVE.B  #54,D0
            TRAP    #15
            ; CLOSE FILE
            MOVE.B  #56,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D1/A1
            RTS
            
; ------------------------------------------------------------------------------
UTLFILR
; READS A FILE
; INPUT    : A1 - POINTER TO THE FILE NAME
;            A2 - POINTER TO THE BUFFER
;            D2.L - NUMBER OF BYTES TO READ
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D1/A1,-(A7)
            ; OPEN FILE POINTED BY A1
            MOVE.B  #51,D0
            TRAP    #15
            ; READ DATA FROM FILE TO BUFFER
            MOVE.L  A2,A1
            MOVE.B  #53,D0
            TRAP    #15
            ; CLOSE FILE
            MOVE.B  #56,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D1/A1
            RTS
            
; =============================================================================
; UTILITY MACROS
; =============================================================================

; -----------------------------------------------------------------------------
SYSSETIM    MACRO
; DEFINE THE INTERRUPT MASK
; INPUT    : \1 NEW INTERRUPT MASK
; OUTPUT   : NONE
; MODIFIES : D0.W IF \1<>0 AND \1<>7
; -----------------------------------------------------------------------------
            ; IF \1==0 SET IM TO 0
            IFEQ    \1                      
            AND.W   #$F8FF,SR                
            MEXIT
            ENDC           
            ; IF \1==7 SET IM TO 7
            IFEQ    \1-7                     
            OR.W    #$0700,SR                
            MEXIT
            ENDC
            ; COPY SR
            MOVE.W  SR,D0                   
            AND.W   #$F8FF,D0               
            ; INTERRUPT MASK TO DESIGNED VALUE
            OR.W    #(\1&7)<<8,D0
            ; STORE SR
            MOVE.W  D0,SR                   
            ENDM

* -----------------------------------------------------------------------------
UTLSPEN     MACRO
* WRAPPER FOR SET PEN TRAP 15 TASK.
* INPUT    - \1 COLOR IN FORMAT $00BBGGRR
* OUTPUT   - NONE
* MODIFIES - D0,D1
* -----------------------------------------------------------------------------
            MOVE.B  #80,D0
            MOVE.L  \1,D1
            TRAP    #15
            ENDM

* -----------------------------------------------------------------------------
UTLSFIL     MACRO
* WRAPPER FOR SET FIL TRAP 15 TASK.
* INPUT    - \1 COLOR IN FORMAT $00BBGGRR
* OUTPUT   - NONE
* MODIFIES - D0,D1
* -----------------------------------------------------------------------------
            MOVE.B  #81,D0
            MOVE.L  \1,D1
            TRAP    #15
            ENDM




*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
