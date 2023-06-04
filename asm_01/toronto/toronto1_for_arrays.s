;------------------------------
; FOR AND ARRAYS
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
* INCLUDES
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

NULL        equ 0

    STRUCTURE GameObject,0
        WORD    obj_x
        WORD    obj_y
        WORD    obj_spdx
        WORD    obj_spdy
        WORD    obj_health
        LABEL   obj_size

**************************************************
* FUNCTIONS (Macro s +Subroutines)
**************************************************
    jmp     start

; Sum the elements of an array of bytes.
; \1: byte array address    .l
; \2: array size            .w
; out: sum                  d7.w
FnArraySum MACRO
        IFGT NARG-2
            FAIL    !!! ArraySum - too many arguments !!!
        ENDC
        move.l  \1,-(sp)            ; param: array address
        move.w  \2,-(sp)            ; param: array size

        jsr     __FnArraySum        ; call subroutine

        addq    #6,sp               ; remove params
    ENDM

__FnArraySum:
    movem.l d0-d1/a0,-(sp)          ; preserve registers
    cargs #4+12, .array_size.w, .array_adrs.l
        ; get params from stack
        move.l  .array_adrs(sp),a0
        move.w  .array_size(sp),d0

        subq.w  #1,d0               ; n-1 -> n times for dbra
        moveq   #0,d1               ; sum
    .sum_loop:
        add.b   (a0)+,d1
        dbra    d0,.sum_loop        ; branch if Z=0
        
        move.w  d1,d7               ; return

        movem.l (sp)+,d0-d1/a0      ; restore registers
        rts

; STACK:
; top> 12 regs
;      4 return adr
;      2 param size
;      4 param adr

__ArrayTotal:
    cargs #4, .arr_size.w, .arr_adr.l
        rts

**************************************************
* MAIN
**************************************************

start:
    ; sum of array elements

    FnArraySum #arr,#10
    clr.w   $100            ; BREAKPOINT

    ; testing push and pop in the stack

    move.w  #10-1,d0        ; loop 10 times
.stk_loop:
    addq.w  #1,d0
    move.w  d0,-(sp)        ; push 10 rows into stack; values: [1..10]
    subq.w  #1,d0
    dbra    d0,.stk_loop

    add.w   #2*10,sp        ; pop 10 words from stack

;    move.l  #arr,-(sp)
;    move.b  #10,-(sp)
;    jsr ArraySum 
;    move.b  (sp)+,d0
;    addq    #4,sp

    rts

**************************************************
* DATA/VARIABLES
**************************************************

; dc - define constant
; ds - define storage

arr     dc.b    1,2,3,4,5,6,7,8,9,10    ; array of 10 bytes
    even
n       dc.w    10
sum     dc.w    0

text1   dc.b    'Hello World of 68K ASM!',0
    even
text2   ds.b    40