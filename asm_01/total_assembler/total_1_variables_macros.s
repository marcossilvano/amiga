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

NULL    equ 0

**************************************************
* MACROS
**************************************************
; \1.w  number to check
; \2.w  divisor
IsDivisible macro
;IsDivisible:
    move.w  \1,d2       ; copy d1 to d2 and check if d2 is divisible by d3
    divu    \2,d2       ; d2/div = $RRRRQQQQ (long)
    swap    d2          ; $QQQQRRRR
    cmp.w   #0,d2
    bne     .return     ; if can't be divided by d2, return
    move.b  #0,d0

.return:
    endm

; Check if number is prime
; params:
; \1.w  number to check
; returns:
; d0.b    1 if prime, 0 otherwise
IsPrime     macro
IsPrime:
    move.w  \1,d1       ; d1=n
    move.b  #1,d0       ; assume prime

    ;IsDivisible d1,#2
    ;beq     .not_prime

    move.w  #2,d3       ; div=3
    move.w  d1,d4
    divu    #2,d4       ; d4 = d3//2
.loop:
    IsDivisible d1,d3
    beq     .not_prime
    addq.w  #1,d3       ; div += 2
    cmp.w   d4,d3       
    bls     .loop       ; d1/2 > d3? loop

.not_prime:
    endm

; Do some loop tests
LoopsTest   macro
        ; post-test loop

        lea     vet1,a1     ; a1 points to array beginning
        moveq   #10,d0
    loop1:
        move.w  d0,(a1)+    ; loop body

        subq    #1,d0
        bne     loop1       ; branch on not equal to zero

        ; pre-test loop

        lea     vet1,a1     
        moveq   #20,d0
    loop2:
        beq     .end        ; branch on equal to zero

        move.w  d0,(a1)+    ; loop body

        subq    #2,d0
        bra     loop2       ; jmp (unconditional branch)
    .end:

    ;.return:
    endm

; Convert counting string to null-terminated string
; params:
; \1.l  start address of "counting string"
; \2.l  start address of "null-terminated string"
ConvertString macro
ConvertString:
    lea     \1,a0
    lea     \2,a1

    move.b  (a0)+,d0    ; length of counting str
    beq     .return     ; if len=0, return

    subq.b  #1,d0       ; sub count for dbra
.loop
    move.b  (a0)+,(a1)+
    dbra    d0,.loop    ; loop until d0=-1

    move.b  NULL,(a1)   ; NULL terminated

.return:
    endm

; Set a value into all positions of an byte array
; params:
; \1.l  start address of array
; \2.b  length of array
; \3.b  value to set
SetByteArray macro
SetByteArray:
    lea     \1,a0
    move.b  \2,d0
    beq     .return     ; if len=0, return

    subq.b  #1,d0       ; sub count for dbra
.loop:
    move.b  \3,(a0)+
    dbra    d0,.loop    ; loop until d0=-1

.return:
    endm

; Find the length of a null-terminated string
; params:
; \1    start address of "null-terminated string"
; return:
; d0    length of string
LenStr  macro
LenStr:
    lea     \1,a0
    move.b  #0,d0   ; counter
.loop
    addq.b  #1,d0
    cmp.b   #0,(a0)+
    bne     .loop

    subq.b  #1,d0
    endm

**************************************************
* MAIN
**************************************************

;waitmouse:
;    btst    #6,$bfe001
;    bne     waitmouse

start:
    ; variables
    move.w  num2,num3
    move.w  #$abcd,num2
    
    move.w  num3,d0
    not.w   num3
    move.w  num3,d0

    ; addq
    move.b  num1,d1
    addq.b  #1,d1

    addq.b  #1,num1

    ; lea (and pointers)
    move.l  #num1,a1            ; lea num1,a1
    addq.b  #1,(a1)

    lea     num1,a1
    addq.b  #1,(a1)

    ; loops
    LoopsTest

    ; string conventions
    SetByteArray nstr,#0,#0     ; just clear the array

    ConvertString cstr,nstr

    clr.l   d0
    LenStr nstr

    ;clr.l   d7
    ;IsPrime #23
    clr.w   $100                ; BREAKPOINT

    clr.l   d0
    rts

; dc - define constant
; ds - define storage

num1    dc.b    $5
    even
num2    dc.w    $f0     ; allocate 1 byte, initialized to 10
num3    ds.w    $1      ; allocate 1 byte, not initialized
vet1    ds.w    10      ; array of 10 words

cstr    dc.b    0,'APPLE'   ; counting string
nstr    ds.b    6           ; null-terminated string