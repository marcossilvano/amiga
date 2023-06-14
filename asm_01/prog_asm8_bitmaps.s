;------------------------------
; Displaying bitmaps
;------------------------------
; Assembly:
;  Ctrl + B

;---------- Main -----------
       ; CMP B,A  	Signed Unsigned   FLAG
       ; B >  A	BLT	BCS BLO    C=0
       ; B >= A	BLE	BLS
       ; B == A	BEQ	BEQ        Z=1    
       ; B != A	BNE	BNE        Z=0
       ; B <  A	BGT	BHI
       ; B <= A	BGE	BCC BHS    C=1

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
* CONST
**************************************************

MOUSE_REG     = $bfe001  ; mouse button state register
MBUTTON_1     = 6        ; bit 6 in MOUSE_REG indicates button 1

VPOS_REG      = $dff006  ; raster vertical position register
BG_COLOR_ADR  = $dff180  ; background color address

INTS_WRITE = $dff09a
INTS_READ  = $dff01c

COPPER_ADR = $dff080

COL_WHITE  = $fff
COL_BLACK  = $000

TRUE  = 1
FALSE = 0

**************************************************
* MACROS
**************************************************
       jmp init

; Update cooper "metal" bar position in copper list
; \1.w: 	y position of the bar first line 
FnUpdateCopperBar MACRO
       move.w \1,-(sp)
       jsr    __FnUpdateCopperBar
       addq   #2,sp
       ENDM

__FnUpdateCopperBar:
       movem.l       d0-d1/a0,-(sp)
       cargs #4+12,.pos_y.w
              move.w .pos_y(sp),d0        ; get params

              move.l #waitras1,a0
              moveq  #6-1,d1              ; counter
       .bar_loop:
              move.b d0,(a0)
              addq.b #1,d0
              addq.w #8,a0                ; number of bytes to reach the next WAIT_POS instruction
              dbra   d1,.bar_loop         ; test, decrease and jump if Z=0

       movem.l       (sp)+,d0-d1/a0
       rts

; Check if value is between interval.
; \1.w: 	lower limit
; \2.w: 	upper limit
; \3.w: 	value to test
; d7.b: 	return True(1) or False(0)
FnInInterval MACRO
       move.w  \1,-(sp)            ; lower
       move.w  \2,-(sp)            ; upper
       move.w  \3,-(sp)            ; value
       jsr     __FnInInterval      ; call function
       addq    #6,sp               ; remove params
       ENDM

__InInterval:
       movem.l       d0-d2,-(sp)
       cargs #4+4,.value.w, .upper.w, .lower.w
              move.w .value(sp),d0 ; get params
              move.w .lower(sp),d1
              move.w .upper(sp),d2
              
              moveq  #TRUE,d7	; flag True

              cmp.w 	d1,d0		
              blo 	.return_true  ; d1 > d0
              cmp.w 	d2,d0		
              bhi 	.return_true  ; d2 < d0

              moveq 	#FALSE,d7	; flag False

              .return_true:
       movem.l       (sp)+,d0-d2
       rts

;Limit the y position between screen limits [$30,$fe] and reverse y speed
;in:	\1.w: 	y position
;in:   \2.w: 	y speed
checkBounds   macro
              cmp    #$fe,\1              ; bottom check ($139 for full bottom - 9bits) old: $f0
              blo    .not_at_bottom        ; branch when $fe > d7 (branch on less than)
              move   #$fe,\1
              neg    \2                   ; reverse speed_y
       .not_at_bottom:   
        
              cmp    #$2f,\1              ; top check ($0 for full top - 9bits) old: $40
              bhi    .not_at_top           ; branch when $30 < d7 (branch on hight than)
              move   #$2f,\1              
              neg    \2                   ; reverse speed_y
       .not_at_top:       
;              .return:
       endm

; Waits for beginning of frame
; ypos=$02a
waitFrameStart  macro
       .waitframe1:                       ; 1 byte in $dff006 + 1 bit in $dff005
              btst   #0,$dff005          ; set Z=1 if bit is zero   
              bne    .waitframe1          ; branch if bit 1 (Z=0)
              cmp.b  #$2a,$dff006        ; $2a-screen start, $137-screen end
              bne    .waitframe1

       .waitframe2:
              cmp.b  #$2a,$dff006
              beq    .waitframe2
       endm

; Waits for end of frame
; ypos=$137
waitFrameEnd  macro
       .waitframe1:                       ; 1 byte in $dff006 + 1 bit in $dff005
              btst   #0,$dff005          ; set Z=1 if bit is zero   
              beq    .waitframe1          ; branch if bit 0 (Z=1)
              cmp.b  #$37,$dff006        ; $2a-screen start, $137-screen end
              bne    .waitframe1

       .waitframe2:
              cmp.b  #$37,$dff006 
              beq    .waitframe2
       endm

; Update the copper white raster line position with d7 value (uses d0 internally)
;in:	\2.b: 	y line position
;in:   \1.b: 	the line's height (up to 9) 
updateCopperLine macro
       move.b \1,waitras1
       move.b \1,d0
       addq.b \2,d0
       move.b d0,waitras2
       endm

; Init 

**************************************************
* INIT
**************************************************

init:
;------Loading Libraries------
       move.l 4.w,a6                      ; execbase lib (base pointer) address to a6
       
       clr.l  d0                          
       move.l #gfxname,a1                 ; OldOpenLibrary(libName:a1, version:d0) -> d0 (lib address)
       jsr    _LVOOldOpenLibrary(a6)      ; jsr -408(a6), a6: base pointer to exebace lib
       move.l d0,a1                       ; return: d0 -> graphics lib address

       move.l (34,a1),old_view            ; 38(a1) => copper list ptr / 50(a1) => second copper list ptr
       move.l (38,a1),old_copper          ; 38(a1) => copper list ptr / 50(a1) => second copper list ptr
       
       jsr    _LVOCloseLibrary(a6)        ; jsr -414(a6), a6: base pointer to exebace lib

;------Init Data--------------
       move   INTS_READ,d5                ; Interrupt enable bits read -> d5 (save interrupts state)
       move   #$7fff,INTS_WRITE           ; disable interrupts control (lower 15 bits) / clear or set bits

       move.l #copper_list,COPPER_ADR     ; set our own copper list, after disabling interrupts (system may interfer if ints are enabled)

       move   #$ac,pos_y                     ; start y position
       move   #2,spd_y                       ; speed y

**************************************************
* GAME LOOP
**************************************************

main_loop:
       waitFrameStart

       move.w pos_y,d0
       add    spd_y,d0             ; increment/decrement line position
       move.w d0,pos_y

       checkBounds pos_y,spd_y     ; checkBounds ypos, yspeed
       
       ;updateCopperLine d7,#5
       clr.l  $100                 ; BREAKPOINT
       
       FnUpdateCopperBar pos_y

       btst   #MBUTTON_1,MOUSE_REG
       bne    main_loop            ; mbutton=1 (not pressed) => Z=0 (bne)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
exit:
       move.l old_copper,COPPER_ADR   ; restore system's copper list
       ;bset #14,d5                   ; 1 to bit turn on interrupts and 1 bit to switch all others to on (master switch)
       ;bset #15,d5                
       or     #$c000,d5               ; turn on interrupts (bits 14 and 15 $c=1100)
       move   d5,INTS_WRITE           ; restoure value back to interrupts controll register (turn on interrupts) / write only
       rts


**************************************************
* VARS
**************************************************

old_copper    dc.l   0      ; addresses
old_view      dc.l   0
pos_y         dc.w   0
spd_y         dc.w   0
str_1         dc.b   "Hello World of 68k ASM",0
       even

**************************************************
* DATA
**************************************************

gfxname:
       dc.b   "graphics.library",0 ; NULL terminated string (ASCII zero notation)
       even

; SECTION name,CODE/DATA/BSS 
;   _C chip memory
;   _F fast memory          Amiga=not chip memory
;   _P public memory        takes whaever memory available

; custom Chip Data needs to be in chip memory
;-----Copper List------            ; sets how the screen is going to be drawn
       SECTION tut,DATA_C          ; tell the assembler to put this piece of data in NOT fast memory
copper_list:
       dc.w   $1fc,0               ; slow fetch mode for AGA compatibility
       dc.w   $100,$1200           ; set number of bitplanes to zero
       
       ; define display window
       dc.w   $8e,$2c81            ; display window start
       dc.w   $90,$2cc1            ; display window stop
       dc.w   $92,$38
       dc.w   $94,$d0

       ; top border line       
       dc.w   $180,$349          ; set background color ($RGB)
       dc.w   $2b07,$fffe          ; wait for VH pos: screen starts at $2c, hpos starts at $07
       dc.w   $180,$56c          
       dc.w   $2c07,$fffe          ; wait for VH pos
       dc.w   $180,$113          

waitras1:
       dc.w   $8007,$fffe          ; wait for VH pos: screen starts at $2c, hpos starts at $07
       dc.w   $180,$055          
waitras2:
       dc.w   $8107,$fffe          ; wait for VH pos
       dc.w   $180,$0aa          
waitras3:
       dc.w   $8207,$fffe          ; wait for VH pos
       dc.w   $180,$0ff          
waitras4:
       dc.w   $8307,$fffe          ; wait for VH pos
       dc.w   $180,$0aa          
waitras5:
       dc.w   $8407,$fffe          ; wait for VH pos
       dc.w   $180,$055          
waitras6:
       dc.w   $8507,$fffe          ; wait for VH pos
       dc.w   $180,$113          

       ; bottom border line       
       dc.w   $ffdf,$fffe          ; wait for VH pos ???
       dc.w   $2c07,$fffe          ; wait for VH pos
       dc.w   $180,$56c          
       dc.w   $2d07,$fffe          ; wait for VH pos
       dc.w   $180,$349          

       dc.w   $ffff,$fffe          ; wait for scan line ("impossible" position) $ffff + bit mask: $fff + e=1110