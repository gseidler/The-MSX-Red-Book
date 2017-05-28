; The MSX Red Book
; Chapter 7 - Keyboard Matrix

        ORG     0E000H
        LOAD    0E000H 

; ******************************
; *   BIOS STANDARD ROUTINES   *
; ******************************

INITXT: EQU     006CH
CHPUT:  EQU     00A2H
SNSMAT: EQU     0141H
BREAKX: EQU     00B7H

; ******************************
; *     WORKSPACE VARIABLES    *
; ******************************

INTFLG: EQU     0FC9BH

; ******************************
; *      CONTROL CHARACTERS    *
; ******************************

LF:     EQU     10
HOME:   EQU     11
CR:     EQU     13

MATRIX: CALL    INITXT              ; SCREEN 0
MX1:    LD      A,HOME              ;
        CALL    CHPUT               ; Home Cursor
        XOR     A                   ; A=KBD row
MX2:    PUSH    AF                  ;
        CALL    SNSMAT              ; Read a row
        LD      B,6                 ; Eight cols
MX3:    RLCA                        ; Select col
        PUSH    AF                  ;
        AND     1                   ;
        ADD     A,"0"               ; Result
        CALL    CHPUT               ; Display col
        POP     AF                  ;
        DJNZ    MX3                 ;
        LD      A,CR                ; Newline
        CALL    CHPUT               ;
        LD      A,LF                ;
        CALL    CHPUT               ;
        POP     AF                  ; A=KBD row
        INC     A                   ; Next row
        CP      11                  ; Finished?
        JR      NZ,MX2              ;
        CALL    BREAKX              ; CTRL-STOP
        JR      NC,MX1              ; Continue
        XOR     A                   ;
        LD      (INTFLG),A          ; Clear possible STOP
        RET                         ; Back to BASIC

        END
