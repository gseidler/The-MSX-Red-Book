; The MSX Red Book
; Chapter 7 - String Bubble Sort

                            ORG     0E000H
                            LOAD    0E000H

E000    FE02        SORT:   CP      2                   ; Integer type?
E002    C0                  RET     NZ                  ;
E003    23                  INC     HL                  ; HL->DAC+1
E004    23                  INC     HL                  ; HL->DAC+2
E005    5E                  LD      E,(HL)              ; Address LSB
E006    23                  INC     HL                  ; HL->DAC+3
E007    56                  LD      D,(HL)              ; Address MSB
E008    EB                  EX      DE,HL               ; HL->A$(0)
E009    E5                  PUSH    HL                  ;
E00A    DDE1                POP     IX                  ; IX->A$(0)
E00C    DD7EF8              LD      A,(IX-8)            ; Array type
E00F    FE03                CP      3                   ; String Array?
E011    C0                  RET     NZ                  ;
E012    DD7EFD              LD      A,(IX-3)            ; Dimension
E015    3D                  DEC     A                   ; Single dimension?
E016    C0                  RET     NZ                  ;
E017    DD4EFE              LD      C,(IX-2)            ;
E01A    DD46FF              LD      B,(IX-1)            ; BC=Element count
E01D    C5          SR2:    PUSH    BC                  ;
E01E    E5                  PUSH    HL                  ; HL->Dsc(N)
E01F    46          SR3:    LD      B,(HL)              ; B=Len(N)
E020    23                  INC     HL                  ;
E021    5E                  LD      E,(HL)              ;
E022    23                  INC     HL                  ;
E023    E5                  PUSH    HL                  ;
E024    56                  LD      D,(HL)              ; DE->String(N)
E025    23                  INC     HL                  ; HL->Dsc(N+1)
E026    4E                  LD      C,(HL)              ; C=Len(N+1)
E027    23                  INC     HL                  ;
E028    7E                  LD      A,(HL)              ;
E029    23                  INC     HL                  ;
E02A    E5                  PUSH    HL                  ;
E02B    66                  LD      H,(HL)              ;
E02C    6F                  LD      L,A                 ; HL->String(N+1)
E02D    EB                  EX      DE,HL               ; HL->(N),DE->(N+1)
E02E    04                  INC     B                   ;
E02F    0C                  INC     C                   ;
E030    05          SR4:    DEC     B                   ; Remaining len(N)
E031    2B25                JR      Z,NEXT              ; Z=(N)<=(N+1)
E033    0D                  DEC     C                   ; Remaining len(N+1)
E034    2808                JR      Z,SWAP              ; Z=(N+1)<(N)
E036    1A                  LD      A,(DE)              ; Chr from (N+1)
E037    BE                  CP      (HL)                ; Chr from (N)
E038    13                  INC     DE                  ;
E039    23                  INC     HL                  ;
E03A    28F4                JR      Z,SR4               ; Same, continue
E03C    301A                JR      NC,NEXT             ; NC=(N)<(N+1)
E03E    E1          SWAP:   POP     HL                  ; HL->Dsc(N+1)
E03F    D1                  POP     DE                  ; DE->Dsc(N)
E040    0603                LD      B,3                 ; Descriptor size
E042    1A          SW2:    LD      A,(DE)              ; Swap descriptors
E043    4E                  LD      C,(HL)              ;
E044    77                  LD      (HL),A              ;
E045    79                  LD      A,C                 ;
E046    12                  LD      (DE),A              ;
E047    1B                  DEC     DE                  ;
E048    2B                  DEC     HL                  ;
E049    10F7                DJNZ    SW2                 ;
E04B    DDE5                PUSH    IX                  ;
E04D    E1                  POP     HL                  ; HL->A$(0)
E04E    B7                  OR      A                   ;
E04F    ED52                SBC     HL,DE               ; At Array start?
E051    3007                JR      NC,NX2              ; NC=At start
E053    1B                  DEC     DE                  ; Back up
E054    1B                  DEC     DE                  ;
E055    EB                  EX      DE,HL               ; HL->Dsc(N-1_
E056    18C7                JR      SR3                 ; Go check again
E058    E1          NEXT:   POP     HL                  ; Lose junk
E059    E1                  POP     HL                  ;
E05A    E1          NX2:    POP     HL                  ; HL->Dsc(N)
E05B    C1                  POP     BC                  ; BC=Element count
E05C    23                  INC     HL                  ; Next descriptor
E05D    23                  INC     HL                  ;
E05E    23                  INC     HL                  ;
E05F    0B                  DEC     BC                  ;
E060    78                  LD      A,B                 ;
E061    B1                  OR      C                   ; Finished?
E062    20B9                JR      NZ,SR2              ;
E064    C9                  RET                         ;

                            END
