; The MSX Red Book
; Chapter 7 - Graphics Screen Dump

        ORG     0E000H
        LOAD    0E000H

; ******************************
; *   BIOS STANDARD ROUTINES   *
; ******************************

RDVRM:  EQU     004AH
CALATR: EQU     0087H
LPTOUT: EQU     00A5H 

; ******************************
; *     WORKSPACE VARIABLES    *
; ******************************

T32COL: EQU     0F3BFH
GRPNAM: EQU     0F3C7H
GRPCOL: EQU     0F3C9H
GRPCGP: EQU     0F3CBH
MLTNAM: EQU     0F3D1H
MLTCGP: EQU     0F3D5H
RG1SAV: EQU     0F3E0H
RG7SAV: EQU     0F3E6H
NAMBAS: EQU     0F922H
CGPBAS: EQU     0F924H
PATBAS: EQU     0F926H
ATRBAS: EQU     0F928H
SCRMOD: EQU     0FCAFH
HKEYC:  EQU     0FDCCH

; ******************************
; *      CONTROL CHARACTERS    *
; ******************************

CR:     EQU     13
ESC:    EQU     27

ENTRY:  LD      A,(HKEYC)           ; Hook
        CP      0C9H                ; Free to use?
        RET     NZ                  ;
        LD      HL,DUMP             ; Where to go
        LD      (HKEYC+1),HL        ; Redirect hook
        LD      A,0CDH              ; CALL
        LD      (HKEYC),A           ;
        RET                         ;

DUMP:   CP      3AH                 ; ESC key number?
        RET     NZ                  ;
        PUSH    AF                  ;
        PUSH    BC                  ;
        PUSH    DE                  ;
        PUSH    HL                  ;
        LD      (BRKSTK),SP         ; For CTRL-STOP
        LD      C,0                 ; C=Row
DU1:    LD      A,(SCRMOD)          ; Mode
        OR      A                   ;
        LD      HL,240              ; T40 Dots per row
        LD      DE,6*256+40         ;
        JR      Z,DU2               ; 
        LD      HL,256              ; T32,GRP,MLT Dots
        LD      DE,8*256+32         ;
DU2:    LD      A,ESC               ; ***** FX80 *****
        CALL    PRINT               ; *              *
        LD      A,"K"               ; *   Bit mode   *
        CALL    PRINT               ; *              *
        LD      A,L                 ; *  Bytes  LSB  *
        CALL    PRINT               ; *              *
        LD      A,H                 ; *  Bytes  MSB  *
        CALL    PRINT               ; ****************
        LD      B,0                 ; B=Column
DU3:    CALL    CELL                ; Do an 8x8 cell
        PUSH    DE                  ;
        PUSH    BC                  ;
        LD      HL,CBUFF            ; HL->Colours
        LD      B,D                 ; B=Dot cols (6 or 8)
        LD      DE,8                ; CBUFF offset
DU4:    PUSH    BC                  ;
        PUSH    HL                  ;
        LD      B,8                 ; B=Dot rows
DU5:    LD      A,(HL)              ; A=Colour code
        CP      8                   ; Dark or light?
        CCF                         ; Light=Print dot
        RL      C                   ; Build result
        ADD     HL,DE               ; Next dot row
        DJNZ    DU5                 ;
        LD      A,C                 ; 8 Vertical dots
        CALL    PRINT               ;
        POP     HL                  ;
        POP     BC                  ;
        INC     HL                  ; Next dot col
        DJNZ    DU4                 ;
        POP     BC                  ;
        POP     DE                  ;
        INC     B                   ; Next column
        LD      A,B                 ;
        CP      E                   ; End of row?
        JR      NZ,DU3              ;
        LD      A,CR                ; Head left
        CALL    PRINT               ;
        LD      A,ESC               ; ***** FX80 *****
        CALL    PRINT               ; *              *
        LD      A,"J"               ; *  Paper feed  *
        CALL    PRINT               ; *              *
        LD      A,24                ; * 24/216= 1/9" *
        CALL    PRINT               ; ****************
        INC     C                   ; Next row
        LD      A,C                 ;
        CP      24                  ; Finished screen?
        JR      NZ,DU1              ;
DU6:    POP     HL                  ;
        POP     DE                  ;
        POP     BC                  ;
        POP     AF                  ;
        RET                         ;

PRINT:  CALL    LPTOUT              ; To printer
        RET     NC                  ; CTRL-STOP?
        LD      SP,(BRKSTK)         ; Restore stack
        JR      DU6                 ; Terminate program

CELL:   PUSH    BC                  ;
        PUSH    DE                  ;
        PUSH    HL                  ;
        PUSH    IY                  ;
        LD      HL,CBUFF            ; For results
        LD      A,64                ;
CL1:    LD      (HL),0              ; Transparent
        INC     HL                  ;
        DEC     A                   ; Fill
        JR      NZ,CL1              ;
        LD      A,(SCRMOD)          ; Mode
        OR      A                   ; T40?
        PUSH    AF                  ;
        PUSH    BC                  ;
        CALL    NZ,SPRTES           ; Sprites first
        POP     BC                  ;
        LD      L,C                 ;
        LD      H,0                 ; HL=Row
        ADD     HL,HL               ;
        ADD     HL,HL               ;
        ADD     HL,HL               ; HL=Row*8
        LD      E,L                 ;
        LD      D,H                 ; DE=Row*8
        ADD     HL,HL               ;
        ADD     HL,HL               ; HL=Row*32
        POP     AF                  ; Mode
        PUSH    AF                  ;
        JR      NZ,CL2              ; T40?
        ADD     HL,DE               ; HL=Row*40
CL2:    LD      E,B                 ; DE=Column
        ADD     HL,DE               ;
        EX      DE,HL               ; DE=NAMTAB offset
        SUB     2                   ; Mode
        LD      A,C                 ; A=Row
        LD      BC,0                ; BC=CGPTAB offset
        LD      HL,(CGPBAS)         ;
        PUSH    HL                  ;
        LD      HL,(NAMBAS)         ;
        JR      C,CL4               ; C=T40 or T32
        JR      NZ,CL3              ; NZ=MLT
        LD      HL,(GRPCGP)         ; Else GRP
        EX      (SP),HL             ;
        LD      HL,(GRPNAM)         ;
        AND     18H                 ; Row MSBs
        LD      B,A                 ; 1/3=2kB CGP offset
        JR      CL4                 ;
CL3:    LD      HL,(MLTCGP)         ;
        EX      (SP),HL             ;
        LD      HL,(MLTNAM)         ;
        RLCA                        ; Row*2
        AND     6                   ;
        LD      C,A                 ; 1/6=2B CGP offset
CL4:    ADD     HL,DE               ; HL->NAMTAB
        CALL    RDVRM               ; Get chr code
        LD      L,A                 ;
        LD      H,0                 ; HL=Chr code
        ADD     HL,HL               ;
        ADD     HL,HL               ;
        ADD     HL,HL               ; HL=Chr*8
        ADD     HL,BC               ; GRP,MLT offsets
        EX      DE,HL               ; DE=CGPTAB offset
        POP     IY                  ; IY=CGPTAB base
        ADD     IY,DE               ; IY->Pattern
        LD      HL,(GRPCOL)         ;
        ADD     HL,DE               ; HL->GRP colours
        RRCA                        ;
        RRCA                        ;
        RRCA                        ; Chr code/8
        AND     1FH                 ;
        LD      C,A                 ;
        LD      B,0                 ;
        LD      A,(RG7SAV)          ; T40 Colours
        LD      D,A                 ; D=T40 Colours
        AND     0FH                 ;
        LD      E,A                 ; E=Background colour
        POP     AF                  ; Mode
        PUSH    HL                  ; STK->GRP Colours
        DEC     A                   ;
        JR      NZ,CL5              ; Z=T32
        LD      HL,(T32COL)         ;
        ADD     HL,BC               ; HL->T32 Colours
        CALL    RDVRM               ; Get T32 Colours
        LD      D,A                 ; D=T32 Colours
CL5:    LD      HL,CBUFF            ; Results
        LD      B,8                 ; Dot rows
CL6:    PUSH    IY                  ;
        EX      (SP),HL             ; HL->Pattern
        CALL    RDVRM               ; Get pattern
        LD      C,A                 ; C=Pattern
        POP     HL                  ;
        INC     IY                  ; Next dot row
        LD      A,(SCRMOD)          ; Mode
        SUB     2                   ;
        JR      C,CL8               ; C=T40 or T32
        JR      Z,CL7               ; Z=GRP
        LD      D,C                 ; MLT Colours=Pattern
        LD      C,0F0H              ; Dummy MLT pattern
        LD      A,B                 ; Dot row
        CP      5                   ; Cell halfway mark?
        JR      Z,CL8               ;
        DEC     IY                  ; Back up pattern
        JR      CL8                 ;
CL7:    EX      (SP),HL             ; HL->GRP Colours
        CALL    RDVRM               ; Get colours
        LD      D,A                 ; D=GRP Colours
        INC     HL                  ; Next dot row
        EX      (SP),HL             ; STK->GRP Colours
CL8:    PUSH    BC                  ;
        LD      B,8                 ; Dot cols
CL9:    RL      C                   ; Dot from pattern
        INC     (HL)                ;
        DEC     (HL)                ; Check CBUFF clear
        JR      NZ,CL12             ; NZ=Sprite above
        LD      A,D                 ; A=Colours
        JR      NC,CL10             ; NC=0 Pixel
        RRCA                        ;
        RRCA                        ;
        RRCA                        ;
        RRCA                        ; Select 1 colour
CL10:   AND     0FH                 ;
        JR      NZ,CL11             ; Z=Transparent
        LD      A,E                 ; Use background
CL11:   LD      (HL),A              ; Colour in CBUFF
CL12:   INC     HL                  ;
        DJNZ    CL9                 ; Next dot col
        POP     BC                  ;
        DJNZ    CL6                 ; Next dot row
        POP     HL                  ;
        POP     IY                  ;
        POP     HL                  ;
        POP     DE                  ;
        POP     BC                  ;
        RET                         ;

SPRTES: LD      A,B                 ; A=Column
        RLCA                        ;
        RLCA                        ;
        RLCA                        ; A=X coord
        ADD     A,7                 ; RH edge of cell
        LD      B,A                 ; B=X coord
        LD      A,C                 ; A=Row
        RLCA                        ;
        RLCA                        ;
        RLCA                        ; A=Y coord
        ADD     A,7                 ; Bottom of cell
        LD      C,A                 ; C=Y coord
        XOR     A                   ; Sprite number
SS1:    CALL    CALATR              ; HL->Attributes
        LD      D,A                 ; D=Sprite number
        CALL    RDVRM               ; Get Sprite Y
        CP      208                 ; Terminator?
        RET     Z                   ;
        PUSH    DE                  ;
        PUSH    BC                  ;
        CALL    SPRITE              ; Do a sprite
        POP     BC                  ;
        POP     AF                  ;
        INC     A                   ; Next sprite number
        CP      32                  ; Done all?
        JR      NZ,SS1              ;
        RET                         ;

SPRITE: SUB     C                   ; (SY-Y)
        CPL                         ; Make (Y-SY)
        CP      39                  ; Possible overlap?
        RET     NC                  ;
        LD      C,A                 ; C=(Y-SY)
        INC     HL                  ;
        CALL    RDVRM               ; Get Sprite X
        LD      E,A                 ;
        LD      A,B                 ; A=X coord
        SUB     E                   ;
        LD      E,A                 ; E=(X-SX)
        SBC     A,A                 ; Make 16 bit
        LD      D,A                 ; DE=(X-SX)
        INC     HL                  ;
        CALL    RDVRM               ; Get pattern#
        LD      B,A                 ;
        INC     HL                  ;
        CALL    RDVRM               ; Get EC & Colour
        BIT     7,A                 ; Early clock?
        JR      Z,SP1               ;
        LD      HL,32               ;
        ADD     HL,DE               ; Increase (X-SX)
        EX      DE,HL               ;
SP1:    INC     D                   ;
        DEC     D                   ; (X-SX)>255 or neg?
        RET     NZ                  ; NZ-Outside cell
        AND     0FH                 ; Colour
        RET     Z                   ; Z=Transparent
        LD      D,A                 ; D=Colour
        LD      A,(RG1SAV)          ; Flags
        BIT     1,A                 ; SIZE
        RRCA                        ; MAG
        LD      A,8                 ; Minimum size
        JR      NC,SP2              ;
        ADD     A,A                 ; Double for MAG
SP2:    JR      Z,SP3               ;
        RES     0,B                 ; Change pattern#
        RES     1,B                 ;
        ADD     A,A                 ; Double for SIZE
SP3:    LD      L,A                 ; L=Sprite size
        ADD     A,6                 ; Allow cell size
        CP      C                   ;
        RET     C                   ; Sprite above
        CP      E                   ;
        RET     C                   ; Sprite to left
        LD      A,C                 ;
        SUB     7                   ; (Y-SY) from top
        LD      C,A                 ;
        LD      A,L                 ; A=Sprite size
        LD      H,8                 ; Max dot rows
        JR      C,SP5               ; C=Below cell top
        SUB     C                   ; A=Dot row overlap
        CP      9                   ;
        JR      C,SP4               ;
        LD      A,8                 ;
SP4:    LD      H,A                 ; H=Row overlap
SP5:    LD      A,E                 ;
        SUB     7                   ; (X-SX) from cell LH
        LD      E,A                 ;
        LD      A,L                 ; A=Sprite size
        LD      L,8                 ; Max dot cols
        JR      C,SP7               ; C=Past cell LH
        SUB     E                   ; A=Dot col overlap
        CP      9                   ;
        JR      C,SP6               ;
        LD      A,8                 ;
SP6:    LD      L,A                 ; L=Col overlap
SP7:    LD      IY,CBUFF            ; Results
SP8:    PUSH    DE                  ;
        BIT     7,C                 ; Reached sprite?
        JR      NZ,SP15             ;
        PUSH    HL                  ;
        PUSH    IY                  ;
SP9:    BIT     7,E                 ; Reached sprite?
        JR      NZ,SP14             ;
        LD      A,(IY+0)            ; CBUFF
        OR      A                   ; Transparent?
        JR      NZ,SP14             ;
        PUSH    BC                  ;
        PUSH    DE                  ;
        PUSH    HL                  ;
        LD      A,(RG1SAV)          ; Flags
        RRCA                        ; MAG
        JR      NC,SP10             ;
        SRL     C                   ; (Y-SY)/2
        SRL     E                   ; (X-SX)/2
SP10:   BIT     3,E                 ; (X-SX)>7?
        JR      Z,SP11              ;
        RES     3,E                 ; (X-SX)-8
        SET     4,C                 ; (Y-SY)+16
SP11:   LD      L,B                 ;
        LD      H,0                 ; HL=Pattern#
        LD      B,H                 ; BC=Y offset
        ADD     HL,HL               ;
        ADD     HL,HL               ;
        ADD     HL,HL               ; HL=Pattern*8
        ADD     HL,BC               ; Select dot row
        LD      BC,(PATBAS)         ;
        ADD     HL,BC               ; HL->Pattern
        CALL    RDVRM               ; Get dot row
        INC     E                   ;
SP12:   RLCA                        ; Select dot col
        DEC     E                   ;
        JR      NZ,SP12             ;
        JR      NC,SP13             ; NC=0 Pixel
        LD      (IY+0),D            ; Colour in CBUFF
SP13:   POP     HL                  ;
        POP     DE                  ;
        POP     BC                  ;
SP14:   INC     IY                  ;
        INC     E                   ; Right a dot col
        DEC     L                   ; Finished cols?
        JR      NZ,SP9              ;
        POP     IY                  ;
        POP     HL                  ;
SP15:   LD      DE,8                ;
        ADD     IY,DE               ;
        POP     DE                  ;
        INC     C                   ; Down a dot row
        DEC     H                   ; Finished?
        JR      NZ,SP8              ;
        RET                         ;

BRKSTK: DEFW    0                   ; Break stack

; ****************************
; * This buffer holds the 64 *
; * colour codes produced by *
; *       a cell scan:       *
; *                          *
; *   CCCCCCCC Bytes 00-07   *
; *   CCCCCCCC Bytes 08-15   *
; *   CCCCCCCC Bytes 16-23   *
; *   CCCCCCCC Bytes 24-31   *
; *   CCCCCCCC Bytes 32-39   *
; *   CCCCCCCC Bytes 40-47   *
; *   CCCCCCCC Bytes 48-55   *
; *   CCCCCCCC Bytes 56-64   *
; *                          *
; ****************************

CBUFF:  DEFS    64                  ; Cell buffer

        END
