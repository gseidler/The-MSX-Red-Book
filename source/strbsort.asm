; The MSX Red Book
; Chapter 7 - String Bubble Sort

        ORG     0E000H
        LOAD    0E000H

SORT:   CP      2                   ; Integer type?
        RET     NZ                  ;
        INC     HL                  ; HL->DAC+1
        INC     HL                  ; HL->DAC+2
        LD      E,(HL)              ; Address LSB
        INC     HL                  ; HL->DAC+3
        LD      D,(HL)              ; Address MSB
        EX      DE,HL               ; HL->A$(0)
        PUSH    HL                  ;
        POP     IX                  ; IX->A$(0)
        LD      A,(IX-8)            ; Array type
        CP      3                   ; String Array?
        RET     NZ                  ;
        LD      A,(IX-3)            ; Dimension
        DEC     A                   ; Single dimension?
        RET     NZ                  ;
        LD      C,(IX-2)            ;
        LD      B,(IX-1)            ; BC=Element count
SR2:    PUSH    BC                  ;
        PUSH    HL                  ; HL->Dsc(N)
SR3:    LD      B,(HL)              ; B=Len(N)
        INC     HL                  ;
        LD      E,(HL)              ;
        INC     HL                  ;
        PUSH    HL                  ;
        LD      D,(HL)              ; DE->String(N)
        INC     HL                  ; HL->Dsc(N+1)
        LD      C,(HL)              ; C=Len(N+1)
        INC     HL                  ;
        LD      A,(HL)              ;
        INC     HL                  ;
        PUSH    HL                  ;
        LD      H,(HL)              ;
        LD      L,A                 ; HL->String(N+1)
        EX      DE,HL               ; HL->(N),DE->(N+1)
        INC     B                   ;
        INC     C                   ;
SR4:    DEC     B                   ; Remaining len(N)
        JR      Z,NEXT              ; Z=(N)<=(N+1)
        DEC     C                   ; Remaining len(N+1)
        JR      Z,SWAP              ; Z=(N+1)<(N)
        LD      A,(DE)              ; Chr from (N+1)
        CP      (HL)                ; Chr from (N)
        INC     DE                  ;
        INC     HL                  ;
        JR      Z,SR4               ; Same, continue
        JR      NC,NEXT             ; NC=(N)<(N+1)
SWAP:   POP     HL                  ; HL->Dsc(N+1)
        POP     DE                  ; DE->Dsc(N)
        LD      B,3                 ; Descriptor size
SW2:    LD      A,(DE)              ; Swap descriptors
        LD      C,(HL)              ;
        LD      (HL),A              ;
        LD      A,C                 ;
        LD      (DE),A              ;
        DEC     DE                  ;
        DEC     HL                  ;
        DJNZ    SW2                 ;
        PUSH    IX                  ;
        POP     HL                  ; HL->A$(0)
        OR      A                   ;
        SBC     HL,DE               ; At Array start?
        JR      NC,NX2              ; NC=At start
        DEC     DE                  ; Back up
        DEC     DE                  ;
        EX      DE,HL               ; HL->Dsc(N-1_
        JR      SR3                 ; Go check again
NEXT:   POP     HL                  ; Lose junk
        POP     HL                  ;
NX2:    POP     HL                  ; HL->Dsc(N)
        POP     BC                  ; BC=Element count
        INC     HL                  ; Next descriptor
        INC     HL                  ;
        INC     HL                  ;
        DEC     BC                  ;
        LD      A,B                 ;
        OR      C                   ; Finished?
        JR      NZ,SR2              ;
        RET                         ;

        END
