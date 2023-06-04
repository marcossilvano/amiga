;------------------------------
; BOUNCING RASTER LINE
; FULL SCREEN BG
;------------------------------
; Assembly:
;  Ctrl + B
;
; Debug via FS-UAE
;   F12 + D     enable debugger
;   > w 0 100 2 add memory watch for instruction clr.l $100
;   sys:prog    run program
;   > g         continue until memory watch point
;   > t         run step by step
;
; Alternative
;   sys:prog    run program
;   Put mouse wait loop
;   F12 + d     enable debugger
;   > z         step one instruction (the aforementioned)
;   Click       to break the mouse wait loop
;   > t         run step by step

;---------- Main -----------
       ;CMP D0,D1  	Signed  Unsigned   FLAG
       ;D0 >  D1	BLT	    BCS BLO   
       ;D0 >= D1	BLE	    BLS
       ;D0 == D1	BEQ	    BEQ        Z=1    
       ;D0 != D1	BNE	    BNE        Z=0
       ;D0 <  D1	BGT	    BHI
       ;D0 <= D1	BGE	    BCC BHS

**************************************************
* CONSTANTS
**************************************************

       INCDIR      "include"
       INCLUDE     "hw.i"
       INCLUDE     "funcdef.i"
       INCLUDE     "exec/exec_lib.i"
       INCLUDE     "graphics/graphics_lib.i"
       INCLUDE     "hardware/cia.i"

**************************************************
* CONSTANTS
**************************************************

NULL    equ 0

**************************************************
* MACROS
**************************************************

;STRUCTURE   ColourRange,O
;            UBYTE Minimum
;            UBYTE Maximum
;            UBYTE UpDownFlag
;            UBYTE Adjustment
;            ULONG Red
;            ULONG Green
;            ULONG Blue
;            LABEL ColourRange_SIZEOF

**************************************************
* MAIN
**************************************************

;waitmouse:
;    btst    #6,$bfe001
;    bne     waitmouse

start:
    
    ; Func1(param1, param2)
    move.w  #$a,-(sp)   ; param1
    move.w  #$b,-(sp)   ; param2
    jsr     Func1

    ; get return values in stack
    clr.l   d2
    clr.l   d3
    move.w  (sp)+,d2
    move.w  (sp)+,d3

    clr.w   $100        ; BREAKPOINT
check_even:
    move.w  #8,d0
    jsr     IsEvenU
    beq     .even
    move.l  #$ffffffff,d0    ; odd
    bra     .end

    .even:
    move.l  #$eeeeeeee,d0    ; even

    .end:

    clr.l   d0
    rts

**************************************************
* SUBROUTINES
**************************************************

Func1:
    move.w  4(sp),d1    ; param2
    move.w  6(sp),d0    ; param1

    mulu.w  #$100,d0
    mulu.w  #$100,d1

    move.w  d1,4(sp)    ; return by param2
    move.w  d0,6(sp)    ; return by param1

    rts

; Check if number.w is even.
;   param1: d0.w, number to check
;   return: d0.w, 0=even, 1=odd (Z flag)
IsEvenU:
    ;move.l  d0,-(sp)    ; preserve d0 into stack

    divu    #2,d0       ; RRRRQQQQ
    swap    d0          ; QQQQRRRR
    and.l   #$0000ffff,d0

    ;move.l  (sp)+,d0    ; restore d0 from stack
    rts

**************************************************
* DATA/VARIABLES
**************************************************

; dc - define constant
; ds - define storage

text1   dc.b    'Hello World of 68K ASM!',0
    even
text2   ds.b    40