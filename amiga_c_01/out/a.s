
out/a.elf:     file format elf32-m68k


Disassembly of section .text:

00000000 <_start>:
extern void (*__init_array_start[])() __attribute__((weak));
extern void (*__init_array_end[])() __attribute__((weak));
extern void (*__fini_array_start[])() __attribute__((weak));
extern void (*__fini_array_end[])() __attribute__((weak));

__attribute__((used)) __attribute__((section(".text.unlikely"))) void _start() {
       0:	       movem.l d2-d3/a2,-(sp)
	// initialize globals, ctors etc.
	unsigned long count;
	unsigned long i;

	count = __preinit_array_end - __preinit_array_start;
       4:	       move.l #16384,d3
       a:	       subi.l #16384,d3
      10:	       asr.l #2,d3
	for (i = 0; i < count; i++)
      12:	       move.l #16384,d0
      18:	       cmpi.l #16384,d0
      1e:	/----- beq.s 32 <_start+0x32>
      20:	|      lea 4000 <incbin_image_start>,a2
      26:	|      moveq #0,d2
		__preinit_array_start[i]();
      28:	|  /-> movea.l (a2)+,a0
      2a:	|  |   jsr (a0)
	for (i = 0; i < count; i++)
      2c:	|  |   addq.l #1,d2
      2e:	|  |   cmp.l d3,d2
      30:	|  \-- bcs.s 28 <_start+0x28>

	count = __init_array_end - __init_array_start;
      32:	\----> move.l #16384,d3
      38:	       subi.l #16384,d3
      3e:	       asr.l #2,d3
	for (i = 0; i < count; i++)
      40:	       move.l #16384,d0
      46:	       cmpi.l #16384,d0
      4c:	/----- beq.s 60 <_start+0x60>
      4e:	|      lea 4000 <incbin_image_start>,a2
      54:	|      moveq #0,d2
		__init_array_start[i]();
      56:	|  /-> movea.l (a2)+,a0
      58:	|  |   jsr (a0)
	for (i = 0; i < count; i++)
      5a:	|  |   addq.l #1,d2
      5c:	|  |   cmp.l d3,d2
      5e:	|  \-- bcs.s 56 <_start+0x56>

	main();
      60:	\----> jsr 8c <main>

	// call dtors
	count = __fini_array_end - __fini_array_start;
      66:	       move.l #16384,d2
      6c:	       subi.l #16384,d2
      72:	       asr.l #2,d2
	for (i = count; i > 0; i--)
      74:	/----- beq.s 86 <_start+0x86>
      76:	|      lea 4000 <incbin_image_start>,a2
		__fini_array_start[i - 1]();
      7c:	|  /-> subq.l #1,d2
      7e:	|  |   movea.l -(a2),a0
      80:	|  |   jsr (a0)
	for (i = count; i > 0; i--)
      82:	|  |   tst.l d2
      84:	|  \-- bne.s 7c <_start+0x7c>
}
      86:	\----> movem.l (sp)+,d2-d3/a2
      8a:	       rts

0000008c <main>:
static void Wait10() { WaitLine(0x10); }
static void Wait11() { WaitLine(0x11); }
static void Wait12() { WaitLine(0x12); }
static void Wait13() { WaitLine(0x13); }

int main() {
      8c:	                                                          link.w a5,#-52
      90:	                                                          movem.l d2-d7/a2-a4/a6,-(sp)
	SysBase = *((struct ExecBase**)4UL);
      94:	                                                          movea.l 4 <_start+0x4>,a6
      98:	                                                          move.l a6,12b9a <SysBase>
	custom = (struct Custom*)0xdff000;
      9e:	                                                          move.l #14675968,12ba4 <custom>

	// We will use the graphics library only to locate and restore the system copper list once we are through.
	GfxBase = (struct GfxBase *)OpenLibrary((CONST_STRPTR)"graphics.library",0);
      a8:	                                                          lea 3294 <incbin_player_end+0xd4>,a1
      ae:	                                                          moveq #0,d0
      b0:	                                                          jsr -552(a6)
      b4:	                                                          move.l d0,12b96 <GfxBase>
	if (!GfxBase)
      ba:	      /-------------------------------------------------- beq.w c56 <main+0xbca>
		Exit(0);

	// used for printing
	DOSBase = (struct DosLibrary*)OpenLibrary((CONST_STRPTR)"dos.library", 0);
      be:	      |                                                   movea.l 12b9a <SysBase>,a6
      c4:	      |                                                   lea 32a5 <incbin_player_end+0xe5>,a1
      ca:	      |                                                   moveq #0,d0
      cc:	      |                                                   jsr -552(a6)
      d0:	      |                                                   move.l d0,12b92 <DOSBase>
	if (!DOSBase)
      d6:	/-----|-------------------------------------------------- beq.w be6 <main+0xb5a>
		Exit(0);

#ifdef __cplusplus
	KPrintF("Hello debugger from Amiga: %ld!\n", staticClass.i);
#else
	KPrintF("Hello debugger from Amiga!\n");
      da:	|  /--|-------------------------------------------------> pea 32b1 <incbin_player_end+0xf1>
      e0:	|  |  |                                                   jsr f88 <KPrintF>
#endif
	Write(Output(), (APTR)"Hello console!\n", 15);
      e6:	|  |  |                                                   movea.l 12b92 <DOSBase>,a6
      ec:	|  |  |                                                   jsr -60(a6)
      f0:	|  |  |                                                   movea.l 12b92 <DOSBase>,a6
      f6:	|  |  |                                                   move.l d0,d1
      f8:	|  |  |                                                   move.l #13005,d2
      fe:	|  |  |                                                   moveq #15,d3
     100:	|  |  |                                                   jsr -48(a6)
	Delay(50);
     104:	|  |  |                                                   movea.l 12b92 <DOSBase>,a6
     10a:	|  |  |                                                   moveq #50,d1
     10c:	|  |  |                                                   jsr -198(a6)

	warpmode(1);
     110:	|  |  |                                                   pea 1 <_start+0x1>
     114:	|  |  |                                                   lea ffa <warpmode>,a4
     11a:	|  |  |                                                   jsr (a4)
		register volatile const void* _a0 ASM("a0") = module;
     11c:	|  |  |                                                   lea 11704 <incbin_module_start>,a0
		register volatile const void* _a1 ASM("a1") = NULL;
     122:	|  |  |                                                   suba.l a1,a1
		register volatile const void* _a2 ASM("a2") = NULL;
     124:	|  |  |                                                   suba.l a2,a2
		register volatile const void* _a3 ASM("a3") = player;
     126:	|  |  |                                                   lea 185a <incbin_player_start>,a3
		__asm volatile (
     12c:	|  |  |                                                   movem.l d1-d7/a4-a6,-(sp)
     130:	|  |  |                                                   jsr (a3)
     132:	|  |  |                                                   movem.l (sp)+,d1-d7/a4-a6
	// TODO: precalc stuff here
#ifdef MUSIC
	if(p61Init(module) != 0)
     136:	|  |  |                                                   addq.l #8,sp
     138:	|  |  |                                                   tst.l d0
     13a:	|  |  |  /----------------------------------------------- bne.w b36 <main+0xaaa>
		KPrintF("p61Init failed!\n");
#endif
	warpmode(0);
     13e:	|  |  |  |  /-------------------------------------------> clr.l -(sp)
     140:	|  |  |  |  |                                             jsr (a4)
	Forbid();
     142:	|  |  |  |  |                                             movea.l 12b9a <SysBase>,a6
     148:	|  |  |  |  |                                             jsr -132(a6)
	SystemADKCON=custom->adkconr;
     14c:	|  |  |  |  |                                             movea.l 12ba4 <custom>,a0
     152:	|  |  |  |  |                                             move.w 16(a0),d0
     156:	|  |  |  |  |                                             move.w d0,12b84 <SystemADKCON>
	SystemInts=custom->intenar;
     15c:	|  |  |  |  |                                             move.w 28(a0),d0
     160:	|  |  |  |  |                                             move.w d0,12b88 <SystemInts>
	SystemDMA=custom->dmaconr;
     166:	|  |  |  |  |                                             move.w 2(a0),d0
     16a:	|  |  |  |  |                                             move.w d0,12b86 <SystemDMA>
	ActiView=GfxBase->ActiView; //store current view
     170:	|  |  |  |  |                                             movea.l 12b96 <GfxBase>,a6
     176:	|  |  |  |  |                                             move.l 34(a6),12b80 <ActiView>
	LoadView(0);
     17e:	|  |  |  |  |                                             suba.l a1,a1
     180:	|  |  |  |  |                                             jsr -222(a6)
	WaitTOF();
     184:	|  |  |  |  |                                             movea.l 12b96 <GfxBase>,a6
     18a:	|  |  |  |  |                                             jsr -270(a6)
	WaitTOF();
     18e:	|  |  |  |  |                                             movea.l 12b96 <GfxBase>,a6
     194:	|  |  |  |  |                                             jsr -270(a6)
	WaitVbl();
     198:	|  |  |  |  |                                             lea ed2 <WaitVbl>,a2
     19e:	|  |  |  |  |                                             jsr (a2)
	WaitVbl();
     1a0:	|  |  |  |  |                                             jsr (a2)
	OwnBlitter();
     1a2:	|  |  |  |  |                                             movea.l 12b96 <GfxBase>,a6
     1a8:	|  |  |  |  |                                             jsr -456(a6)
	WaitBlit();	
     1ac:	|  |  |  |  |                                             movea.l 12b96 <GfxBase>,a6
     1b2:	|  |  |  |  |                                             jsr -228(a6)
	Disable();
     1b6:	|  |  |  |  |                                             movea.l 12b9a <SysBase>,a6
     1bc:	|  |  |  |  |                                             jsr -120(a6)
	custom->intena=0x7fff;//disable all interrupts
     1c0:	|  |  |  |  |                                             movea.l 12ba4 <custom>,a0
     1c6:	|  |  |  |  |                                             move.w #32767,154(a0)
	custom->intreq=0x7fff;//Clear any interrupts that were pending
     1cc:	|  |  |  |  |                                             move.w #32767,156(a0)
	custom->dmacon=0x7fff;//Clear all DMA channels
     1d2:	|  |  |  |  |                                             move.w #32767,150(a0)
     1d8:	|  |  |  |  |                                             addq.l #4,sp
	for(int a=0;a<32;a++)
     1da:	|  |  |  |  |                                             moveq #0,d1
		custom->color[a]=0;
     1dc:	|  |  |  |  |        /----------------------------------> move.l d1,d0
     1de:	|  |  |  |  |        |                                    addi.l #192,d0
     1e4:	|  |  |  |  |        |                                    add.l d0,d0
     1e6:	|  |  |  |  |        |                                    move.w #0,(0,a0,d0.l)
	for(int a=0;a<32;a++)
     1ec:	|  |  |  |  |        |                                    addq.l #1,d1
     1ee:	|  |  |  |  |        |                                    moveq #32,d0
     1f0:	|  |  |  |  |        |                                    cmp.l d1,d0
     1f2:	|  |  |  |  |        +----------------------------------- bne.s 1dc <main+0x150>
	WaitVbl();
     1f4:	|  |  |  |  |        |                                    jsr (a2)
	WaitVbl();
     1f6:	|  |  |  |  |        |                                    jsr (a2)
	UWORD getvbr[] = { 0x4e7a, 0x0801, 0x4e73 }; // MOVEC.L VBR,D0 RTE
     1f8:	|  |  |  |  |        |                                    move.w #20090,-50(a5)
     1fe:	|  |  |  |  |        |                                    move.w #2049,-48(a5)
     204:	|  |  |  |  |        |                                    move.w #20083,-46(a5)
	if (SysBase->AttnFlags & AFF_68010) 
     20a:	|  |  |  |  |        |                                    movea.l 12b9a <SysBase>,a6
     210:	|  |  |  |  |        |                                    btst #0,297(a6)
     216:	|  |  |  |  |  /-----|----------------------------------- beq.w c82 <main+0xbf6>
		vbr = (APTR)Supervisor((ULONG (*)())getvbr);
     21a:	|  |  |  |  |  |     |                                    moveq #-50,d7
     21c:	|  |  |  |  |  |     |                                    add.l a5,d7
     21e:	|  |  |  |  |  |     |                                    exg d7,a5
     220:	|  |  |  |  |  |     |                                    jsr -30(a6)
     224:	|  |  |  |  |  |     |                                    exg d7,a5
	VBR=GetVBR();
     226:	|  |  |  |  |  |     |                                    move.l d0,12b8e <VBR>
	return *(volatile APTR*)(((UBYTE*)VBR)+0x6c);
     22c:	|  |  |  |  |  |     |                                    movea.l 12b8e <VBR>,a0
     232:	|  |  |  |  |  |     |                                    move.l 108(a0),d0
	SystemIrq=GetInterruptHandler(); //store interrupt register
     236:	|  |  |  |  |  |     |                                    move.l d0,12b8a <SystemIrq>

	TakeSystem();
	WaitVbl();
     23c:	|  |  |  |  |  |     |                                    jsr (a2)

	char* test = (char*)AllocMem(2502, MEMF_ANY);
     23e:	|  |  |  |  |  |     |                                    movea.l 12b9a <SysBase>,a6
     244:	|  |  |  |  |  |     |                                    move.l #2502,d0
     24a:	|  |  |  |  |  |     |                                    moveq #0,d1
     24c:	|  |  |  |  |  |     |                                    jsr -198(a6)
     250:	|  |  |  |  |  |     |                                    move.l d0,d4
	memset(test, 0xcd, 2502);
     252:	|  |  |  |  |  |     |                                    pea 9c6 <main+0x93a>
     256:	|  |  |  |  |  |     |                                    pea cd <main+0x41>
     25a:	|  |  |  |  |  |     |                                    move.l d0,-(sp)
     25c:	|  |  |  |  |  |     |                                    jsr 12cc <memset>
	memclr(test + 2, 2502 - 4);
     262:	|  |  |  |  |  |     |                                    movea.l d4,a0
     264:	|  |  |  |  |  |     |                                    addq.l #2,a0
	__asm volatile (
     266:	|  |  |  |  |  |     |                                    move.l #2498,d5
     26c:	|  |  |  |  |  |     |                                    cmpi.l #256,d5
     272:	|  |  |  |  |  |     |                             /----- blt.w 2d0 <main+0x244>
     276:	|  |  |  |  |  |     |                             |      adda.l d5,a0
     278:	|  |  |  |  |  |     |                             |      moveq #0,d0
     27a:	|  |  |  |  |  |     |                             |      moveq #0,d1
     27c:	|  |  |  |  |  |     |                             |      moveq #0,d2
     27e:	|  |  |  |  |  |     |                             |      moveq #0,d3
     280:	|  |  |  |  |  |     |                             |  /-> movem.l d0-d3,-(a0)
     284:	|  |  |  |  |  |     |                             |  |   movem.l d0-d3,-(a0)
     288:	|  |  |  |  |  |     |                             |  |   movem.l d0-d3,-(a0)
     28c:	|  |  |  |  |  |     |                             |  |   movem.l d0-d3,-(a0)
     290:	|  |  |  |  |  |     |                             |  |   movem.l d0-d3,-(a0)
     294:	|  |  |  |  |  |     |                             |  |   movem.l d0-d3,-(a0)
     298:	|  |  |  |  |  |     |                             |  |   movem.l d0-d3,-(a0)
     29c:	|  |  |  |  |  |     |                             |  |   movem.l d0-d3,-(a0)
     2a0:	|  |  |  |  |  |     |                             |  |   movem.l d0-d3,-(a0)
     2a4:	|  |  |  |  |  |     |                             |  |   movem.l d0-d3,-(a0)
     2a8:	|  |  |  |  |  |     |                             |  |   movem.l d0-d3,-(a0)
     2ac:	|  |  |  |  |  |     |                             |  |   movem.l d0-d3,-(a0)
     2b0:	|  |  |  |  |  |     |                             |  |   movem.l d0-d3,-(a0)
     2b4:	|  |  |  |  |  |     |                             |  |   movem.l d0-d3,-(a0)
     2b8:	|  |  |  |  |  |     |                             |  |   movem.l d0-d3,-(a0)
     2bc:	|  |  |  |  |  |     |                             |  |   movem.l d0-d3,-(a0)
     2c0:	|  |  |  |  |  |     |                             |  |   subi.l #256,d5
     2c6:	|  |  |  |  |  |     |                             |  |   cmpi.l #256,d5
     2cc:	|  |  |  |  |  |     |                             |  \-- bge.w 280 <main+0x1f4>
     2d0:	|  |  |  |  |  |     |                             >----> cmpi.w #64,d5
     2d4:	|  |  |  |  |  |     |                             |  /-- blt.w 2f0 <main+0x264>
     2d8:	|  |  |  |  |  |     |                             |  |   movem.l d0-d3,-(a0)
     2dc:	|  |  |  |  |  |     |                             |  |   movem.l d0-d3,-(a0)
     2e0:	|  |  |  |  |  |     |                             |  |   movem.l d0-d3,-(a0)
     2e4:	|  |  |  |  |  |     |                             |  |   movem.l d0-d3,-(a0)
     2e8:	|  |  |  |  |  |     |                             |  |   subi.w #64,d5
     2ec:	|  |  |  |  |  |     |                             \--|-- bra.w 2d0 <main+0x244>
     2f0:	|  |  |  |  |  |     |                                \-> lsr.w #2,d5
     2f2:	|  |  |  |  |  |     |                                /-- bcc.w 2f8 <main+0x26c>
     2f6:	|  |  |  |  |  |     |                                |   clr.w -(a0)
     2f8:	|  |  |  |  |  |     |                                \-> moveq #16,d0
     2fa:	|  |  |  |  |  |     |                                    sub.w d5,d0
     2fc:	|  |  |  |  |  |     |                                    add.w d0,d0
     2fe:	|  |  |  |  |  |     |                                    jmp (302 <main+0x276>,pc,d0.w)
     302:	|  |  |  |  |  |     |                                    clr.l -(a0)
     304:	|  |  |  |  |  |     |                                    clr.l -(a0)
     306:	|  |  |  |  |  |     |                                    clr.l -(a0)
     308:	|  |  |  |  |  |     |                                    clr.l -(a0)
     30a:	|  |  |  |  |  |     |                                    clr.l -(a0)
     30c:	|  |  |  |  |  |     |                                    clr.l -(a0)
     30e:	|  |  |  |  |  |     |                                    clr.l -(a0)
     310:	|  |  |  |  |  |     |                                    clr.l -(a0)
     312:	|  |  |  |  |  |     |                                    clr.l -(a0)
     314:	|  |  |  |  |  |     |                                    clr.l -(a0)
     316:	|  |  |  |  |  |     |                                    clr.l -(a0)
     318:	|  |  |  |  |  |     |                                    clr.l -(a0)
     31a:	|  |  |  |  |  |     |                                    clr.l -(a0)
     31c:	|  |  |  |  |  |     |                                    clr.l -(a0)
     31e:	|  |  |  |  |  |     |                                    clr.l -(a0)
     320:	|  |  |  |  |  |     |                                    clr.l -(a0)
	FreeMem(test, 2502);
     322:	|  |  |  |  |  |     |                                    movea.l 12b9a <SysBase>,a6
     328:	|  |  |  |  |  |     |                                    movea.l d4,a1
     32a:	|  |  |  |  |  |     |                                    move.l #2502,d0
     330:	|  |  |  |  |  |     |                                    jsr -210(a6)

	USHORT* copper1 = (USHORT*)AllocMem(1024, MEMF_CHIP);
     334:	|  |  |  |  |  |     |                                    movea.l 12b9a <SysBase>,a6
     33a:	|  |  |  |  |  |     |                                    move.l #1024,d0
     340:	|  |  |  |  |  |     |                                    moveq #2,d1
     342:	|  |  |  |  |  |     |                                    jsr -198(a6)
     346:	|  |  |  |  |  |     |                                    movea.l d0,a3
	USHORT* copPtr = copper1;

	// register graphics resources with WinUAE for nicer gfx debugger experience
	debug_register_bitmap(image, "image.bpl", 320, 256, 5, debug_resource_bitmap_interleaved);
     348:	|  |  |  |  |  |     |                                    pea 1 <_start+0x1>
     34c:	|  |  |  |  |  |     |                                    pea 100 <main+0x74>
     350:	|  |  |  |  |  |     |                                    pea 140 <main+0xb4>
     354:	|  |  |  |  |  |     |                                    pea 32ee <incbin_player_end+0x12e>
     35a:	|  |  |  |  |  |     |                                    pea 4000 <incbin_image_start>
     360:	|  |  |  |  |  |     |                                    lea 1156 <debug_register_bitmap.constprop.0>,a4
     366:	|  |  |  |  |  |     |                                    jsr (a4)
	debug_register_bitmap(bob, "bob.bpl", 32, 96, 5, debug_resource_bitmap_interleaved | debug_resource_bitmap_masked);
     368:	|  |  |  |  |  |     |                                    lea 32(sp),sp
     36c:	|  |  |  |  |  |     |                                    pea 3 <_start+0x3>
     370:	|  |  |  |  |  |     |                                    pea 60 <_start+0x60>
     374:	|  |  |  |  |  |     |                                    pea 20 <_start+0x20>
     378:	|  |  |  |  |  |     |                                    pea 32f8 <incbin_player_end+0x138>
     37e:	|  |  |  |  |  |     |                                    pea 10802 <incbin_bob_start>
     384:	|  |  |  |  |  |     |                                    jsr (a4)
	my_strncpy(resource.name, name, sizeof(resource.name));
	debug_cmd(barto_cmd_register_resource, (unsigned int)&resource, 0, 0);
}

void debug_register_palette(const void* addr, const char* name, short numEntries, unsigned short flags) {
	struct debug_resource resource = {
     386:	|  |  |  |  |  |     |                                    clr.l -42(a5)
     38a:	|  |  |  |  |  |     |                                    clr.l -38(a5)
     38e:	|  |  |  |  |  |     |                                    clr.l -34(a5)
     392:	|  |  |  |  |  |     |                                    clr.l -30(a5)
     396:	|  |  |  |  |  |     |                                    clr.l -26(a5)
     39a:	|  |  |  |  |  |     |                                    clr.l -22(a5)
     39e:	|  |  |  |  |  |     |                                    clr.l -18(a5)
     3a2:	|  |  |  |  |  |     |                                    clr.l -14(a5)
     3a6:	|  |  |  |  |  |     |                                    clr.l -10(a5)
     3aa:	|  |  |  |  |  |     |                                    clr.l -6(a5)
     3ae:	|  |  |  |  |  |     |                                    clr.w -2(a5)
		.address = (unsigned int)addr,
     3b2:	|  |  |  |  |  |     |                                    move.l #6168,d3
	struct debug_resource resource = {
     3b8:	|  |  |  |  |  |     |                                    move.l d3,-50(a5)
     3bc:	|  |  |  |  |  |     |                                    moveq #64,d1
     3be:	|  |  |  |  |  |     |                                    move.l d1,-46(a5)
     3c2:	|  |  |  |  |  |     |                                    move.w #1,-10(a5)
     3c8:	|  |  |  |  |  |     |                                    move.w #32,-6(a5)
     3ce:	|  |  |  |  |  |     |                                    lea 20(sp),sp
	while(*source && --num > 0)
     3d2:	|  |  |  |  |  |     |                                    moveq #105,d0
	struct debug_resource resource = {
     3d4:	|  |  |  |  |  |     |                                    lea -42(a5),a0
     3d8:	|  |  |  |  |  |     |                                    lea 328a <incbin_player_end+0xca>,a1
	while(*source && --num > 0)
     3de:	|  |  |  |  |  |     |                                    lea -11(a5),a4
		*destination++ = *source++;
     3e2:	|  |  |  |  |  |  /--|----------------------------------> addq.l #1,a1
     3e4:	|  |  |  |  |  |  |  |                                    move.b d0,(a0)+
	while(*source && --num > 0)
     3e6:	|  |  |  |  |  |  |  |                                    move.b (a1),d0
     3e8:	|  |  |  |  |  |  |  |                                /-- beq.s 3ee <main+0x362>
     3ea:	|  |  |  |  |  |  |  |                                |   cmpa.l a0,a4
     3ec:	|  |  |  |  |  |  +--|--------------------------------|-- bne.s 3e2 <main+0x356>
	*destination = '\0';
     3ee:	|  |  |  |  |  |  |  |                                \-> clr.b (a0)
	if(*((UWORD *)UaeLib) == 0x4eb9 || *((UWORD *)UaeLib) == 0xa00e) {
     3f0:	|  |  |  |  |  |  |  |                                    move.w f0ff60 <_end+0xefd3b8>,d0
     3f6:	|  |  |  |  |  |  |  |                                    cmpi.w #20153,d0
     3fa:	|  |  |  |  |  |  |  |     /----------------------------- beq.w 9ca <main+0x93e>
     3fe:	|  |  |  |  |  |  |  |     |                              cmpi.w #-24562,d0
     402:	|  |  |  |  |  |  |  |     +----------------------------- beq.w 9ca <main+0x93e>
	debug_register_palette(colors, "image.pal", 32, 0);
	debug_register_copperlist(copper1, "copper1", 1024, 0);
     406:	|  |  |  |  |  |  |  |     |                              pea 400 <main+0x374>
     40a:	|  |  |  |  |  |  |  |     |                              pea 3300 <incbin_player_end+0x140>
     410:	|  |  |  |  |  |  |  |     |                              move.l a3,-(sp)
     412:	|  |  |  |  |  |  |  |     |                              lea 121c <debug_register_copperlist.constprop.0>,a4
     418:	|  |  |  |  |  |  |  |     |                              jsr (a4)
	debug_register_copperlist(copper2, "copper2", sizeof(copper2), 0);
     41a:	|  |  |  |  |  |  |  |     |                              pea 80 <_start+0x80>
     41e:	|  |  |  |  |  |  |  |     |                              pea 3308 <incbin_player_end+0x148>
     424:	|  |  |  |  |  |  |  |     |                              pea 33e2 <copper2>
     42a:	|  |  |  |  |  |  |  |     |                              jsr (a4)
	*copListEnd++ = offsetof(struct Custom, ddfstrt);
     42c:	|  |  |  |  |  |  |  |     |                              move.w #146,(a3)
	*copListEnd++ = fw;
     430:	|  |  |  |  |  |  |  |     |                              move.w #56,2(a3)
	*copListEnd++ = offsetof(struct Custom, ddfstop);
     436:	|  |  |  |  |  |  |  |     |                              move.w #148,4(a3)
	*copListEnd++ = fw+(((width>>4)-1)<<3);
     43c:	|  |  |  |  |  |  |  |     |                              move.w #208,6(a3)
	*copListEnd++ = offsetof(struct Custom, diwstrt);
     442:	|  |  |  |  |  |  |  |     |                              move.w #142,8(a3)
	*copListEnd++ = x+(y<<8);
     448:	|  |  |  |  |  |  |  |     |                              move.w #11393,10(a3)
	*copListEnd++ = offsetof(struct Custom, diwstop);
     44e:	|  |  |  |  |  |  |  |     |                              move.w #144,12(a3)
	*copListEnd++ = (xstop-256)+((ystop-256)<<8);
     454:	|  |  |  |  |  |  |  |     |                              move.w #11457,14(a3)

	copPtr = screenScanDefault(copPtr);
	//enable bitplanes	
	*copPtr++ = offsetof(struct Custom, bplcon0);
     45a:	|  |  |  |  |  |  |  |     |                              move.w #256,16(a3)
	*copPtr++ = (0<<10)/*dual pf*/|(1<<9)/*color*/|((5)<<12)/*num bitplanes*/;
     460:	|  |  |  |  |  |  |  |     |                              move.w #20992,18(a3)
	*copPtr++ = offsetof(struct Custom, bplcon1);	//scrolling
     466:	|  |  |  |  |  |  |  |     |                              move.w #258,20(a3)
     46c:	|  |  |  |  |  |  |  |     |                              lea 22(a3),a0
     470:	|  |  |  |  |  |  |  |     |                              move.l a0,12ba0 <scroll>
	scroll = copPtr;
	*copPtr++ = 0;
     476:	|  |  |  |  |  |  |  |     |                              clr.w 22(a3)
	*copPtr++ = offsetof(struct Custom, bplcon2);	//playfied priority
     47a:	|  |  |  |  |  |  |  |     |                              move.w #260,24(a3)
	*copPtr++ = 1<<6;//0x24;			//Sprites have priority over playfields
     480:	|  |  |  |  |  |  |  |     |                              move.w #64,26(a3)

	const USHORT lineSize=320/8;

	//set bitplane modulo
	*copPtr++=offsetof(struct Custom, bpl1mod); //odd planes   1,3,5
     486:	|  |  |  |  |  |  |  |     |                              move.w #264,28(a3)
	*copPtr++=4*lineSize;
     48c:	|  |  |  |  |  |  |  |     |                              move.w #160,30(a3)
	*copPtr++=offsetof(struct Custom, bpl2mod); //even  planes 2,4
     492:	|  |  |  |  |  |  |  |     |                              move.w #266,32(a3)
	*copPtr++=4*lineSize;
     498:	|  |  |  |  |  |  |  |     |                              move.w #160,34(a3)
		ULONG addr=(ULONG)planes[i];
     49e:	|  |  |  |  |  |  |  |     |                              move.l #16384,d0
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR);
     4a4:	|  |  |  |  |  |  |  |     |                              move.w #224,36(a3)
		*copListEnd++=(UWORD)(addr>>16);
     4aa:	|  |  |  |  |  |  |  |     |                              move.l d0,d1
     4ac:	|  |  |  |  |  |  |  |     |                              clr.w d1
     4ae:	|  |  |  |  |  |  |  |     |                              swap d1
     4b0:	|  |  |  |  |  |  |  |     |                              move.w d1,38(a3)
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR) + 2;
     4b4:	|  |  |  |  |  |  |  |     |                              move.w #226,40(a3)
		*copListEnd++=(UWORD)addr;
     4ba:	|  |  |  |  |  |  |  |     |                              move.w d0,42(a3)
		ULONG addr=(ULONG)planes[i];
     4be:	|  |  |  |  |  |  |  |     |                              move.l #16424,d0
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR);
     4c4:	|  |  |  |  |  |  |  |     |                              move.w #228,44(a3)
		*copListEnd++=(UWORD)(addr>>16);
     4ca:	|  |  |  |  |  |  |  |     |                              move.l d0,d1
     4cc:	|  |  |  |  |  |  |  |     |                              clr.w d1
     4ce:	|  |  |  |  |  |  |  |     |                              swap d1
     4d0:	|  |  |  |  |  |  |  |     |                              move.w d1,46(a3)
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR) + 2;
     4d4:	|  |  |  |  |  |  |  |     |                              move.w #230,48(a3)
		*copListEnd++=(UWORD)addr;
     4da:	|  |  |  |  |  |  |  |     |                              move.w d0,50(a3)
		ULONG addr=(ULONG)planes[i];
     4de:	|  |  |  |  |  |  |  |     |                              move.l #16464,d0
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR);
     4e4:	|  |  |  |  |  |  |  |     |                              move.w #232,52(a3)
		*copListEnd++=(UWORD)(addr>>16);
     4ea:	|  |  |  |  |  |  |  |     |                              move.l d0,d1
     4ec:	|  |  |  |  |  |  |  |     |                              clr.w d1
     4ee:	|  |  |  |  |  |  |  |     |                              swap d1
     4f0:	|  |  |  |  |  |  |  |     |                              move.w d1,54(a3)
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR) + 2;
     4f4:	|  |  |  |  |  |  |  |     |                              move.w #234,56(a3)
		*copListEnd++=(UWORD)addr;
     4fa:	|  |  |  |  |  |  |  |     |                              move.w d0,58(a3)
		ULONG addr=(ULONG)planes[i];
     4fe:	|  |  |  |  |  |  |  |     |                              move.l #16504,d0
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR);
     504:	|  |  |  |  |  |  |  |     |                              move.w #236,60(a3)
		*copListEnd++=(UWORD)(addr>>16);
     50a:	|  |  |  |  |  |  |  |     |                              move.l d0,d1
     50c:	|  |  |  |  |  |  |  |     |                              clr.w d1
     50e:	|  |  |  |  |  |  |  |     |                              swap d1
     510:	|  |  |  |  |  |  |  |     |                              move.w d1,62(a3)
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR) + 2;
     514:	|  |  |  |  |  |  |  |     |                              move.w #238,64(a3)
		*copListEnd++=(UWORD)addr;
     51a:	|  |  |  |  |  |  |  |     |                              move.w d0,66(a3)
		ULONG addr=(ULONG)planes[i];
     51e:	|  |  |  |  |  |  |  |     |                              move.l #16544,d0
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR);
     524:	|  |  |  |  |  |  |  |     |                              move.w #240,68(a3)
		*copListEnd++=(UWORD)(addr>>16);
     52a:	|  |  |  |  |  |  |  |     |                              move.l d0,d1
     52c:	|  |  |  |  |  |  |  |     |                              clr.w d1
     52e:	|  |  |  |  |  |  |  |     |                              swap d1
     530:	|  |  |  |  |  |  |  |     |                              move.w d1,70(a3)
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR) + 2;
     534:	|  |  |  |  |  |  |  |     |                              move.w #242,72(a3)
		*copListEnd++=(UWORD)addr;
     53a:	|  |  |  |  |  |  |  |     |                              move.w d0,74(a3)
	for (USHORT i=0;i<numPlanes;i++) {
     53e:	|  |  |  |  |  |  |  |     |                              lea 76(a3),a1
     542:	|  |  |  |  |  |  |  |     |                              move.l #6232,d2
     548:	|  |  |  |  |  |  |  |     |                              lea 24(sp),sp
		*copListEnd++=(UWORD)addr;
     54c:	|  |  |  |  |  |  |  |     |                              lea 1818 <incbin_colors_start>,a0
     552:	|  |  |  |  |  |  |  |     |                              move.w #382,d0
     556:	|  |  |  |  |  |  |  |     |                              sub.w d3,d0
		planes[a]=(UBYTE*)(image + lineSize * a);
	copPtr = copSetPlanes(0, copPtr, planes, 5);

	// set colors
	for(int a=0; a < 32; a++)
		copPtr = copSetColor(copPtr, a, ((USHORT*)colors)[a]);
     558:	|  |  |  |  |  |  |  |  /--|----------------------------> move.w (a0)+,d1
	*copListCurrent++=offsetof(struct Custom, color[index]);
     55a:	|  |  |  |  |  |  |  |  |  |                              movea.w d0,a6
     55c:	|  |  |  |  |  |  |  |  |  |                              adda.w a0,a6
     55e:	|  |  |  |  |  |  |  |  |  |                              move.w a6,(a1)
	*copListCurrent++=color;
     560:	|  |  |  |  |  |  |  |  |  |                              addq.l #4,a1
     562:	|  |  |  |  |  |  |  |  |  |                              move.w d1,-2(a1)
	for(int a=0; a < 32; a++)
     566:	|  |  |  |  |  |  |  |  |  |                              cmpa.l d2,a0
     568:	|  |  |  |  |  |  |  |  +--|----------------------------- bne.s 558 <main+0x4cc>

	// jump to copper2
	*copPtr++ = offsetof(struct Custom, copjmp2);
     56a:	|  |  |  |  |  |  |  |  |  |                              move.w #138,204(a3)
	*copPtr++ = 0x7fff;
     570:	|  |  |  |  |  |  |  |  |  |                              move.w #32767,206(a3)

	custom->cop1lc = (ULONG)copper1;
     576:	|  |  |  |  |  |  |  |  |  |                              movea.l 12ba4 <custom>,a0
     57c:	|  |  |  |  |  |  |  |  |  |                              move.l a3,128(a0)
	custom->cop2lc = (ULONG)copper2;
     580:	|  |  |  |  |  |  |  |  |  |                              move.l #13282,132(a0)
	custom->dmacon = DMAF_BLITTER;//disable blitter dma for copjmp bug
     588:	|  |  |  |  |  |  |  |  |  |                              move.w #64,150(a0)
	custom->copjmp1 = 0x7fff; //start coppper
     58e:	|  |  |  |  |  |  |  |  |  |                              move.w #32767,136(a0)
	custom->dmacon = DMAF_SETCLR | DMAF_MASTER | DMAF_RASTER | DMAF_COPPER | DMAF_BLITTER;
     594:	|  |  |  |  |  |  |  |  |  |                              move.w #-31808,150(a0)
	*(volatile APTR*)(((UBYTE*)VBR)+0x6c) = interrupt;
     59a:	|  |  |  |  |  |  |  |  |  |                              movea.l 12b8e <VBR>,a1
     5a0:	|  |  |  |  |  |  |  |  |  |                              move.l #3652,108(a1)

	// DEMO
	SetInterruptHandler((APTR)interruptHandler);
	custom->intena = INTF_SETCLR | INTF_INTEN | INTF_VERTB;
     5a8:	|  |  |  |  |  |  |  |  |  |                              move.w #-16352,154(a0)
#ifdef MUSIC
	custom->intena = INTF_SETCLR | INTF_EXTER; // ThePlayer needs INTF_EXTER
     5ae:	|  |  |  |  |  |  |  |  |  |                              move.w #-24576,154(a0)
#endif

	custom->intreq=(1<<INTB_VERTB);//reset vbl req
     5b4:	|  |  |  |  |  |  |  |  |  |                              move.w #32,156(a0)
__attribute__((always_inline)) inline short MouseLeft(){return !((*(volatile UBYTE*)0xbfe001)&64);}	
     5ba:	|  |  |  |  |  |  |  |  |  |                              move.b bfe001 <_end+0xbeb459>,d0

	while(!MouseLeft()) {
     5c0:	|  |  |  |  |  |  |  |  |  |                              btst #6,d0
     5c4:	|  |  |  |  |  |  |  |  |  |  /-------------------------- beq.w 74c <main+0x6c0>
     5c8:	|  |  |  |  |  |  |  |  |  |  |                           lea 1638 <__umodsi3>,a4
     5ce:	|  |  |  |  |  |  |  |  |  |  |                           lea 332f <sinus40>,a3
		volatile ULONG vpos=*(volatile ULONG*)0xDFF004;
     5d4:	|  |  |  |  |  |  |  |  |  |  |  /----------------------> move.l dff004 <_end+0xdec45c>,d0
     5da:	|  |  |  |  |  |  |  |  |  |  |  |                        move.l d0,-50(a5)
		if(((vpos >> 8) & 511) == line)
     5de:	|  |  |  |  |  |  |  |  |  |  |  |                        move.l -50(a5),d0
     5e2:	|  |  |  |  |  |  |  |  |  |  |  |                        andi.l #130816,d0
     5e8:	|  |  |  |  |  |  |  |  |  |  |  |                        cmpi.l #4096,d0
     5ee:	|  |  |  |  |  |  |  |  |  |  |  +----------------------- bne.s 5d4 <main+0x548>
		Wait10();
		int f = frameCounter & 255;
     5f0:	|  |  |  |  |  |  |  |  |  |  |  |                        move.w 12b9e <frameCounter>,d7

		// clear
		WaitBlit();
     5f6:	|  |  |  |  |  |  |  |  |  |  |  |                        movea.l 12b96 <GfxBase>,a6
     5fc:	|  |  |  |  |  |  |  |  |  |  |  |                        jsr -228(a6)
		custom->bltcon0 = A_TO_D | DEST;
     600:	|  |  |  |  |  |  |  |  |  |  |  |                        movea.l 12ba4 <custom>,a0
     606:	|  |  |  |  |  |  |  |  |  |  |  |                        move.w #496,64(a0)
		custom->bltcon1 = 0;
     60c:	|  |  |  |  |  |  |  |  |  |  |  |                        move.w #0,66(a0)
		custom->bltadat = 0;
     612:	|  |  |  |  |  |  |  |  |  |  |  |                        move.w #0,116(a0)
		custom->bltdpt = (APTR)image + 320 / 8 * 200 * 5;
     618:	|  |  |  |  |  |  |  |  |  |  |  |                        move.l #56384,84(a0)
		custom->bltdmod = 0;
     620:	|  |  |  |  |  |  |  |  |  |  |  |                        move.w #0,102(a0)
		custom->bltafwm = custom->bltalwm = 0xffff;
     626:	|  |  |  |  |  |  |  |  |  |  |  |                        move.w #-1,70(a0)
     62c:	|  |  |  |  |  |  |  |  |  |  |  |                        move.w #-1,68(a0)
		custom->bltsize = ((56 * 5) << HSIZEBITS) | (320/16);
     632:	|  |  |  |  |  |  |  |  |  |  |  |                        move.w #17940,88(a0)
     638:	|  |  |  |  |  |  |  |  |  |  |  |                        moveq #0,d6
     63a:	|  |  |  |  |  |  |  |  |  |  |  |                        moveq #0,d5

		// blit
		for(short i = 0; i < 16; i++) {
			const short x = i * 16 + sinus32[(frameCounter + i) % sizeof(sinus32)] * 2;
     63c:	|  |  |  |  |  |  |  |  |  |  |  |                    /-> movea.w 12b9e <frameCounter>,a0
     642:	|  |  |  |  |  |  |  |  |  |  |  |                    |   pea 33 <_start+0x33>
     646:	|  |  |  |  |  |  |  |  |  |  |  |                    |   movea.w a0,a6
     648:	|  |  |  |  |  |  |  |  |  |  |  |                    |   pea (0,a6,d5.l)
     64c:	|  |  |  |  |  |  |  |  |  |  |  |                    |   jsr (a4)
     64e:	|  |  |  |  |  |  |  |  |  |  |  |                    |   addq.l #8,sp
     650:	|  |  |  |  |  |  |  |  |  |  |  |                    |   lea 336f <sinus32>,a0
     656:	|  |  |  |  |  |  |  |  |  |  |  |                    |   moveq #0,d3
     658:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.b (0,a0,d0.l),d3
     65c:	|  |  |  |  |  |  |  |  |  |  |  |                    |   add.l d6,d3
     65e:	|  |  |  |  |  |  |  |  |  |  |  |                    |   add.w d3,d3
			const short y = sinus40[((frameCounter + i) * 2) & 63] / 2;
     660:	|  |  |  |  |  |  |  |  |  |  |  |                    |   movea.w 12b9e <frameCounter>,a0
     666:	|  |  |  |  |  |  |  |  |  |  |  |                    |   movea.w a0,a6
     668:	|  |  |  |  |  |  |  |  |  |  |  |                    |   lea (0,a6,d5.l),a0
     66c:	|  |  |  |  |  |  |  |  |  |  |  |                    |   adda.l a0,a0
     66e:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.l a0,d0
     670:	|  |  |  |  |  |  |  |  |  |  |  |                    |   moveq #62,d1
     672:	|  |  |  |  |  |  |  |  |  |  |  |                    |   and.l d1,d0
     674:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.b (0,a3,d0.l),d2
     678:	|  |  |  |  |  |  |  |  |  |  |  |                    |   lsr.b #1,d2
			const APTR src = (APTR)bob + 32 / 8 * 10 * 16 * (i % 6);
     67a:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.w d5,d0
     67c:	|  |  |  |  |  |  |  |  |  |  |  |                    |   moveq #6,d1
     67e:	|  |  |  |  |  |  |  |  |  |  |  |                    |   ext.l d0
     680:	|  |  |  |  |  |  |  |  |  |  |  |                    |   divs.w d1,d0
     682:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.l d0,d4
     684:	|  |  |  |  |  |  |  |  |  |  |  |                    |   swap d4
     686:	|  |  |  |  |  |  |  |  |  |  |  |                    |   muls.w #640,d4
     68a:	|  |  |  |  |  |  |  |  |  |  |  |                    |   addi.l #67586,d4

			WaitBlit();
     690:	|  |  |  |  |  |  |  |  |  |  |  |                    |   movea.l 12b96 <GfxBase>,a6
     696:	|  |  |  |  |  |  |  |  |  |  |  |                    |   jsr -228(a6)
			custom->bltcon0 = 0xca | SRCA | SRCB | SRCC | DEST | ((x & 15) << ASHIFTSHIFT); // A = source, B = mask, C = background, D = destination
     69a:	|  |  |  |  |  |  |  |  |  |  |  |                    |   movea.l 12ba4 <custom>,a0
     6a0:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.w d3,d0
     6a2:	|  |  |  |  |  |  |  |  |  |  |  |                    |   moveq #12,d1
     6a4:	|  |  |  |  |  |  |  |  |  |  |  |                    |   lsl.w d1,d0
     6a6:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.w d0,d1
     6a8:	|  |  |  |  |  |  |  |  |  |  |  |                    |   ori.w #4042,d1
     6ac:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.w d1,64(a0)
			custom->bltcon1 = ((x & 15) << BSHIFTSHIFT);
     6b0:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.w d0,66(a0)
			custom->bltapt = src;
     6b4:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.l d4,80(a0)
			custom->bltamod = 32 / 8;
     6b8:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.w #4,100(a0)
			custom->bltbpt = src + 32 / 8 * 1;
     6be:	|  |  |  |  |  |  |  |  |  |  |  |                    |   addq.l #4,d4
     6c0:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.l d4,76(a0)
			custom->bltbmod = 32 / 8;
     6c4:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.w #4,98(a0)
			custom->bltcpt = custom->bltdpt = (APTR)image + 320 / 8 * 5 * (200 + y) + x / 8;
     6ca:	|  |  |  |  |  |  |  |  |  |  |  |                    |   andi.l #255,d2
     6d0:	|  |  |  |  |  |  |  |  |  |  |  |                    |   addi.l #200,d2
     6d6:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.l d2,d0
     6d8:	|  |  |  |  |  |  |  |  |  |  |  |                    |   add.l d2,d0
     6da:	|  |  |  |  |  |  |  |  |  |  |  |                    |   add.l d2,d0
     6dc:	|  |  |  |  |  |  |  |  |  |  |  |                    |   lsl.l #3,d0
     6de:	|  |  |  |  |  |  |  |  |  |  |  |                    |   add.l d2,d0
     6e0:	|  |  |  |  |  |  |  |  |  |  |  |                    |   lsl.l #3,d0
     6e2:	|  |  |  |  |  |  |  |  |  |  |  |                    |   asr.w #3,d3
     6e4:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.w d3,d1
     6e6:	|  |  |  |  |  |  |  |  |  |  |  |                    |   ext.l d1
     6e8:	|  |  |  |  |  |  |  |  |  |  |  |                    |   movea.l d0,a6
     6ea:	|  |  |  |  |  |  |  |  |  |  |  |                    |   lea (0,a6,d1.l),a1
     6ee:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.l a1,d0
     6f0:	|  |  |  |  |  |  |  |  |  |  |  |                    |   addi.l #16384,d0
     6f6:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.l d0,84(a0)
     6fa:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.l d0,72(a0)
			custom->bltcmod = custom->bltdmod = (320 - 32) / 8;
     6fe:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.w #36,102(a0)
     704:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.w #36,96(a0)
			custom->bltafwm = custom->bltalwm = 0xffff;
     70a:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.w #-1,70(a0)
     710:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.w #-1,68(a0)
			custom->bltsize = ((16 * 5) << HSIZEBITS) | (32/16);
     716:	|  |  |  |  |  |  |  |  |  |  |  |                    |   move.w #5122,88(a0)
		for(short i = 0; i < 16; i++) {
     71c:	|  |  |  |  |  |  |  |  |  |  |  |                    |   addq.l #1,d5
     71e:	|  |  |  |  |  |  |  |  |  |  |  |                    |   addq.l #8,d6
     720:	|  |  |  |  |  |  |  |  |  |  |  |                    |   moveq #16,d3
     722:	|  |  |  |  |  |  |  |  |  |  |  |                    |   cmp.l d5,d3
     724:	|  |  |  |  |  |  |  |  |  |  |  |                    \-- bne.w 63c <main+0x5b0>
     728:	|  |  |  |  |  |  |  |  |  |  |  |                        move.w f0ff60 <_end+0xefd3b8>,d0
     72e:	|  |  |  |  |  |  |  |  |  |  |  |                        cmpi.w #20153,d0
     732:	|  |  |  |  |  |  |  |  |  |  |  |                    /-- beq.w 84a <main+0x7be>
     736:	|  |  |  |  |  |  |  |  |  |  |  |                    |   cmpi.w #-24562,d0
     73a:	|  |  |  |  |  |  |  |  |  |  |  |                    +-- beq.w 84a <main+0x7be>
__attribute__((always_inline)) inline short MouseLeft(){return !((*(volatile UBYTE*)0xbfe001)&64);}	
     73e:	|  |  |  |  |  |  |  |  |  |  |  |  /-----------------|-> move.b bfe001 <_end+0xbeb459>,d0
	while(!MouseLeft()) {
     744:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   btst #6,d0
     748:	|  |  |  |  |  |  |  |  |  |  |  +--|-----------------|-- bne.w 5d4 <main+0x548>
		register volatile const void* _a3 ASM("a3") = player;
     74c:	|  |  |  |  |  |  |  |  |  |  >--|--|-----------------|-> lea 185a <incbin_player_start>,a3
		register volatile const void* _a6 ASM("a6") = (void*)0xdff000;
     752:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   movea.l #14675968,a6
		__asm volatile (
     758:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   movem.l d0-d1/a0-a1,-(sp)
     75c:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   jsr 8(a3)
     760:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   movem.l (sp)+,d0-d1/a0-a1
	WaitVbl();
     764:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   jsr (a2)
	WaitBlit();
     766:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   movea.l 12b96 <GfxBase>,a6
     76c:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   jsr -228(a6)
	custom->intena=0x7fff;//disable all interrupts
     770:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   movea.l 12ba4 <custom>,a0
     776:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   move.w #32767,154(a0)
	custom->intreq=0x7fff;//Clear any interrupts that were pending
     77c:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   move.w #32767,156(a0)
	custom->dmacon=0x7fff;//Clear all DMA channels
     782:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   move.w #32767,150(a0)
	*(volatile APTR*)(((UBYTE*)VBR)+0x6c) = interrupt;
     788:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   movea.l 12b8e <VBR>,a1
     78e:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   move.l 12b8a <SystemIrq>,108(a1)
	custom->cop1lc=(ULONG)GfxBase->copinit;
     796:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   movea.l 12b96 <GfxBase>,a6
     79c:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   move.l 38(a6),128(a0)
	custom->cop2lc=(ULONG)GfxBase->LOFlist;
     7a2:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   move.l 50(a6),132(a0)
	custom->copjmp1=0x7fff; //start coppper
     7a8:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   move.w #32767,136(a0)
	custom->intena=SystemInts|0x8000;
     7ae:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   move.w 12b88 <SystemInts>,d0
     7b4:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   ori.w #-32768,d0
     7b8:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   move.w d0,154(a0)
	custom->dmacon=SystemDMA|0x8000;
     7bc:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   move.w 12b86 <SystemDMA>,d0
     7c2:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   ori.w #-32768,d0
     7c6:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   move.w d0,150(a0)
	custom->adkcon=SystemADKCON|0x8000;
     7ca:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   move.w 12b84 <SystemADKCON>,d0
     7d0:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   ori.w #-32768,d0
     7d4:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   move.w d0,158(a0)
	WaitBlit();	
     7d8:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   jsr -228(a6)
	DisownBlitter();
     7dc:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   movea.l 12b96 <GfxBase>,a6
     7e2:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   jsr -462(a6)
	Enable();
     7e6:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   movea.l 12b9a <SysBase>,a6
     7ec:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   jsr -126(a6)
	LoadView(ActiView);
     7f0:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   movea.l 12b96 <GfxBase>,a6
     7f6:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   movea.l 12b80 <ActiView>,a1
     7fc:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   jsr -222(a6)
	WaitTOF();
     800:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   movea.l 12b96 <GfxBase>,a6
     806:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   jsr -270(a6)
	WaitTOF();
     80a:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   movea.l 12b96 <GfxBase>,a6
     810:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   jsr -270(a6)
	Permit();
     814:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   movea.l 12b9a <SysBase>,a6
     81a:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   jsr -138(a6)
#endif

	// END
	FreeSystem();

	CloseLibrary((struct Library*)DOSBase);
     81e:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   movea.l 12b9a <SysBase>,a6
     824:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   movea.l 12b92 <DOSBase>,a1
     82a:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   jsr -414(a6)
	CloseLibrary((struct Library*)GfxBase);
     82e:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   movea.l 12b9a <SysBase>,a6
     834:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   movea.l 12b96 <GfxBase>,a1
     83a:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   jsr -414(a6)
}
     83e:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   moveq #0,d0
     840:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   movem.l -92(a5),d2-d7/a2-a4/a6
     846:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   unlk a5
     848:	|  |  |  |  |  |  |  |  |  |  |  |  |                 |   rts
		UaeLib(88, arg1, arg2, arg3, arg4);
     84a:	|  |  |  |  |  |  |  |  |  |  |  |  |                 \-> clr.l -(sp)
     84c:	|  |  |  |  |  |  |  |  |  |  |  |  |                     clr.l -(sp)
     84e:	|  |  |  |  |  |  |  |  |  |  |  |  |                     clr.l -(sp)
     850:	|  |  |  |  |  |  |  |  |  |  |  |  |                     clr.l -(sp)
     852:	|  |  |  |  |  |  |  |  |  |  |  |  |                     pea 58 <_start+0x58>
     856:	|  |  |  |  |  |  |  |  |  |  |  |  |                     movea.l #15794016,a6
     85c:	|  |  |  |  |  |  |  |  |  |  |  |  |                     jsr (a6)
		debug_filled_rect(f + 100, 200*2, f + 400, 220*2, 0x0000ff00); // 0x00RRGGBB
     85e:	|  |  |  |  |  |  |  |  |  |  |  |  |                     andi.w #255,d7
     862:	|  |  |  |  |  |  |  |  |  |  |  |  |                     move.w d7,d2
     864:	|  |  |  |  |  |  |  |  |  |  |  |  |                     addi.w #400,d2
	debug_cmd(barto_cmd_filled_rect, (((unsigned int)left) << 16) | ((unsigned int)top), (((unsigned int)right) << 16) | ((unsigned int)bottom), color);
     868:	|  |  |  |  |  |  |  |  |  |  |  |  |                     swap d2
     86a:	|  |  |  |  |  |  |  |  |  |  |  |  |                     clr.w d2
     86c:	|  |  |  |  |  |  |  |  |  |  |  |  |                     ori.w #440,d2
     870:	|  |  |  |  |  |  |  |  |  |  |  |  |                     move.w d7,d0
     872:	|  |  |  |  |  |  |  |  |  |  |  |  |                     addi.w #100,d0
     876:	|  |  |  |  |  |  |  |  |  |  |  |  |                     swap d0
     878:	|  |  |  |  |  |  |  |  |  |  |  |  |                     clr.w d0
     87a:	|  |  |  |  |  |  |  |  |  |  |  |  |                     ori.w #400,d0
	if(*((UWORD *)UaeLib) == 0x4eb9 || *((UWORD *)UaeLib) == 0xa00e) {
     87e:	|  |  |  |  |  |  |  |  |  |  |  |  |                     move.w (a6),d1
     880:	|  |  |  |  |  |  |  |  |  |  |  |  |                     lea 20(sp),sp
     884:	|  |  |  |  |  |  |  |  |  |  |  |  |                     cmpi.w #20153,d1
     888:	|  |  |  |  |  |  |  |  |  |  |  |  |              /----- bne.w 94e <main+0x8c2>
		UaeLib(88, arg1, arg2, arg3, arg4);
     88c:	|  |  |  |  |  |  |  |  |  |  |  |  |              |      move.l #65280,-(sp)
     892:	|  |  |  |  |  |  |  |  |  |  |  |  |              |      move.l d2,-(sp)
     894:	|  |  |  |  |  |  |  |  |  |  |  |  |              |      move.l d0,-(sp)
     896:	|  |  |  |  |  |  |  |  |  |  |  |  |              |      pea 2 <_start+0x2>
     89a:	|  |  |  |  |  |  |  |  |  |  |  |  |              |      pea 58 <_start+0x58>
     89e:	|  |  |  |  |  |  |  |  |  |  |  |  |              |      movea.l #15794016,a6
     8a4:	|  |  |  |  |  |  |  |  |  |  |  |  |              |      jsr (a6)
		debug_rect(f + 90, 190*2, f + 400, 220*2, 0x000000ff); // 0x00RRGGBB
     8a6:	|  |  |  |  |  |  |  |  |  |  |  |  |              |      move.w d7,d0
     8a8:	|  |  |  |  |  |  |  |  |  |  |  |  |              |      addi.w #90,d0
	debug_cmd(barto_cmd_rect, (((unsigned int)left) << 16) | ((unsigned int)top), (((unsigned int)right) << 16) | ((unsigned int)bottom), color);
     8ac:	|  |  |  |  |  |  |  |  |  |  |  |  |              |      swap d0
     8ae:	|  |  |  |  |  |  |  |  |  |  |  |  |              |      clr.w d0
     8b0:	|  |  |  |  |  |  |  |  |  |  |  |  |              |      ori.w #380,d0
	if(*((UWORD *)UaeLib) == 0x4eb9 || *((UWORD *)UaeLib) == 0xa00e) {
     8b4:	|  |  |  |  |  |  |  |  |  |  |  |  |              |      move.w (a6),d1
     8b6:	|  |  |  |  |  |  |  |  |  |  |  |  |              |      lea 20(sp),sp
     8ba:	|  |  |  |  |  |  |  |  |  |  |  |  |              |      cmpi.w #20153,d1
     8be:	|  |  |  |  |  |  |  |  |  |  |  |  |        /-----|----- bne.w 98c <main+0x900>
		UaeLib(88, arg1, arg2, arg3, arg4);
     8c2:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  /--|----> pea ff <main+0x73>
     8c6:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |      move.l d2,-(sp)
     8c8:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |      move.l d0,-(sp)
     8ca:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |      pea 1 <_start+0x1>
     8ce:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |      pea 58 <_start+0x58>
     8d2:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |      movea.l #15794016,a6
     8d8:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |      jsr (a6)
		debug_text(f+ 130, 209*2, "This is a WinUAE debug overlay", 0x00ff00ff);
     8da:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |      addi.w #130,d7
	debug_cmd(barto_cmd_text, (((unsigned int)left) << 16) | ((unsigned int)top), (unsigned int)text, color);
     8de:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |      swap d7
     8e0:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |      clr.w d7
     8e2:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |      ori.w #418,d7
	if(*((UWORD *)UaeLib) == 0x4eb9 || *((UWORD *)UaeLib) == 0xa00e) {
     8e6:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |      move.w (a6),d0
     8e8:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |      lea 20(sp),sp
     8ec:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |      cmpi.w #20153,d0
     8f0:	|  |  |  |  |  |  |  |  |  |  |  |  |  /-----|--|--|----- bne.s 924 <main+0x898>
		UaeLib(88, arg1, arg2, arg3, arg4);
     8f2:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  /--|--|--|----> move.l #16711935,-(sp)
     8f8:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |      pea 3310 <incbin_player_end+0x150>
     8fe:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |      move.l d7,-(sp)
     900:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |      pea 3 <_start+0x3>
     904:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |      pea 58 <_start+0x58>
     908:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |      jsr f0ff60 <_end+0xefd3b8>
}
     90e:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |      lea 20(sp),sp
__attribute__((always_inline)) inline short MouseLeft(){return !((*(volatile UBYTE*)0xbfe001)&64);}	
     912:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  /-> move.b bfe001 <_end+0xbeb459>,d0
	while(!MouseLeft()) {
     918:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |   btst #6,d0
     91c:	|  |  |  |  |  |  |  |  |  |  |  \--|--|--|--|--|--|--|-- bne.w 5d4 <main+0x548>
     920:	|  |  |  |  |  |  |  |  |  |  \-----|--|--|--|--|--|--|-- bra.w 74c <main+0x6c0>
	if(*((UWORD *)UaeLib) == 0x4eb9 || *((UWORD *)UaeLib) == 0xa00e) {
     924:	|  |  |  |  |  |  |  |  |  |        |  >--|--|--|--|--|-> cmpi.w #-24562,d0
     928:	|  |  |  |  |  |  |  |  |  |        +--|--|--|--|--|--|-- bne.w 73e <main+0x6b2>
		UaeLib(88, arg1, arg2, arg3, arg4);
     92c:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |   move.l #16711935,-(sp)
     932:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |   pea 3310 <incbin_player_end+0x150>
     938:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |   move.l d7,-(sp)
     93a:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |   pea 3 <_start+0x3>
     93e:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |   pea 58 <_start+0x58>
     942:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |   jsr f0ff60 <_end+0xefd3b8>
}
     948:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |   lea 20(sp),sp
     94c:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  \-- bra.s 912 <main+0x886>
	if(*((UWORD *)UaeLib) == 0x4eb9 || *((UWORD *)UaeLib) == 0xa00e) {
     94e:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |  \----> cmpi.w #-24562,d1
     952:	|  |  |  |  |  |  |  |  |  |        +--|--|--|--|-------- bne.w 73e <main+0x6b2>
		UaeLib(88, arg1, arg2, arg3, arg4);
     956:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |         move.l #65280,-(sp)
     95c:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |         move.l d2,-(sp)
     95e:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |         move.l d0,-(sp)
     960:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |         pea 2 <_start+0x2>
     964:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |         pea 58 <_start+0x58>
     968:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |         movea.l #15794016,a6
     96e:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |         jsr (a6)
		debug_rect(f + 90, 190*2, f + 400, 220*2, 0x000000ff); // 0x00RRGGBB
     970:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |         move.w d7,d0
     972:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |         addi.w #90,d0
	debug_cmd(barto_cmd_rect, (((unsigned int)left) << 16) | ((unsigned int)top), (((unsigned int)right) << 16) | ((unsigned int)bottom), color);
     976:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |         swap d0
     978:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |         clr.w d0
     97a:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |         ori.w #380,d0
	if(*((UWORD *)UaeLib) == 0x4eb9 || *((UWORD *)UaeLib) == 0xa00e) {
     97e:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |         move.w (a6),d1
     980:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |         lea 20(sp),sp
     984:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  |         cmpi.w #20153,d1
     988:	|  |  |  |  |  |  |  |  |  |        |  |  |  |  \-------- beq.w 8c2 <main+0x836>
     98c:	|  |  |  |  |  |  |  |  |  |        |  |  |  \----------> cmpi.w #-24562,d1
     990:	|  |  |  |  |  |  |  |  |  |        \--|--|-------------- bne.w 73e <main+0x6b2>
		UaeLib(88, arg1, arg2, arg3, arg4);
     994:	|  |  |  |  |  |  |  |  |  |           |  |               pea ff <main+0x73>
     998:	|  |  |  |  |  |  |  |  |  |           |  |               move.l d2,-(sp)
     99a:	|  |  |  |  |  |  |  |  |  |           |  |               move.l d0,-(sp)
     99c:	|  |  |  |  |  |  |  |  |  |           |  |               pea 1 <_start+0x1>
     9a0:	|  |  |  |  |  |  |  |  |  |           |  |               pea 58 <_start+0x58>
     9a4:	|  |  |  |  |  |  |  |  |  |           |  |               movea.l #15794016,a6
     9aa:	|  |  |  |  |  |  |  |  |  |           |  |               jsr (a6)
		debug_text(f+ 130, 209*2, "This is a WinUAE debug overlay", 0x00ff00ff);
     9ac:	|  |  |  |  |  |  |  |  |  |           |  |               addi.w #130,d7
	debug_cmd(barto_cmd_text, (((unsigned int)left) << 16) | ((unsigned int)top), (unsigned int)text, color);
     9b0:	|  |  |  |  |  |  |  |  |  |           |  |               swap d7
     9b2:	|  |  |  |  |  |  |  |  |  |           |  |               clr.w d7
     9b4:	|  |  |  |  |  |  |  |  |  |           |  |               ori.w #418,d7
	if(*((UWORD *)UaeLib) == 0x4eb9 || *((UWORD *)UaeLib) == 0xa00e) {
     9b8:	|  |  |  |  |  |  |  |  |  |           |  |               move.w (a6),d0
     9ba:	|  |  |  |  |  |  |  |  |  |           |  |               lea 20(sp),sp
     9be:	|  |  |  |  |  |  |  |  |  |           |  |               cmpi.w #20153,d0
     9c2:	|  |  |  |  |  |  |  |  |  |           |  \-------------- beq.w 8f2 <main+0x866>
     9c6:	|  |  |  |  |  |  |  |  |  |           \----------------- bra.w 924 <main+0x898>
     9ca:	|  |  |  |  |  |  |  |  |  \----------------------------> clr.l -(sp)
     9cc:	|  |  |  |  |  |  |  |  |                                 clr.l -(sp)
     9ce:	|  |  |  |  |  |  |  |  |                                 pea -50(a5)
     9d2:	|  |  |  |  |  |  |  |  |                                 pea 4 <_start+0x4>
     9d6:	|  |  |  |  |  |  |  |  |                                 jsr eb2 <debug_cmd.part.0>
     9dc:	|  |  |  |  |  |  |  |  |                                 lea 16(sp),sp
	debug_register_copperlist(copper1, "copper1", 1024, 0);
     9e0:	|  |  |  |  |  |  |  |  |                                 pea 400 <main+0x374>
     9e4:	|  |  |  |  |  |  |  |  |                                 pea 3300 <incbin_player_end+0x140>
     9ea:	|  |  |  |  |  |  |  |  |                                 move.l a3,-(sp)
     9ec:	|  |  |  |  |  |  |  |  |                                 lea 121c <debug_register_copperlist.constprop.0>,a4
     9f2:	|  |  |  |  |  |  |  |  |                                 jsr (a4)
	debug_register_copperlist(copper2, "copper2", sizeof(copper2), 0);
     9f4:	|  |  |  |  |  |  |  |  |                                 pea 80 <_start+0x80>
     9f8:	|  |  |  |  |  |  |  |  |                                 pea 3308 <incbin_player_end+0x148>
     9fe:	|  |  |  |  |  |  |  |  |                                 pea 33e2 <copper2>
     a04:	|  |  |  |  |  |  |  |  |                                 jsr (a4)
	*copListEnd++ = offsetof(struct Custom, ddfstrt);
     a06:	|  |  |  |  |  |  |  |  |                                 move.w #146,(a3)
	*copListEnd++ = fw;
     a0a:	|  |  |  |  |  |  |  |  |                                 move.w #56,2(a3)
	*copListEnd++ = offsetof(struct Custom, ddfstop);
     a10:	|  |  |  |  |  |  |  |  |                                 move.w #148,4(a3)
	*copListEnd++ = fw+(((width>>4)-1)<<3);
     a16:	|  |  |  |  |  |  |  |  |                                 move.w #208,6(a3)
	*copListEnd++ = offsetof(struct Custom, diwstrt);
     a1c:	|  |  |  |  |  |  |  |  |                                 move.w #142,8(a3)
	*copListEnd++ = x+(y<<8);
     a22:	|  |  |  |  |  |  |  |  |                                 move.w #11393,10(a3)
	*copListEnd++ = offsetof(struct Custom, diwstop);
     a28:	|  |  |  |  |  |  |  |  |                                 move.w #144,12(a3)
	*copListEnd++ = (xstop-256)+((ystop-256)<<8);
     a2e:	|  |  |  |  |  |  |  |  |                                 move.w #11457,14(a3)
	*copPtr++ = offsetof(struct Custom, bplcon0);
     a34:	|  |  |  |  |  |  |  |  |                                 move.w #256,16(a3)
	*copPtr++ = (0<<10)/*dual pf*/|(1<<9)/*color*/|((5)<<12)/*num bitplanes*/;
     a3a:	|  |  |  |  |  |  |  |  |                                 move.w #20992,18(a3)
	*copPtr++ = offsetof(struct Custom, bplcon1);	//scrolling
     a40:	|  |  |  |  |  |  |  |  |                                 move.w #258,20(a3)
     a46:	|  |  |  |  |  |  |  |  |                                 lea 22(a3),a0
     a4a:	|  |  |  |  |  |  |  |  |                                 move.l a0,12ba0 <scroll>
	*copPtr++ = 0;
     a50:	|  |  |  |  |  |  |  |  |                                 clr.w 22(a3)
	*copPtr++ = offsetof(struct Custom, bplcon2);	//playfied priority
     a54:	|  |  |  |  |  |  |  |  |                                 move.w #260,24(a3)
	*copPtr++ = 1<<6;//0x24;			//Sprites have priority over playfields
     a5a:	|  |  |  |  |  |  |  |  |                                 move.w #64,26(a3)
	*copPtr++=offsetof(struct Custom, bpl1mod); //odd planes   1,3,5
     a60:	|  |  |  |  |  |  |  |  |                                 move.w #264,28(a3)
	*copPtr++=4*lineSize;
     a66:	|  |  |  |  |  |  |  |  |                                 move.w #160,30(a3)
	*copPtr++=offsetof(struct Custom, bpl2mod); //even  planes 2,4
     a6c:	|  |  |  |  |  |  |  |  |                                 move.w #266,32(a3)
	*copPtr++=4*lineSize;
     a72:	|  |  |  |  |  |  |  |  |                                 move.w #160,34(a3)
		ULONG addr=(ULONG)planes[i];
     a78:	|  |  |  |  |  |  |  |  |                                 move.l #16384,d0
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR);
     a7e:	|  |  |  |  |  |  |  |  |                                 move.w #224,36(a3)
		*copListEnd++=(UWORD)(addr>>16);
     a84:	|  |  |  |  |  |  |  |  |                                 move.l d0,d1
     a86:	|  |  |  |  |  |  |  |  |                                 clr.w d1
     a88:	|  |  |  |  |  |  |  |  |                                 swap d1
     a8a:	|  |  |  |  |  |  |  |  |                                 move.w d1,38(a3)
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR) + 2;
     a8e:	|  |  |  |  |  |  |  |  |                                 move.w #226,40(a3)
		*copListEnd++=(UWORD)addr;
     a94:	|  |  |  |  |  |  |  |  |                                 move.w d0,42(a3)
		ULONG addr=(ULONG)planes[i];
     a98:	|  |  |  |  |  |  |  |  |                                 move.l #16424,d0
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR);
     a9e:	|  |  |  |  |  |  |  |  |                                 move.w #228,44(a3)
		*copListEnd++=(UWORD)(addr>>16);
     aa4:	|  |  |  |  |  |  |  |  |                                 move.l d0,d1
     aa6:	|  |  |  |  |  |  |  |  |                                 clr.w d1
     aa8:	|  |  |  |  |  |  |  |  |                                 swap d1
     aaa:	|  |  |  |  |  |  |  |  |                                 move.w d1,46(a3)
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR) + 2;
     aae:	|  |  |  |  |  |  |  |  |                                 move.w #230,48(a3)
		*copListEnd++=(UWORD)addr;
     ab4:	|  |  |  |  |  |  |  |  |                                 move.w d0,50(a3)
		ULONG addr=(ULONG)planes[i];
     ab8:	|  |  |  |  |  |  |  |  |                                 move.l #16464,d0
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR);
     abe:	|  |  |  |  |  |  |  |  |                                 move.w #232,52(a3)
		*copListEnd++=(UWORD)(addr>>16);
     ac4:	|  |  |  |  |  |  |  |  |                                 move.l d0,d1
     ac6:	|  |  |  |  |  |  |  |  |                                 clr.w d1
     ac8:	|  |  |  |  |  |  |  |  |                                 swap d1
     aca:	|  |  |  |  |  |  |  |  |                                 move.w d1,54(a3)
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR) + 2;
     ace:	|  |  |  |  |  |  |  |  |                                 move.w #234,56(a3)
		*copListEnd++=(UWORD)addr;
     ad4:	|  |  |  |  |  |  |  |  |                                 move.w d0,58(a3)
		ULONG addr=(ULONG)planes[i];
     ad8:	|  |  |  |  |  |  |  |  |                                 move.l #16504,d0
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR);
     ade:	|  |  |  |  |  |  |  |  |                                 move.w #236,60(a3)
		*copListEnd++=(UWORD)(addr>>16);
     ae4:	|  |  |  |  |  |  |  |  |                                 move.l d0,d1
     ae6:	|  |  |  |  |  |  |  |  |                                 clr.w d1
     ae8:	|  |  |  |  |  |  |  |  |                                 swap d1
     aea:	|  |  |  |  |  |  |  |  |                                 move.w d1,62(a3)
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR) + 2;
     aee:	|  |  |  |  |  |  |  |  |                                 move.w #238,64(a3)
		*copListEnd++=(UWORD)addr;
     af4:	|  |  |  |  |  |  |  |  |                                 move.w d0,66(a3)
		ULONG addr=(ULONG)planes[i];
     af8:	|  |  |  |  |  |  |  |  |                                 move.l #16544,d0
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR);
     afe:	|  |  |  |  |  |  |  |  |                                 move.w #240,68(a3)
		*copListEnd++=(UWORD)(addr>>16);
     b04:	|  |  |  |  |  |  |  |  |                                 move.l d0,d1
     b06:	|  |  |  |  |  |  |  |  |                                 clr.w d1
     b08:	|  |  |  |  |  |  |  |  |                                 swap d1
     b0a:	|  |  |  |  |  |  |  |  |                                 move.w d1,70(a3)
		*copListEnd++=offsetof(struct Custom, bplpt[0]) + (i + bplPtrStart) * sizeof(APTR) + 2;
     b0e:	|  |  |  |  |  |  |  |  |                                 move.w #242,72(a3)
		*copListEnd++=(UWORD)addr;
     b14:	|  |  |  |  |  |  |  |  |                                 move.w d0,74(a3)
	for (USHORT i=0;i<numPlanes;i++) {
     b18:	|  |  |  |  |  |  |  |  |                                 lea 76(a3),a1
     b1c:	|  |  |  |  |  |  |  |  |                                 move.l #6232,d2
     b22:	|  |  |  |  |  |  |  |  |                                 lea 24(sp),sp
		*copListEnd++=(UWORD)addr;
     b26:	|  |  |  |  |  |  |  |  |                                 lea 1818 <incbin_colors_start>,a0
     b2c:	|  |  |  |  |  |  |  |  |                                 move.w #382,d0
     b30:	|  |  |  |  |  |  |  |  |                                 sub.w d3,d0
     b32:	|  |  |  |  |  |  |  |  \-------------------------------- bra.w 558 <main+0x4cc>
		KPrintF("p61Init failed!\n");
     b36:	|  |  |  >--|--|--|--|----------------------------------> pea 32dd <incbin_player_end+0x11d>
     b3c:	|  |  |  |  |  |  |  |                                    jsr f88 <KPrintF>
     b42:	|  |  |  |  |  |  |  |                                    addq.l #4,sp
	warpmode(0);
     b44:	|  |  |  |  |  |  |  |                                    clr.l -(sp)
     b46:	|  |  |  |  |  |  |  |                                    jsr (a4)
	Forbid();
     b48:	|  |  |  |  |  |  |  |                                    movea.l 12b9a <SysBase>,a6
     b4e:	|  |  |  |  |  |  |  |                                    jsr -132(a6)
	SystemADKCON=custom->adkconr;
     b52:	|  |  |  |  |  |  |  |                                    movea.l 12ba4 <custom>,a0
     b58:	|  |  |  |  |  |  |  |                                    move.w 16(a0),d0
     b5c:	|  |  |  |  |  |  |  |                                    move.w d0,12b84 <SystemADKCON>
	SystemInts=custom->intenar;
     b62:	|  |  |  |  |  |  |  |                                    move.w 28(a0),d0
     b66:	|  |  |  |  |  |  |  |                                    move.w d0,12b88 <SystemInts>
	SystemDMA=custom->dmaconr;
     b6c:	|  |  |  |  |  |  |  |                                    move.w 2(a0),d0
     b70:	|  |  |  |  |  |  |  |                                    move.w d0,12b86 <SystemDMA>
	ActiView=GfxBase->ActiView; //store current view
     b76:	|  |  |  |  |  |  |  |                                    movea.l 12b96 <GfxBase>,a6
     b7c:	|  |  |  |  |  |  |  |                                    move.l 34(a6),12b80 <ActiView>
	LoadView(0);
     b84:	|  |  |  |  |  |  |  |                                    suba.l a1,a1
     b86:	|  |  |  |  |  |  |  |                                    jsr -222(a6)
	WaitTOF();
     b8a:	|  |  |  |  |  |  |  |                                    movea.l 12b96 <GfxBase>,a6
     b90:	|  |  |  |  |  |  |  |                                    jsr -270(a6)
	WaitTOF();
     b94:	|  |  |  |  |  |  |  |                                    movea.l 12b96 <GfxBase>,a6
     b9a:	|  |  |  |  |  |  |  |                                    jsr -270(a6)
	WaitVbl();
     b9e:	|  |  |  |  |  |  |  |                                    lea ed2 <WaitVbl>,a2
     ba4:	|  |  |  |  |  |  |  |                                    jsr (a2)
	WaitVbl();
     ba6:	|  |  |  |  |  |  |  |                                    jsr (a2)
	OwnBlitter();
     ba8:	|  |  |  |  |  |  |  |                                    movea.l 12b96 <GfxBase>,a6
     bae:	|  |  |  |  |  |  |  |                                    jsr -456(a6)
	WaitBlit();	
     bb2:	|  |  |  |  |  |  |  |                                    movea.l 12b96 <GfxBase>,a6
     bb8:	|  |  |  |  |  |  |  |                                    jsr -228(a6)
	Disable();
     bbc:	|  |  |  |  |  |  |  |                                    movea.l 12b9a <SysBase>,a6
     bc2:	|  |  |  |  |  |  |  |                                    jsr -120(a6)
	custom->intena=0x7fff;//disable all interrupts
     bc6:	|  |  |  |  |  |  |  |                                    movea.l 12ba4 <custom>,a0
     bcc:	|  |  |  |  |  |  |  |                                    move.w #32767,154(a0)
	custom->intreq=0x7fff;//Clear any interrupts that were pending
     bd2:	|  |  |  |  |  |  |  |                                    move.w #32767,156(a0)
	custom->dmacon=0x7fff;//Clear all DMA channels
     bd8:	|  |  |  |  |  |  |  |                                    move.w #32767,150(a0)
     bde:	|  |  |  |  |  |  |  |                                    addq.l #4,sp
	for(int a=0;a<32;a++)
     be0:	|  |  |  |  |  |  |  |                                    moveq #0,d1
     be2:	|  |  |  |  |  |  |  \----------------------------------- bra.w 1dc <main+0x150>
		Exit(0);
     be6:	>--|--|--|--|--|--|-------------------------------------> suba.l a6,a6
     be8:	|  |  |  |  |  |  |                                       moveq #0,d1
     bea:	|  |  |  |  |  |  |                                       jsr -144(a6)
	KPrintF("Hello debugger from Amiga!\n");
     bee:	|  |  |  |  |  |  |                                       pea 32b1 <incbin_player_end+0xf1>
     bf4:	|  |  |  |  |  |  |                                       jsr f88 <KPrintF>
	Write(Output(), (APTR)"Hello console!\n", 15);
     bfa:	|  |  |  |  |  |  |                                       movea.l 12b92 <DOSBase>,a6
     c00:	|  |  |  |  |  |  |                                       jsr -60(a6)
     c04:	|  |  |  |  |  |  |                                       movea.l 12b92 <DOSBase>,a6
     c0a:	|  |  |  |  |  |  |                                       move.l d0,d1
     c0c:	|  |  |  |  |  |  |                                       move.l #13005,d2
     c12:	|  |  |  |  |  |  |                                       moveq #15,d3
     c14:	|  |  |  |  |  |  |                                       jsr -48(a6)
	Delay(50);
     c18:	|  |  |  |  |  |  |                                       movea.l 12b92 <DOSBase>,a6
     c1e:	|  |  |  |  |  |  |                                       moveq #50,d1
     c20:	|  |  |  |  |  |  |                                       jsr -198(a6)
	warpmode(1);
     c24:	|  |  |  |  |  |  |                                       pea 1 <_start+0x1>
     c28:	|  |  |  |  |  |  |                                       lea ffa <warpmode>,a4
     c2e:	|  |  |  |  |  |  |                                       jsr (a4)
		register volatile const void* _a0 ASM("a0") = module;
     c30:	|  |  |  |  |  |  |                                       lea 11704 <incbin_module_start>,a0
		register volatile const void* _a1 ASM("a1") = NULL;
     c36:	|  |  |  |  |  |  |                                       suba.l a1,a1
		register volatile const void* _a2 ASM("a2") = NULL;
     c38:	|  |  |  |  |  |  |                                       suba.l a2,a2
		register volatile const void* _a3 ASM("a3") = player;
     c3a:	|  |  |  |  |  |  |                                       lea 185a <incbin_player_start>,a3
		__asm volatile (
     c40:	|  |  |  |  |  |  |                                       movem.l d1-d7/a4-a6,-(sp)
     c44:	|  |  |  |  |  |  |                                       jsr (a3)
     c46:	|  |  |  |  |  |  |                                       movem.l (sp)+,d1-d7/a4-a6
	if(p61Init(module) != 0)
     c4a:	|  |  |  |  |  |  |                                       addq.l #8,sp
     c4c:	|  |  |  |  |  |  |                                       tst.l d0
     c4e:	|  |  |  |  \--|--|-------------------------------------- beq.w 13e <main+0xb2>
     c52:	|  |  |  \-----|--|-------------------------------------- bra.w b36 <main+0xaaa>
		Exit(0);
     c56:	|  |  \--------|--|-------------------------------------> movea.l 12b92 <DOSBase>,a6
     c5c:	|  |           |  |                                       moveq #0,d1
     c5e:	|  |           |  |                                       jsr -144(a6)
	DOSBase = (struct DosLibrary*)OpenLibrary((CONST_STRPTR)"dos.library", 0);
     c62:	|  |           |  |                                       movea.l 12b9a <SysBase>,a6
     c68:	|  |           |  |                                       lea 32a5 <incbin_player_end+0xe5>,a1
     c6e:	|  |           |  |                                       moveq #0,d0
     c70:	|  |           |  |                                       jsr -552(a6)
     c74:	|  |           |  |                                       move.l d0,12b92 <DOSBase>
	if (!DOSBase)
     c7a:	|  \-----------|--|-------------------------------------- bne.w da <main+0x4e>
     c7e:	\--------------|--|-------------------------------------- bra.w be6 <main+0xb5a>
	APTR vbr = 0;
     c82:	               \--|-------------------------------------> moveq #0,d0
	VBR=GetVBR();
     c84:	                  |                                       move.l d0,12b8e <VBR>
	return *(volatile APTR*)(((UBYTE*)VBR)+0x6c);
     c8a:	                  |                                       movea.l 12b8e <VBR>,a0
     c90:	                  |                                       move.l 108(a0),d0
	SystemIrq=GetInterruptHandler(); //store interrupt register
     c94:	                  |                                       move.l d0,12b8a <SystemIrq>
	WaitVbl();
     c9a:	                  |                                       jsr (a2)
	char* test = (char*)AllocMem(2502, MEMF_ANY);
     c9c:	                  |                                       movea.l 12b9a <SysBase>,a6
     ca2:	                  |                                       move.l #2502,d0
     ca8:	                  |                                       moveq #0,d1
     caa:	                  |                                       jsr -198(a6)
     cae:	                  |                                       move.l d0,d4
	memset(test, 0xcd, 2502);
     cb0:	                  |                                       pea 9c6 <main+0x93a>
     cb4:	                  |                                       pea cd <main+0x41>
     cb8:	                  |                                       move.l d0,-(sp)
     cba:	                  |                                       jsr 12cc <memset>
	memclr(test + 2, 2502 - 4);
     cc0:	                  |                                       movea.l d4,a0
     cc2:	                  |                                       addq.l #2,a0
	__asm volatile (
     cc4:	                  |                                       move.l #2498,d5
     cca:	                  |                                       cmpi.l #256,d5
     cd0:	                  |                                /----- blt.w d2e <main+0xca2>
     cd4:	                  |                                |      adda.l d5,a0
     cd6:	                  |                                |      moveq #0,d0
     cd8:	                  |                                |      moveq #0,d1
     cda:	                  |                                |      moveq #0,d2
     cdc:	                  |                                |      moveq #0,d3
     cde:	                  |                                |  /-> movem.l d0-d3,-(a0)
     ce2:	                  |                                |  |   movem.l d0-d3,-(a0)
     ce6:	                  |                                |  |   movem.l d0-d3,-(a0)
     cea:	                  |                                |  |   movem.l d0-d3,-(a0)
     cee:	                  |                                |  |   movem.l d0-d3,-(a0)
     cf2:	                  |                                |  |   movem.l d0-d3,-(a0)
     cf6:	                  |                                |  |   movem.l d0-d3,-(a0)
     cfa:	                  |                                |  |   movem.l d0-d3,-(a0)
     cfe:	                  |                                |  |   movem.l d0-d3,-(a0)
     d02:	                  |                                |  |   movem.l d0-d3,-(a0)
     d06:	                  |                                |  |   movem.l d0-d3,-(a0)
     d0a:	                  |                                |  |   movem.l d0-d3,-(a0)
     d0e:	                  |                                |  |   movem.l d0-d3,-(a0)
     d12:	                  |                                |  |   movem.l d0-d3,-(a0)
     d16:	                  |                                |  |   movem.l d0-d3,-(a0)
     d1a:	                  |                                |  |   movem.l d0-d3,-(a0)
     d1e:	                  |                                |  |   subi.l #256,d5
     d24:	                  |                                |  |   cmpi.l #256,d5
     d2a:	                  |                                |  \-- bge.w cde <main+0xc52>
     d2e:	                  |                                >----> cmpi.w #64,d5
     d32:	                  |                                |  /-- blt.w d4e <main+0xcc2>
     d36:	                  |                                |  |   movem.l d0-d3,-(a0)
     d3a:	                  |                                |  |   movem.l d0-d3,-(a0)
     d3e:	                  |                                |  |   movem.l d0-d3,-(a0)
     d42:	                  |                                |  |   movem.l d0-d3,-(a0)
     d46:	                  |                                |  |   subi.w #64,d5
     d4a:	                  |                                \--|-- bra.w d2e <main+0xca2>
     d4e:	                  |                                   \-> lsr.w #2,d5
     d50:	                  |                                   /-- bcc.w d56 <main+0xcca>
     d54:	                  |                                   |   clr.w -(a0)
     d56:	                  |                                   \-> moveq #16,d0
     d58:	                  |                                       sub.w d5,d0
     d5a:	                  |                                       add.w d0,d0
     d5c:	                  |                                       jmp (d60 <main+0xcd4>,pc,d0.w)
     d60:	                  |                                       clr.l -(a0)
     d62:	                  |                                       clr.l -(a0)
     d64:	                  |                                       clr.l -(a0)
     d66:	                  |                                       clr.l -(a0)
     d68:	                  |                                       clr.l -(a0)
     d6a:	                  |                                       clr.l -(a0)
     d6c:	                  |                                       clr.l -(a0)
     d6e:	                  |                                       clr.l -(a0)
     d70:	                  |                                       clr.l -(a0)
     d72:	                  |                                       clr.l -(a0)
     d74:	                  |                                       clr.l -(a0)
     d76:	                  |                                       clr.l -(a0)
     d78:	                  |                                       clr.l -(a0)
     d7a:	                  |                                       clr.l -(a0)
     d7c:	                  |                                       clr.l -(a0)
     d7e:	                  |                                       clr.l -(a0)
	FreeMem(test, 2502);
     d80:	                  |                                       movea.l 12b9a <SysBase>,a6
     d86:	                  |                                       movea.l d4,a1
     d88:	                  |                                       move.l #2502,d0
     d8e:	                  |                                       jsr -210(a6)
	USHORT* copper1 = (USHORT*)AllocMem(1024, MEMF_CHIP);
     d92:	                  |                                       movea.l 12b9a <SysBase>,a6
     d98:	                  |                                       move.l #1024,d0
     d9e:	                  |                                       moveq #2,d1
     da0:	                  |                                       jsr -198(a6)
     da4:	                  |                                       movea.l d0,a3
	debug_register_bitmap(image, "image.bpl", 320, 256, 5, debug_resource_bitmap_interleaved);
     da6:	                  |                                       pea 1 <_start+0x1>
     daa:	                  |                                       pea 100 <main+0x74>
     dae:	                  |                                       pea 140 <main+0xb4>
     db2:	                  |                                       pea 32ee <incbin_player_end+0x12e>
     db8:	                  |                                       pea 4000 <incbin_image_start>
     dbe:	                  |                                       lea 1156 <debug_register_bitmap.constprop.0>,a4
     dc4:	                  |                                       jsr (a4)
	debug_register_bitmap(bob, "bob.bpl", 32, 96, 5, debug_resource_bitmap_interleaved | debug_resource_bitmap_masked);
     dc6:	                  |                                       lea 32(sp),sp
     dca:	                  |                                       pea 3 <_start+0x3>
     dce:	                  |                                       pea 60 <_start+0x60>
     dd2:	                  |                                       pea 20 <_start+0x20>
     dd6:	                  |                                       pea 32f8 <incbin_player_end+0x138>
     ddc:	                  |                                       pea 10802 <incbin_bob_start>
     de2:	                  |                                       jsr (a4)
	struct debug_resource resource = {
     de4:	                  |                                       clr.l -42(a5)
     de8:	                  |                                       clr.l -38(a5)
     dec:	                  |                                       clr.l -34(a5)
     df0:	                  |                                       clr.l -30(a5)
     df4:	                  |                                       clr.l -26(a5)
     df8:	                  |                                       clr.l -22(a5)
     dfc:	                  |                                       clr.l -18(a5)
     e00:	                  |                                       clr.l -14(a5)
     e04:	                  |                                       clr.l -10(a5)
     e08:	                  |                                       clr.l -6(a5)
     e0c:	                  |                                       clr.w -2(a5)
		.address = (unsigned int)addr,
     e10:	                  |                                       move.l #6168,d3
	struct debug_resource resource = {
     e16:	                  |                                       move.l d3,-50(a5)
     e1a:	                  |                                       moveq #64,d1
     e1c:	                  |                                       move.l d1,-46(a5)
     e20:	                  |                                       move.w #1,-10(a5)
     e26:	                  |                                       move.w #32,-6(a5)
     e2c:	                  |                                       lea 20(sp),sp
	while(*source && --num > 0)
     e30:	                  |                                       moveq #105,d0
	struct debug_resource resource = {
     e32:	                  |                                       lea -42(a5),a0
     e36:	                  |                                       lea 328a <incbin_player_end+0xca>,a1
	while(*source && --num > 0)
     e3c:	                  |                                       lea -11(a5),a4
     e40:	                  \-------------------------------------- bra.w 3e2 <main+0x356>

00000e44 <interruptHandler>:
static __attribute__((interrupt)) void interruptHandler() {
     e44:	    movem.l d0-d1/a0-a1/a3/a6,-(sp)
	custom->intreq=(1<<INTB_VERTB); custom->intreq=(1<<INTB_VERTB); //reset vbl req. twice for a4000 bug.
     e48:	    movea.l 12ba4 <custom>,a0
     e4e:	    move.w #32,156(a0)
     e54:	    move.w #32,156(a0)
	if(scroll) {
     e5a:	    movea.l 12ba0 <scroll>,a0
     e60:	    cmpa.w #0,a0
     e64:	/-- beq.s e86 <interruptHandler+0x42>
		int sin = sinus15[frameCounter & 63];
     e66:	|   move.w 12b9e <frameCounter>,d0
     e6c:	|   moveq #63,d1
     e6e:	|   and.l d1,d0
		*scroll = sin | (sin << 4);
     e70:	|   lea 33a2 <sinus15>,a1
     e76:	|   move.b (0,a1,d0.l),d0
     e7a:	|   andi.w #255,d0
     e7e:	|   move.w d0,d1
     e80:	|   lsl.w #4,d1
     e82:	|   or.w d0,d1
     e84:	|   move.w d1,(a0)
		register volatile const void* _a3 ASM("a3") = player;
     e86:	\-> lea 185a <incbin_player_start>,a3
		register volatile const void* _a6 ASM("a6") = (void*)0xdff000;
     e8c:	    movea.l #14675968,a6
		__asm volatile (
     e92:	    movem.l d0-a2/a4-a5,-(sp)
     e96:	    jsr 4(a3)
     e9a:	    movem.l (sp)+,d0-a2/a4-a5
	frameCounter++;
     e9e:	    move.w 12b9e <frameCounter>,d0
     ea4:	    addq.w #1,d0
     ea6:	    move.w d0,12b9e <frameCounter>
}
     eac:	    movem.l (sp)+,d0-d1/a0-a1/a3/a6
     eb0:	    rte

00000eb2 <debug_cmd.part.0>:
		UaeLib(88, arg1, arg2, arg3, arg4);
     eb2:	move.l 16(sp),-(sp)
     eb6:	move.l 16(sp),-(sp)
     eba:	move.l 16(sp),-(sp)
     ebe:	move.l 16(sp),-(sp)
     ec2:	pea 58 <_start+0x58>
     ec6:	jsr f0ff60 <_end+0xefd3b8>
}
     ecc:	lea 20(sp),sp
     ed0:	rts

00000ed2 <WaitVbl>:
void WaitVbl() {
     ed2:	             subq.l #8,sp
	if(*((UWORD *)UaeLib) == 0x4eb9 || *((UWORD *)UaeLib) == 0xa00e) {
     ed4:	             move.w f0ff60 <_end+0xefd3b8>,d0
     eda:	             cmpi.w #20153,d0
     ede:	      /----- beq.s f52 <WaitVbl+0x80>
     ee0:	      |      cmpi.w #-24562,d0
     ee4:	      +----- beq.s f52 <WaitVbl+0x80>
		volatile ULONG vpos=*(volatile ULONG*)0xDFF004;
     ee6:	/-----|----> move.l dff004 <_end+0xdec45c>,d0
     eec:	|     |      move.l d0,(sp)
		vpos&=0x1ff00;
     eee:	|     |      move.l (sp),d0
     ef0:	|     |      andi.l #130816,d0
     ef6:	|     |      move.l d0,(sp)
		if (vpos!=(311<<8))
     ef8:	|     |      move.l (sp),d0
     efa:	|     |      cmpi.l #79616,d0
     f00:	+-----|----- beq.s ee6 <WaitVbl+0x14>
		volatile ULONG vpos=*(volatile ULONG*)0xDFF004;
     f02:	|  /--|----> move.l dff004 <_end+0xdec45c>,d0
     f08:	|  |  |      move.l d0,4(sp)
		vpos&=0x1ff00;
     f0c:	|  |  |      move.l 4(sp),d0
     f10:	|  |  |      andi.l #130816,d0
     f16:	|  |  |      move.l d0,4(sp)
		if (vpos==(311<<8))
     f1a:	|  |  |      move.l 4(sp),d0
     f1e:	|  |  |      cmpi.l #79616,d0
     f24:	|  +--|----- bne.s f02 <WaitVbl+0x30>
     f26:	|  |  |      move.w f0ff60 <_end+0xefd3b8>,d0
     f2c:	|  |  |      cmpi.w #20153,d0
     f30:	|  |  |  /-- beq.s f3c <WaitVbl+0x6a>
     f32:	|  |  |  |   cmpi.w #-24562,d0
     f36:	|  |  |  +-- beq.s f3c <WaitVbl+0x6a>
}
     f38:	|  |  |  |   addq.l #8,sp
     f3a:	|  |  |  |   rts
     f3c:	|  |  |  \-> clr.l -(sp)
     f3e:	|  |  |      clr.l -(sp)
     f40:	|  |  |      clr.l -(sp)
     f42:	|  |  |      pea 5 <_start+0x5>
     f46:	|  |  |      jsr eb2 <debug_cmd.part.0>(pc)
}
     f4a:	|  |  |      lea 16(sp),sp
     f4e:	|  |  |      addq.l #8,sp
     f50:	|  |  |      rts
     f52:	|  |  \----> clr.l -(sp)
     f54:	|  |         clr.l -(sp)
     f56:	|  |         pea 1 <_start+0x1>
     f5a:	|  |         pea 5 <_start+0x5>
     f5e:	|  |         jsr eb2 <debug_cmd.part.0>(pc)
}
     f62:	|  |         lea 16(sp),sp
		volatile ULONG vpos=*(volatile ULONG*)0xDFF004;
     f66:	|  |         move.l dff004 <_end+0xdec45c>,d0
     f6c:	|  |         move.l d0,(sp)
		vpos&=0x1ff00;
     f6e:	|  |         move.l (sp),d0
     f70:	|  |         andi.l #130816,d0
     f76:	|  |         move.l d0,(sp)
		if (vpos!=(311<<8))
     f78:	|  |         move.l (sp),d0
     f7a:	|  |         cmpi.l #79616,d0
     f80:	\--|-------- beq.w ee6 <WaitVbl+0x14>
     f84:	   \-------- bra.w f02 <WaitVbl+0x30>

00000f88 <KPrintF>:
void KPrintF(const char* fmt, ...) {
     f88:	    lea -128(sp),sp
     f8c:	    movem.l a2-a3/a6,-(sp)
	if(*((UWORD *)UaeDbgLog) == 0x4eb9 || *((UWORD *)UaeDbgLog) == 0xa00e) {
     f90:	    move.w f0ff60 <_end+0xefd3b8>,d0
     f96:	    cmpi.w #20153,d0
     f9a:	/-- beq.s fc6 <KPrintF+0x3e>
     f9c:	|   cmpi.w #-24562,d0
     fa0:	+-- beq.s fc6 <KPrintF+0x3e>
		RawDoFmt((CONST_STRPTR)fmt, vl, KPutCharX, 0);
     fa2:	|   movea.l 12b9a <SysBase>,a6
     fa8:	|   movea.l 144(sp),a0
     fac:	|   lea 148(sp),a1
     fb0:	|   lea 1662 <KPutCharX>,a2
     fb6:	|   suba.l a3,a3
     fb8:	|   jsr -522(a6)
}
     fbc:	|   movem.l (sp)+,a2-a3/a6
     fc0:	|   lea 128(sp),sp
     fc4:	|   rts
		RawDoFmt((CONST_STRPTR)fmt, vl, PutChar, temp);
     fc6:	\-> movea.l 12b9a <SysBase>,a6
     fcc:	    movea.l 144(sp),a0
     fd0:	    lea 148(sp),a1
     fd4:	    lea 1670 <PutChar>,a2
     fda:	    lea 12(sp),a3
     fde:	    jsr -522(a6)
		UaeDbgLog(86, temp);
     fe2:	    move.l a3,-(sp)
     fe4:	    pea 56 <_start+0x56>
     fe8:	    jsr f0ff60 <_end+0xefd3b8>
	if(*((UWORD *)UaeDbgLog) == 0x4eb9 || *((UWORD *)UaeDbgLog) == 0xa00e) {
     fee:	    addq.l #8,sp
}
     ff0:	    movem.l (sp)+,a2-a3/a6
     ff4:	    lea 128(sp),sp
     ff8:	    rts

00000ffa <warpmode>:
void warpmode(int on) { // bool
     ffa:	       subq.l #4,sp
     ffc:	       move.l a2,-(sp)
     ffe:	       move.l d2,-(sp)
	if(*((UWORD *)UaeConf) == 0x4eb9 || *((UWORD *)UaeConf) == 0xa00e) {
    1000:	       move.w f0ff60 <_end+0xefd3b8>,d0
    1006:	       cmpi.w #20153,d0
    100a:	   /-- beq.s 101a <warpmode+0x20>
    100c:	   |   cmpi.w #-24562,d0
    1010:	   +-- beq.s 101a <warpmode+0x20>
}
    1012:	   |   move.l (sp)+,d2
    1014:	   |   movea.l (sp)+,a2
    1016:	   |   addq.l #4,sp
    1018:	   |   rts
		UaeConf(82, -1, on ? "cpu_speed max" : "cpu_speed real", 0, &outbuf, 1);
    101a:	   \-> tst.l 16(sp)
    101e:	/----- beq.w 10be <warpmode+0xc4>
    1022:	|      pea 1 <_start+0x1>
    1026:	|      moveq #15,d2
    1028:	|      add.l sp,d2
    102a:	|      move.l d2,-(sp)
    102c:	|      clr.l -(sp)
    102e:	|      pea 322f <incbin_player_end+0x6f>
    1034:	|      pea ffffffff <_end+0xfffed457>
    1038:	|      pea 52 <_start+0x52>
    103c:	|      movea.l #15794016,a2
    1042:	|      jsr (a2)
		UaeConf(82, -1, on ? "cpu_cycle_exact false" : "cpu_cycle_exact true", 0, &outbuf, 1);
    1044:	|      pea 1 <_start+0x1>
    1048:	|      move.l d2,-(sp)
    104a:	|      clr.l -(sp)
    104c:	|      pea 323d <incbin_player_end+0x7d>
    1052:	|      pea ffffffff <_end+0xfffed457>
    1056:	|      pea 52 <_start+0x52>
    105a:	|      jsr (a2)
		UaeConf(82, -1, on ? "cpu_memory_cycle_exact false" : "cpu_memory_cycle_exact true", 0, &outbuf, 1);
    105c:	|      lea 48(sp),sp
    1060:	|      pea 1 <_start+0x1>
    1064:	|      move.l d2,-(sp)
    1066:	|      clr.l -(sp)
    1068:	|      pea 3253 <incbin_player_end+0x93>
    106e:	|      pea ffffffff <_end+0xfffed457>
    1072:	|      pea 52 <_start+0x52>
    1076:	|      jsr (a2)
		UaeConf(82, -1, on ? "blitter_cycle_exact false" : "blitter_cycle_exact true", 0, &outbuf, 1);
    1078:	|      pea 1 <_start+0x1>
    107c:	|      move.l d2,-(sp)
    107e:	|      clr.l -(sp)
    1080:	|      pea 3270 <incbin_player_end+0xb0>
    1086:	|      pea ffffffff <_end+0xfffed457>
    108a:	|      pea 52 <_start+0x52>
    108e:	|      jsr (a2)
    1090:	|      lea 48(sp),sp
		UaeConf(82, -1, on ? "warp true" : "warp false", 0, &outbuf, 1);
    1094:	|      move.l #12737,d0
    109a:	|      pea 1 <_start+0x1>
    109e:	|      move.l d2,-(sp)
    10a0:	|      clr.l -(sp)
    10a2:	|      move.l d0,-(sp)
    10a4:	|      pea ffffffff <_end+0xfffed457>
    10a8:	|      pea 52 <_start+0x52>
    10ac:	|      jsr f0ff60 <_end+0xefd3b8>
}
    10b2:	|      lea 24(sp),sp
    10b6:	|  /-> move.l (sp)+,d2
    10b8:	|  |   movea.l (sp)+,a2
    10ba:	|  |   addq.l #4,sp
    10bc:	|  |   rts
		UaeConf(82, -1, on ? "cpu_speed max" : "cpu_speed real", 0, &outbuf, 1);
    10be:	\--|-> pea 1 <_start+0x1>
    10c2:	   |   moveq #15,d2
    10c4:	   |   add.l sp,d2
    10c6:	   |   move.l d2,-(sp)
    10c8:	   |   clr.l -(sp)
    10ca:	   |   pea 31d6 <incbin_player_end+0x16>
    10d0:	   |   pea ffffffff <_end+0xfffed457>
    10d4:	   |   pea 52 <_start+0x52>
    10d8:	   |   movea.l #15794016,a2
    10de:	   |   jsr (a2)
		UaeConf(82, -1, on ? "cpu_cycle_exact false" : "cpu_cycle_exact true", 0, &outbuf, 1);
    10e0:	   |   pea 1 <_start+0x1>
    10e4:	   |   move.l d2,-(sp)
    10e6:	   |   clr.l -(sp)
    10e8:	   |   pea 31e5 <incbin_player_end+0x25>
    10ee:	   |   pea ffffffff <_end+0xfffed457>
    10f2:	   |   pea 52 <_start+0x52>
    10f6:	   |   jsr (a2)
		UaeConf(82, -1, on ? "cpu_memory_cycle_exact false" : "cpu_memory_cycle_exact true", 0, &outbuf, 1);
    10f8:	   |   lea 48(sp),sp
    10fc:	   |   pea 1 <_start+0x1>
    1100:	   |   move.l d2,-(sp)
    1102:	   |   clr.l -(sp)
    1104:	   |   pea 31fa <incbin_player_end+0x3a>
    110a:	   |   pea ffffffff <_end+0xfffed457>
    110e:	   |   pea 52 <_start+0x52>
    1112:	   |   jsr (a2)
		UaeConf(82, -1, on ? "blitter_cycle_exact false" : "blitter_cycle_exact true", 0, &outbuf, 1);
    1114:	   |   pea 1 <_start+0x1>
    1118:	   |   move.l d2,-(sp)
    111a:	   |   clr.l -(sp)
    111c:	   |   pea 3216 <incbin_player_end+0x56>
    1122:	   |   pea ffffffff <_end+0xfffed457>
    1126:	   |   pea 52 <_start+0x52>
    112a:	   |   jsr (a2)
    112c:	   |   lea 48(sp),sp
		UaeConf(82, -1, on ? "warp true" : "warp false", 0, &outbuf, 1);
    1130:	   |   move.l #12747,d0
    1136:	   |   pea 1 <_start+0x1>
    113a:	   |   move.l d2,-(sp)
    113c:	   |   clr.l -(sp)
    113e:	   |   move.l d0,-(sp)
    1140:	   |   pea ffffffff <_end+0xfffed457>
    1144:	   |   pea 52 <_start+0x52>
    1148:	   |   jsr f0ff60 <_end+0xefd3b8>
}
    114e:	   |   lea 24(sp),sp
    1152:	   \-- bra.w 10b6 <warpmode+0xbc>

00001156 <debug_register_bitmap.constprop.0>:
void debug_register_bitmap(const void* addr, const char* name, short width, short height, short numPlanes, unsigned short flags) {
    1156:	       link.w a5,#-52
    115a:	       movem.l d2-d4/a2,-(sp)
    115e:	       movea.l 12(a5),a1
    1162:	       move.l 16(a5),d4
    1166:	       move.l 20(a5),d3
    116a:	       move.l 24(a5),d2
	struct debug_resource resource = {
    116e:	       clr.l -42(a5)
    1172:	       clr.l -38(a5)
    1176:	       clr.l -34(a5)
    117a:	       clr.l -30(a5)
    117e:	       clr.l -26(a5)
    1182:	       clr.l -22(a5)
    1186:	       clr.l -18(a5)
    118a:	       clr.l -14(a5)
    118e:	       clr.w -10(a5)
    1192:	       move.l 8(a5),-50(a5)
		.size = width / 8 * height * numPlanes,
    1198:	       move.w d4,d0
    119a:	       asr.w #3,d0
    119c:	       muls.w d3,d0
    119e:	       move.l d0,d1
    11a0:	       add.l d0,d1
    11a2:	       add.l d1,d1
    11a4:	       add.l d1,d0
	struct debug_resource resource = {
    11a6:	       move.l d0,-46(a5)
    11aa:	       move.w d2,-8(a5)
    11ae:	       move.w d4,-6(a5)
    11b2:	       move.w d3,-4(a5)
    11b6:	       move.w #5,-2(a5)
	if (flags & debug_resource_bitmap_masked)
    11bc:	       btst #1,d2
    11c0:	   /-- beq.s 11c8 <debug_register_bitmap.constprop.0+0x72>
		resource.size *= 2;
    11c2:	   |   add.l d0,d0
    11c4:	   |   move.l d0,-46(a5)
	while(*source && --num > 0)
    11c8:	   \-> move.b (a1),d0
    11ca:	       lea -42(a5),a0
    11ce:	/----- beq.s 11e0 <debug_register_bitmap.constprop.0+0x8a>
    11d0:	|      lea -11(a5),a2
		*destination++ = *source++;
    11d4:	|  /-> addq.l #1,a1
    11d6:	|  |   move.b d0,(a0)+
	while(*source && --num > 0)
    11d8:	|  |   move.b (a1),d0
    11da:	+--|-- beq.s 11e0 <debug_register_bitmap.constprop.0+0x8a>
    11dc:	|  |   cmpa.l a0,a2
    11de:	|  \-- bne.s 11d4 <debug_register_bitmap.constprop.0+0x7e>
	*destination = '\0';
    11e0:	\----> clr.b (a0)
	if(*((UWORD *)UaeLib) == 0x4eb9 || *((UWORD *)UaeLib) == 0xa00e) {
    11e2:	       move.w f0ff60 <_end+0xefd3b8>,d0
    11e8:	       cmpi.w #20153,d0
    11ec:	   /-- beq.s 11fe <debug_register_bitmap.constprop.0+0xa8>
    11ee:	   |   cmpi.w #-24562,d0
    11f2:	   +-- beq.s 11fe <debug_register_bitmap.constprop.0+0xa8>
}
    11f4:	   |   movem.l -68(a5),d2-d4/a2
    11fa:	   |   unlk a5
    11fc:	   |   rts
    11fe:	   \-> clr.l -(sp)
    1200:	       clr.l -(sp)
    1202:	       pea -50(a5)
    1206:	       pea 4 <_start+0x4>
    120a:	       jsr eb2 <debug_cmd.part.0>(pc)
    120e:	       lea 16(sp),sp
    1212:	       movem.l -68(a5),d2-d4/a2
    1218:	       unlk a5
    121a:	       rts

0000121c <debug_register_copperlist.constprop.0>:
	};
	my_strncpy(resource.name, name, sizeof(resource.name));
	debug_cmd(barto_cmd_register_resource, (unsigned int)&resource, 0, 0);
}

void debug_register_copperlist(const void* addr, const char* name, unsigned int size, unsigned short flags) {
    121c:	       link.w a5,#-52
    1220:	       move.l a2,-(sp)
    1222:	       movea.l 12(a5),a1
	struct debug_resource resource = {
    1226:	       clr.l -42(a5)
    122a:	       clr.l -38(a5)
    122e:	       clr.l -34(a5)
    1232:	       clr.l -30(a5)
    1236:	       clr.l -26(a5)
    123a:	       clr.l -22(a5)
    123e:	       clr.l -18(a5)
    1242:	       clr.l -14(a5)
    1246:	       clr.l -10(a5)
    124a:	       clr.l -6(a5)
    124e:	       clr.w -2(a5)
    1252:	       move.l 8(a5),-50(a5)
    1258:	       move.l 16(a5),-46(a5)
    125e:	       move.w #2,-10(a5)
	while(*source && --num > 0)
    1264:	       move.b (a1),d0
    1266:	       lea -42(a5),a0
    126a:	/----- beq.s 127c <debug_register_copperlist.constprop.0+0x60>
    126c:	|      lea -11(a5),a2
		*destination++ = *source++;
    1270:	|  /-> addq.l #1,a1
    1272:	|  |   move.b d0,(a0)+
	while(*source && --num > 0)
    1274:	|  |   move.b (a1),d0
    1276:	+--|-- beq.s 127c <debug_register_copperlist.constprop.0+0x60>
    1278:	|  |   cmpa.l a0,a2
    127a:	|  \-- bne.s 1270 <debug_register_copperlist.constprop.0+0x54>
	*destination = '\0';
    127c:	\----> clr.b (a0)
	if(*((UWORD *)UaeLib) == 0x4eb9 || *((UWORD *)UaeLib) == 0xa00e) {
    127e:	       move.w f0ff60 <_end+0xefd3b8>,d0
    1284:	       cmpi.w #20153,d0
    1288:	   /-- beq.s 1298 <debug_register_copperlist.constprop.0+0x7c>
    128a:	   |   cmpi.w #-24562,d0
    128e:	   +-- beq.s 1298 <debug_register_copperlist.constprop.0+0x7c>
		.type = debug_resource_type_copperlist,
		.flags = flags,
	};
	my_strncpy(resource.name, name, sizeof(resource.name));
	debug_cmd(barto_cmd_register_resource, (unsigned int)&resource, 0, 0);
}
    1290:	   |   movea.l -56(a5),a2
    1294:	   |   unlk a5
    1296:	   |   rts
    1298:	   \-> clr.l -(sp)
    129a:	       clr.l -(sp)
    129c:	       pea -50(a5)
    12a0:	       pea 4 <_start+0x4>
    12a4:	       jsr eb2 <debug_cmd.part.0>(pc)
    12a8:	       lea 16(sp),sp
    12ac:	       movea.l -56(a5),a2
    12b0:	       unlk a5
    12b2:	       rts

000012b4 <strlen>:
	while(*s++)
    12b4:	   /-> movea.l 4(sp),a0
    12b8:	   |   tst.b (a0)+
    12ba:	/--|-- beq.s 12c8 <strlen+0x14>
    12bc:	|  |   move.l a0,-(sp)
    12be:	|  \-- jsr 12b4 <strlen>(pc)
    12c2:	|      addq.l #4,sp
    12c4:	|      addq.l #1,d0
}
    12c6:	|      rts
	unsigned long t=0;
    12c8:	\----> moveq #0,d0
}
    12ca:	       rts

000012cc <memset>:
void* memset(void *dest, int val, unsigned long len) {
    12cc:	                      movem.l d2-d7/a2,-(sp)
    12d0:	                      move.l 32(sp),d0
    12d4:	                      move.l 36(sp),d3
    12d8:	                      movea.l 40(sp),a0
	while(len-- > 0)
    12dc:	                      lea -1(a0),a1
    12e0:	                      cmpa.w #0,a0
    12e4:	               /----- beq.w 1392 <memset+0xc6>
		*ptr++ = val;
    12e8:	               |      move.b d3,d7
    12ea:	               |      move.l d0,d2
    12ec:	               |      neg.l d2
    12ee:	               |      moveq #3,d1
    12f0:	               |      and.l d2,d1
    12f2:	               |      moveq #5,d4
    12f4:	               |      cmp.l a1,d4
    12f6:	/--------------|----- bcc.w 1432 <memset+0x166>
    12fa:	|              |      tst.l d1
    12fc:	|           /--|----- beq.w 13cc <memset+0x100>
    1300:	|           |  |      movea.l d0,a1
    1302:	|           |  |      move.b d3,(a1)
	while(len-- > 0)
    1304:	|           |  |      btst #1,d2
    1308:	|           |  |  /-- beq.w 1398 <memset+0xcc>
		*ptr++ = val;
    130c:	|           |  |  |   move.b d3,1(a1)
	while(len-- > 0)
    1310:	|           |  |  |   moveq #3,d2
    1312:	|           |  |  |   cmp.l d1,d2
    1314:	|  /--------|--|--|-- bne.w 13fc <memset+0x130>
		*ptr++ = val;
    1318:	|  |        |  |  |   lea 3(a1),a2
    131c:	|  |        |  |  |   move.b d3,2(a1)
	while(len-- > 0)
    1320:	|  |        |  |  |   lea -4(a0),a1
    1324:	|  |        |  |  |   move.l a0,d4
    1326:	|  |        |  |  |   sub.l d1,d4
    1328:	|  |        |  |  |   moveq #0,d5
    132a:	|  |        |  |  |   move.b d3,d5
    132c:	|  |        |  |  |   move.l d5,d6
    132e:	|  |        |  |  |   swap d6
    1330:	|  |        |  |  |   clr.w d6
    1332:	|  |        |  |  |   move.l d3,d2
    1334:	|  |        |  |  |   lsl.w #8,d2
    1336:	|  |        |  |  |   swap d2
    1338:	|  |        |  |  |   clr.w d2
    133a:	|  |        |  |  |   lsl.l #8,d5
    133c:	|  |        |  |  |   or.l d6,d2
    133e:	|  |        |  |  |   or.l d5,d2
    1340:	|  |        |  |  |   move.b d7,d2
    1342:	|  |        |  |  |   movea.l d0,a0
    1344:	|  |        |  |  |   adda.l d1,a0
    1346:	|  |        |  |  |   moveq #-4,d5
    1348:	|  |        |  |  |   and.l d4,d5
    134a:	|  |        |  |  |   move.l d5,d1
    134c:	|  |        |  |  |   add.l a0,d1
		*ptr++ = val;
    134e:	|  |  /-----|--|--|-> move.l d2,(a0)+
	while(len-- > 0)
    1350:	|  |  |     |  |  |   cmp.l a0,d1
    1352:	|  |  +-----|--|--|-- bne.s 134e <memset+0x82>
    1354:	|  |  |     |  |  |   cmp.l d5,d4
    1356:	|  |  |     |  +--|-- beq.s 1392 <memset+0xc6>
    1358:	|  |  |     |  |  |   lea (0,a2,d5.l),a0
    135c:	|  |  |     |  |  |   suba.l d5,a1
		*ptr++ = val;
    135e:	|  |  |  /--|--|--|-> move.b d3,(a0)
	while(len-- > 0)
    1360:	|  |  |  |  |  |  |   cmpa.w #0,a1
    1364:	|  |  |  |  |  +--|-- beq.s 1392 <memset+0xc6>
		*ptr++ = val;
    1366:	|  |  |  |  |  |  |   move.b d3,1(a0)
	while(len-- > 0)
    136a:	|  |  |  |  |  |  |   moveq #1,d1
    136c:	|  |  |  |  |  |  |   cmp.l a1,d1
    136e:	|  |  |  |  |  +--|-- beq.s 1392 <memset+0xc6>
		*ptr++ = val;
    1370:	|  |  |  |  |  |  |   move.b d3,2(a0)
	while(len-- > 0)
    1374:	|  |  |  |  |  |  |   moveq #2,d2
    1376:	|  |  |  |  |  |  |   cmp.l a1,d2
    1378:	|  |  |  |  |  +--|-- beq.s 1392 <memset+0xc6>
		*ptr++ = val;
    137a:	|  |  |  |  |  |  |   move.b d3,3(a0)
	while(len-- > 0)
    137e:	|  |  |  |  |  |  |   moveq #3,d4
    1380:	|  |  |  |  |  |  |   cmp.l a1,d4
    1382:	|  |  |  |  |  +--|-- beq.s 1392 <memset+0xc6>
		*ptr++ = val;
    1384:	|  |  |  |  |  |  |   move.b d3,4(a0)
	while(len-- > 0)
    1388:	|  |  |  |  |  |  |   moveq #4,d1
    138a:	|  |  |  |  |  |  |   cmp.l a1,d1
    138c:	|  |  |  |  |  +--|-- beq.s 1392 <memset+0xc6>
		*ptr++ = val;
    138e:	|  |  |  |  |  |  |   move.b d3,5(a0)
}
    1392:	|  |  |  |  |  \--|-> movem.l (sp)+,d2-d7/a2
    1396:	|  |  |  |  |     |   rts
		*ptr++ = val;
    1398:	|  |  |  |  |     \-> lea 1(a1),a2
	while(len-- > 0)
    139c:	|  |  |  |  |         lea -2(a0),a1
    13a0:	|  |  |  |  |         move.l a0,d4
    13a2:	|  |  |  |  |         sub.l d1,d4
    13a4:	|  |  |  |  |         moveq #0,d5
    13a6:	|  |  |  |  |         move.b d3,d5
    13a8:	|  |  |  |  |         move.l d5,d6
    13aa:	|  |  |  |  |         swap d6
    13ac:	|  |  |  |  |         clr.w d6
    13ae:	|  |  |  |  |         move.l d3,d2
    13b0:	|  |  |  |  |         lsl.w #8,d2
    13b2:	|  |  |  |  |         swap d2
    13b4:	|  |  |  |  |         clr.w d2
    13b6:	|  |  |  |  |         lsl.l #8,d5
    13b8:	|  |  |  |  |         or.l d6,d2
    13ba:	|  |  |  |  |         or.l d5,d2
    13bc:	|  |  |  |  |         move.b d7,d2
    13be:	|  |  |  |  |         movea.l d0,a0
    13c0:	|  |  |  |  |         adda.l d1,a0
    13c2:	|  |  |  |  |         moveq #-4,d5
    13c4:	|  |  |  |  |         and.l d4,d5
    13c6:	|  |  |  |  |         move.l d5,d1
    13c8:	|  |  |  |  |         add.l a0,d1
    13ca:	|  |  +--|--|-------- bra.s 134e <memset+0x82>
	unsigned char *ptr = (unsigned char *)dest;
    13cc:	|  |  |  |  \-------> movea.l d0,a2
    13ce:	|  |  |  |            move.l a0,d4
    13d0:	|  |  |  |            sub.l d1,d4
    13d2:	|  |  |  |            moveq #0,d5
    13d4:	|  |  |  |            move.b d3,d5
    13d6:	|  |  |  |            move.l d5,d6
    13d8:	|  |  |  |            swap d6
    13da:	|  |  |  |            clr.w d6
    13dc:	|  |  |  |            move.l d3,d2
    13de:	|  |  |  |            lsl.w #8,d2
    13e0:	|  |  |  |            swap d2
    13e2:	|  |  |  |            clr.w d2
    13e4:	|  |  |  |            lsl.l #8,d5
    13e6:	|  |  |  |            or.l d6,d2
    13e8:	|  |  |  |            or.l d5,d2
    13ea:	|  |  |  |            move.b d7,d2
    13ec:	|  |  |  |            movea.l d0,a0
    13ee:	|  |  |  |            adda.l d1,a0
    13f0:	|  |  |  |            moveq #-4,d5
    13f2:	|  |  |  |            and.l d4,d5
    13f4:	|  |  |  |            move.l d5,d1
    13f6:	|  |  |  |            add.l a0,d1
    13f8:	|  |  +--|----------- bra.w 134e <memset+0x82>
		*ptr++ = val;
    13fc:	|  \--|--|----------> lea 2(a1),a2
	while(len-- > 0)
    1400:	|     |  |            lea -3(a0),a1
    1404:	|     |  |            move.l a0,d4
    1406:	|     |  |            sub.l d1,d4
    1408:	|     |  |            moveq #0,d5
    140a:	|     |  |            move.b d3,d5
    140c:	|     |  |            move.l d5,d6
    140e:	|     |  |            swap d6
    1410:	|     |  |            clr.w d6
    1412:	|     |  |            move.l d3,d2
    1414:	|     |  |            lsl.w #8,d2
    1416:	|     |  |            swap d2
    1418:	|     |  |            clr.w d2
    141a:	|     |  |            lsl.l #8,d5
    141c:	|     |  |            or.l d6,d2
    141e:	|     |  |            or.l d5,d2
    1420:	|     |  |            move.b d7,d2
    1422:	|     |  |            movea.l d0,a0
    1424:	|     |  |            adda.l d1,a0
    1426:	|     |  |            moveq #-4,d5
    1428:	|     |  |            and.l d4,d5
    142a:	|     |  |            move.l d5,d1
    142c:	|     |  |            add.l a0,d1
    142e:	|     \--|----------- bra.w 134e <memset+0x82>
	unsigned char *ptr = (unsigned char *)dest;
    1432:	\--------|----------> movea.l d0,a0
    1434:	         \----------- bra.w 135e <memset+0x92>

00001438 <memcpy>:
void* memcpy(void *dest, const void *src, unsigned long len) {
    1438:	             movem.l d2-d4/a2,-(sp)
    143c:	             move.l 20(sp),d0
    1440:	             movea.l 24(sp),a2
    1444:	             move.l 28(sp),d1
	while(len--)
    1448:	             move.l d1,d3
    144a:	             subq.l #1,d3
    144c:	             tst.l d1
    144e:	/----------- beq.s 149e <memcpy+0x66>
    1450:	|            moveq #6,d2
    1452:	|            cmp.l d3,d2
    1454:	|  /-------- bcc.s 14a4 <memcpy+0x6c>
    1456:	|  |         move.l a2,d2
    1458:	|  |         or.l d0,d2
    145a:	|  |         moveq #3,d4
    145c:	|  |         and.l d4,d2
    145e:	|  |         lea 1(a2),a0
    1462:	|  |  /----- bne.s 14a8 <memcpy+0x70>
    1464:	|  |  |      movea.l d0,a1
    1466:	|  |  |      suba.l a0,a1
    1468:	|  |  |      moveq #2,d2
    146a:	|  |  |      cmp.l a1,d2
    146c:	|  |  +----- bcc.s 14a8 <memcpy+0x70>
    146e:	|  |  |      movea.l a2,a0
    1470:	|  |  |      movea.l d0,a1
    1472:	|  |  |      moveq #-4,d2
    1474:	|  |  |      and.l d1,d2
    1476:	|  |  |      adda.l d2,a2
		*d++ = *s++;
    1478:	|  |  |  /-> move.l (a0)+,(a1)+
	while(len--)
    147a:	|  |  |  |   cmpa.l a2,a0
    147c:	|  |  |  \-- bne.s 1478 <memcpy+0x40>
    147e:	|  |  |      movea.l d0,a0
    1480:	|  |  |      adda.l d2,a0
    1482:	|  |  |      sub.l d2,d3
    1484:	|  |  |      cmp.l d1,d2
    1486:	+--|--|----- beq.s 149e <memcpy+0x66>
		*d++ = *s++;
    1488:	|  |  |      move.b (a2),(a0)
	while(len--)
    148a:	|  |  |      tst.l d3
    148c:	+--|--|----- beq.s 149e <memcpy+0x66>
		*d++ = *s++;
    148e:	|  |  |      move.b 1(a2),1(a0)
	while(len--)
    1494:	|  |  |      subq.l #1,d3
    1496:	+--|--|----- beq.s 149e <memcpy+0x66>
		*d++ = *s++;
    1498:	|  |  |      move.b 2(a2),2(a0)
}
    149e:	>--|--|----> movem.l (sp)+,d2-d4/a2
    14a2:	|  |  |      rts
    14a4:	|  \--|----> lea 1(a2),a0
    14a8:	|     \----> movea.l d0,a1
    14aa:	|            add.l a2,d1
		*d++ = *s++;
    14ac:	|        /-> move.b -1(a0),(a1)+
	while(len--)
    14b0:	|        |   cmp.l a0,d1
    14b2:	\--------|-- beq.s 149e <memcpy+0x66>
    14b4:	         |   addq.l #1,a0
    14b6:	         \-- bra.s 14ac <memcpy+0x74>

000014b8 <memmove>:
void* memmove(void *dest, const void *src, unsigned long len) {
    14b8:	             movem.l d2-d4/a2-a3,-(sp)
    14bc:	             move.l 24(sp),d0
    14c0:	             move.l 28(sp),d1
    14c4:	             move.l 32(sp),d2
		while (len--)
    14c8:	             movea.l d2,a2
    14ca:	             subq.l #1,a2
	if (d < s) {
    14cc:	             cmp.l d0,d1
    14ce:	      /----- bls.s 152e <memmove+0x76>
		while (len--)
    14d0:	      |      tst.l d2
    14d2:	/-----|----- beq.s 1528 <memmove+0x70>
    14d4:	|     |      moveq #6,d3
    14d6:	|     |      movea.l d1,a1
    14d8:	|     |      addq.l #1,a1
    14da:	|     |      cmp.l a2,d3
    14dc:	|  /--|----- bcc.s 1554 <memmove+0x9c>
    14de:	|  |  |      movea.l d0,a0
    14e0:	|  |  |      suba.l a1,a0
    14e2:	|  |  |      moveq #2,d4
    14e4:	|  |  |      cmp.l a0,d4
    14e6:	|  +--|----- bcc.s 1554 <memmove+0x9c>
    14e8:	|  |  |      move.l d1,d3
    14ea:	|  |  |      or.l d0,d3
    14ec:	|  |  |      moveq #3,d4
    14ee:	|  |  |      and.l d4,d3
    14f0:	|  +--|----- bne.s 1554 <memmove+0x9c>
    14f2:	|  |  |      movea.l d1,a0
    14f4:	|  |  |      movea.l d0,a1
    14f6:	|  |  |      moveq #-4,d1
    14f8:	|  |  |      and.l d2,d1
    14fa:	|  |  |      lea (0,a0,d1.l),a3
			*d++ = *s++;
    14fe:	|  |  |  /-> move.l (a0)+,(a1)+
		while (len--)
    1500:	|  |  |  |   cmpa.l a3,a0
    1502:	|  |  |  \-- bne.s 14fe <memmove+0x46>
    1504:	|  |  |      movea.l d0,a0
    1506:	|  |  |      adda.l d1,a0
    1508:	|  |  |      suba.l d1,a2
    150a:	|  |  |      cmp.l d2,d1
    150c:	+--|--|----- beq.s 1528 <memmove+0x70>
			*d++ = *s++;
    150e:	|  |  |      move.b (a3),(a0)
		while (len--)
    1510:	|  |  |      cmpa.w #0,a2
    1514:	+--|--|----- beq.s 1528 <memmove+0x70>
			*d++ = *s++;
    1516:	|  |  |      move.b 1(a3),1(a0)
		while (len--)
    151c:	|  |  |      moveq #1,d1
    151e:	|  |  |      cmp.l a2,d1
    1520:	+--|--|----- beq.s 1528 <memmove+0x70>
			*d++ = *s++;
    1522:	|  |  |      move.b 2(a3),2(a0)
}
    1528:	>--|--|----> movem.l (sp)+,d2-d4/a2-a3
    152c:	|  |  |      rts
		const char *lasts = s + (len - 1);
    152e:	|  |  \----> lea (0,a2,d1.l),a0
		char *lastd = d + (len - 1);
    1532:	|  |         lea (0,a2,d0.l),a1
		while (len--)
    1536:	|  |         tst.l d2
    1538:	+--|-------- beq.s 1528 <memmove+0x70>
    153a:	|  |         move.l a0,d1
    153c:	|  |         sub.l d2,d1
			*lastd-- = *lasts--;
    153e:	|  |     /-> move.b (a0),(a1)
		while (len--)
    1540:	|  |     |   subq.l #1,a0
    1542:	|  |     |   subq.l #1,a1
    1544:	|  |     |   cmp.l a0,d1
    1546:	+--|-----|-- beq.s 1528 <memmove+0x70>
			*lastd-- = *lasts--;
    1548:	|  |     |   move.b (a0),(a1)
		while (len--)
    154a:	|  |     |   subq.l #1,a0
    154c:	|  |     |   subq.l #1,a1
    154e:	|  |     |   cmp.l a0,d1
    1550:	|  |     \-- bne.s 153e <memmove+0x86>
    1552:	+--|-------- bra.s 1528 <memmove+0x70>
    1554:	|  \-------> movea.l d0,a2
    1556:	|            movea.l d1,a0
    1558:	|            adda.l d2,a0
			*d++ = *s++;
    155a:	|        /-> move.b -1(a1),(a2)+
		while (len--)
    155e:	|        |   cmpa.l a1,a0
    1560:	\--------|-- beq.s 1528 <memmove+0x70>
    1562:	         |   addq.l #1,a1
    1564:	         \-- bra.s 155a <memmove+0xa2>
    1566:	             nop

00001568 <__mulsi3>:
	.text
	.type __mulsi3, function
	.globl	__mulsi3
__mulsi3:
	.cfi_startproc
	movew	sp@(4), d0	/* x0 -> d0 */
    1568:	move.w 4(sp),d0
	muluw	sp@(10), d0	/* x0*y1 */
    156c:	mulu.w 10(sp),d0
	movew	sp@(6), d1	/* x1 -> d1 */
    1570:	move.w 6(sp),d1
	muluw	sp@(8), d1	/* x1*y0 */
    1574:	mulu.w 8(sp),d1
	addw	d1, d0
    1578:	add.w d1,d0
	swap	d0
    157a:	swap d0
	clrw	d0
    157c:	clr.w d0
	movew	sp@(6), d1	/* x1 -> d1 */
    157e:	move.w 6(sp),d1
	muluw	sp@(10), d1	/* x1*y1 */
    1582:	mulu.w 10(sp),d1
	addl	d1, d0
    1586:	add.l d1,d0
	rts
    1588:	rts

0000158a <__udivsi3>:
	.text
	.type __udivsi3, function
	.globl	__udivsi3
__udivsi3:
	.cfi_startproc
	movel	d2, sp@-
    158a:	       move.l d2,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	sp@(12), d1	/* d1 = divisor */
    158c:	       move.l 12(sp),d1
	movel	sp@(8), d0	/* d0 = dividend */
    1590:	       move.l 8(sp),d0

	cmpl	#0x10000, d1 /* divisor >= 2 ^ 16 ?   */
    1594:	       cmpi.l #65536,d1
	jcc	3f		/* then try next algorithm */
    159a:	   /-- bcc.s 15b2 <__udivsi3+0x28>
	movel	d0, d2
    159c:	   |   move.l d0,d2
	clrw	d2
    159e:	   |   clr.w d2
	swap	d2
    15a0:	   |   swap d2
	divu	d1, d2          /* high quotient in lower word */
    15a2:	   |   divu.w d1,d2
	movew	d2, d0		/* save high quotient */
    15a4:	   |   move.w d2,d0
	swap	d0
    15a6:	   |   swap d0
	movew	sp@(10), d2	/* get low dividend + high rest */
    15a8:	   |   move.w 10(sp),d2
	divu	d1, d2		/* low quotient */
    15ac:	   |   divu.w d1,d2
	movew	d2, d0
    15ae:	   |   move.w d2,d0
	jra	6f
    15b0:	/--|-- bra.s 15e2 <__udivsi3+0x58>

3:	movel	d1, d2		/* use d2 as divisor backup */
    15b2:	|  \-> move.l d1,d2
4:	lsrl	#1, d1	/* shift divisor */
    15b4:	|  /-> lsr.l #1,d1
	lsrl	#1, d0	/* shift dividend */
    15b6:	|  |   lsr.l #1,d0
	cmpl	#0x10000, d1 /* still divisor >= 2 ^ 16 ?  */
    15b8:	|  |   cmpi.l #65536,d1
	jcc	4b
    15be:	|  \-- bcc.s 15b4 <__udivsi3+0x2a>
	divu	d1, d0		/* now we have 16-bit divisor */
    15c0:	|      divu.w d1,d0
	andl	#0xffff, d0 /* mask out divisor, ignore remainder */
    15c2:	|      andi.l #65535,d0

/* Multiply the 16-bit tentative quotient with the 32-bit divisor.  Because of
   the operand ranges, this might give a 33-bit product.  If this product is
   greater than the dividend, the tentative quotient was too large. */
	movel	d2, d1
    15c8:	|      move.l d2,d1
	mulu	d0, d1		/* low part, 32 bits */
    15ca:	|      mulu.w d0,d1
	swap	d2
    15cc:	|      swap d2
	mulu	d0, d2		/* high part, at most 17 bits */
    15ce:	|      mulu.w d0,d2
	swap	d2		/* align high part with low part */
    15d0:	|      swap d2
	tstw	d2		/* high part 17 bits? */
    15d2:	|      tst.w d2
	jne	5f		/* if 17 bits, quotient was too large */
    15d4:	|  /-- bne.s 15e0 <__udivsi3+0x56>
	addl	d2, d1		/* add parts */
    15d6:	|  |   add.l d2,d1
	jcs	5f		/* if sum is 33 bits, quotient was too large */
    15d8:	|  +-- bcs.s 15e0 <__udivsi3+0x56>
	cmpl	sp@(8), d1	/* compare the sum with the dividend */
    15da:	|  |   cmp.l 8(sp),d1
	jls	6f		/* if sum > dividend, quotient was too large */
    15de:	+--|-- bls.s 15e2 <__udivsi3+0x58>
5:	subql	#1, d0	/* adjust quotient */
    15e0:	|  \-> subq.l #1,d0

6:	movel	sp@+, d2
    15e2:	\----> move.l (sp)+,d2
	.cfi_adjust_cfa_offset -4
	rts
    15e4:	       rts

000015e6 <__divsi3>:
	.text
	.type __divsi3, function
	.globl	__divsi3
 __divsi3:
 	.cfi_startproc
	movel	d2, sp@-
    15e6:	    move.l d2,-(sp)
	.cfi_adjust_cfa_offset 4

	moveq	#1, d2	/* sign of result stored in d2 (=1 or =-1) */
    15e8:	    moveq #1,d2
	movel	sp@(12), d1	/* d1 = divisor */
    15ea:	    move.l 12(sp),d1
	jpl	1f
    15ee:	/-- bpl.s 15f4 <__divsi3+0xe>
	negl	d1
    15f0:	|   neg.l d1
	negb	d2		/* change sign because divisor <0  */
    15f2:	|   neg.b d2
1:	movel	sp@(8), d0	/* d0 = dividend */
    15f4:	\-> move.l 8(sp),d0
	jpl	2f
    15f8:	/-- bpl.s 15fe <__divsi3+0x18>
	negl	d0
    15fa:	|   neg.l d0
	negb	d2
    15fc:	|   neg.b d2

2:	movel	d1, sp@-
    15fe:	\-> move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
    1600:	    move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	jbsr	__udivsi3	/* divide abs(dividend) by abs(divisor) */
    1602:	    bsr.s 158a <__udivsi3>
	addql	#8, sp
    1604:	    addq.l #8,sp
	.cfi_adjust_cfa_offset -8

	tstb	d2
    1606:	    tst.b d2
	jpl	3f
    1608:	/-- bpl.s 160c <__divsi3+0x26>
	negl	d0
    160a:	|   neg.l d0

3:	movel	sp@+, d2
    160c:	\-> move.l (sp)+,d2
	.cfi_adjust_cfa_offset -4
	rts
    160e:	    rts

00001610 <__modsi3>:
	.text
	.type __modsi3, function
	.globl	__modsi3
__modsi3:
	.cfi_startproc
	movel	sp@(8), d1	/* d1 = divisor */
    1610:	move.l 8(sp),d1
	movel	sp@(4), d0	/* d0 = dividend */
    1614:	move.l 4(sp),d0
	movel	d1, sp@-
    1618:	move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
    161a:	move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	jbsr	__divsi3
    161c:	bsr.s 15e6 <__divsi3>
	addql	#8, sp
    161e:	addq.l #8,sp
	.cfi_adjust_cfa_offset -8
	movel	sp@(8), d1	/* d1 = divisor */
    1620:	move.l 8(sp),d1
	movel	d1, sp@-
    1624:	move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
    1626:	move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	jbsr	__mulsi3	/* d0 = (a/b)*b */
    1628:	bsr.w 1568 <__mulsi3>
	addql	#8, sp
    162c:	addq.l #8,sp
	.cfi_adjust_cfa_offset -8
	movel	sp@(4), d1	/* d1 = dividend */
    162e:	move.l 4(sp),d1
	subl	d0, d1		/* d1 = a - (a/b)*b */
    1632:	sub.l d0,d1
	movel	d1, d0
    1634:	move.l d1,d0
	rts
    1636:	rts

00001638 <__umodsi3>:
	.text
	.type __umodsi3, function
	.globl	__umodsi3
__umodsi3:
	.cfi_startproc
	movel	sp@(8), d1	/* d1 = divisor */
    1638:	move.l 8(sp),d1
	movel	sp@(4), d0	/* d0 = dividend */
    163c:	move.l 4(sp),d0
	movel	d1, sp@-
    1640:	move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
    1642:	move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	jbsr	__udivsi3
    1644:	bsr.w 158a <__udivsi3>
	addql	#8, sp
    1648:	addq.l #8,sp
	.cfi_adjust_cfa_offset -8
	movel	sp@(8), d1	/* d1 = divisor */
    164a:	move.l 8(sp),d1
	movel	d1, sp@-
    164e:	move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
    1650:	move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	jbsr	__mulsi3	/* d0 = (a/b)*b */
    1652:	bsr.w 1568 <__mulsi3>
	addql	#8, sp
    1656:	addq.l #8,sp
	.cfi_adjust_cfa_offset -8
	movel	sp@(4), d1	/* d1 = dividend */
    1658:	move.l 4(sp),d1
	subl	d0, d1		/* d1 = a - (a/b)*b */
    165c:	sub.l d0,d1
	movel	d1, d0
    165e:	move.l d1,d0
	rts
    1660:	rts

00001662 <KPutCharX>:
	.type KPutCharX, function
	.globl	KPutCharX

KPutCharX:
	.cfi_startproc
    move.l  a6, -(sp)
    1662:	move.l a6,-(sp)
	.cfi_adjust_cfa_offset 4
    move.l  4.w, a6
    1664:	movea.l 4 <_start+0x4>,a6
    jsr     -0x204(a6)
    1668:	jsr -516(a6)
    move.l (sp)+, a6
    166c:	movea.l (sp)+,a6
	.cfi_adjust_cfa_offset -4
    rts
    166e:	rts

00001670 <PutChar>:
	.type PutChar, function
	.globl	PutChar

PutChar:
	.cfi_startproc
	move.b d0, (a3)+
    1670:	move.b d0,(a3)+
	rts
    1672:	rts

00001674 <_doynaxdepack_asm>:

	|Entry point. Wind up the decruncher
	.type _doynaxdepack_asm,function
	.globl _doynaxdepack_asm
_doynaxdepack_asm:
	movea.l	(a0)+,a2				|Unaligned literal buffer at the end of
    1674:	                         movea.l (a0)+,a2
	adda.l	a0,a2					|the stream
    1676:	                         adda.l a0,a2
	move.l	a2,a3
    1678:	                         movea.l a2,a3
	move.l	(a0)+,d0				|Seed the shift register
    167a:	                         move.l (a0)+,d0
	moveq	#0x38,d4				|Masks for match offset extraction
    167c:	                         moveq #56,d4
	moveq	#8,d5
    167e:	                         moveq #8,d5
	bra.s	.Lliteral
    1680:	   /-------------------- bra.s 16ea <_doynaxdepack_asm+0x76>

	|******** Copy a literal sequence ********

.Llcopy:							|Copy two bytes at a time, with the
	move.b	(a0)+,(a1)+				|deferral of the length LSB helping
    1682:	/--|-------------------> move.b (a0)+,(a1)+
	move.b	(a0)+,(a1)+				|slightly in the unrolling
    1684:	|  |                     move.b (a0)+,(a1)+
	dbf		d1,.Llcopy
    1686:	+--|-------------------- dbf d1,1682 <_doynaxdepack_asm+0xe>

	lsl.l	#2,d0					|Copy odd bytes separately in order
    168a:	|  |                     lsl.l #2,d0
	bcc.s	.Lmatch					|to keep the source aligned
    168c:	|  |     /-------------- bcc.s 1690 <_doynaxdepack_asm+0x1c>
.Llsingle:
	move.b	(a2)+,(a1)+
    168e:	|  |  /--|-------------> move.b (a2)+,(a1)+

	|******** Process a match ********

	|Start by refilling the bit-buffer
.Lmatch:
	DOY_REFILL1 mprefix
    1690:	|  |  |  >-------------> tst.w d0
    1692:	|  |  |  |           /-- bne.s 169c <_doynaxdepack_asm+0x28>
	cmp.l	a0,a3					|Take the opportunity to test for the
    1694:	|  |  |  |           |   cmpa.l a0,a3
	bls.s	.Lreturn				|end of the stream while refilling
    1696:	|  |  |  |           |   bls.s 170e <doy_table+0x6>
.Lmrefill:
	DOY_REFILL2
    1698:	|  |  |  |           |   move.w (a0)+,d0
    169a:	|  |  |  |           |   swap d0

.Lmprefix:
	|Fetch the first three bits identifying the match length, and look up
	|the corresponding table entry
	rol.l	#3+3,d0
    169c:	|  |  |  |           \-> rol.l #6,d0
	move.w	d0,d1
    169e:	|  |  |  |               move.w d0,d1
	and.w	d4,d1
    16a0:	|  |  |  |               and.w d4,d1
	eor.w	d1,d0
    16a2:	|  |  |  |               eor.w d1,d0
	movem.w	doy_table(pc,d1.w),d2/d3/a4
    16a4:	|  |  |  |               movem.w (1708 <doy_table>,pc,d1.w),d2-d3/a4

	|Extract the offset bits and compute the relative source address from it
	rol.l	d2,d0					|Reduced by 3 to account for 8x offset
    16aa:	|  |  |  |               rol.l d2,d0
	and.w	d0,d3					|scaling
    16ac:	|  |  |  |               and.w d0,d3
	eor.w	d3,d0
    16ae:	|  |  |  |               eor.w d3,d0
	suba.w	d3,a4
    16b0:	|  |  |  |               suba.w d3,a4
	adda.l	a1,a4
    16b2:	|  |  |  |               adda.l a1,a4

	|Decode the match length
	DOY_REFILL
    16b4:	|  |  |  |               tst.w d0
    16b6:	|  |  |  |           /-- bne.s 16bc <_doynaxdepack_asm+0x48>
    16b8:	|  |  |  |           |   move.w (a0)+,d0
    16ba:	|  |  |  |           |   swap d0
	and.w	d5,d1					|Check the initial length bit from the
    16bc:	|  |  |  |           \-> and.w d5,d1
	beq.s	.Lmcopy					|type triple
    16be:	|  |  |  |  /----------- beq.s 16d6 <_doynaxdepack_asm+0x62>

	moveq	#1,d1					|This loops peeks at the next flag
    16c0:	|  |  |  |  |            moveq #1,d1
	tst.l	d0						|through the sign bit bit while keeping
    16c2:	|  |  |  |  |            tst.l d0
	bpl.s	.Lmendlen2				|the LSB in carry
    16c4:	|  |  |  |  |  /-------- bpl.s 16d2 <_doynaxdepack_asm+0x5e>
	lsl.l	#2,d0
    16c6:	|  |  |  |  |  |         lsl.l #2,d0
	bpl.s	.Lmendlen1
    16c8:	|  |  |  |  |  |  /----- bpl.s 16d0 <_doynaxdepack_asm+0x5c>
.Lmgetlen:
	addx.b	d1,d1
    16ca:	|  |  |  |  |  |  |  /-> addx.b d1,d1
	lsl.l	#2,d0
    16cc:	|  |  |  |  |  |  |  |   lsl.l #2,d0
	bmi.s	.Lmgetlen
    16ce:	|  |  |  |  |  |  |  \-- bmi.s 16ca <_doynaxdepack_asm+0x56>
.Lmendlen1:
	addx.b	d1,d1
    16d0:	|  |  |  |  |  |  \----> addx.b d1,d1
.Lmendlen2:
	|Copy the match data a word at a time. Note that the minimum length is
	|two bytes
	lsl.l	#2,d0					|The trailing length payload bit is
    16d2:	|  |  |  |  |  \-------> lsl.l #2,d0
	bcc.s	.Lmhalf					|stored out-of-order
    16d4:	|  |  |  |  |        /-- bcc.s 16d8 <_doynaxdepack_asm+0x64>
.Lmcopy:
	move.b	(a4)+,(a1)+
    16d6:	|  |  |  |  >--------|-> move.b (a4)+,(a1)+
.Lmhalf:
	move.b	(a4)+,(a1)+
    16d8:	|  |  |  |  |        \-> move.b (a4)+,(a1)+
	dbf		d1,.Lmcopy
    16da:	|  |  |  |  \----------- dbf d1,16d6 <_doynaxdepack_asm+0x62>

	|Fetch a bit flag to see whether what follows is a literal run or
	|another match
	add.l	d0,d0
    16de:	|  |  |  |               add.l d0,d0
	bcc.s	.Lmatch
    16e0:	|  |  |  \-------------- bcc.s 1690 <_doynaxdepack_asm+0x1c>


	|******** Process a run of literal bytes ********

	DOY_REFILL						|Replenish the shift-register
    16e2:	|  |  |                  tst.w d0
    16e4:	|  +--|----------------- bne.s 16ea <_doynaxdepack_asm+0x76>
    16e6:	|  |  |                  move.w (a0)+,d0
    16e8:	|  |  |                  swap d0
.Lliteral:
	|Extract delta-coded run length in the same swizzled format as the
	|matches above
	moveq	#0,d1
    16ea:	|  \--|----------------> moveq #0,d1
	add.l	d0,d0
    16ec:	|     |                  add.l d0,d0
	bcc.s	.Llsingle				|Single out the one-byte case
    16ee:	|     \----------------- bcc.s 168e <_doynaxdepack_asm+0x1a>
	bpl.s	.Llendlen
    16f0:	|                 /----- bpl.s 16f8 <_doynaxdepack_asm+0x84>
.Llgetlen:
	addx.b	d1,d1
    16f2:	|                 |  /-> addx.b d1,d1
	lsl.l	#2,d0
    16f4:	|                 |  |   lsl.l #2,d0
	bmi.s	.Llgetlen
    16f6:	|                 |  \-- bmi.s 16f2 <_doynaxdepack_asm+0x7e>
.Llendlen:
	addx.b	d1,d1
    16f8:	|                 \----> addx.b d1,d1
	|or greater, in which case the sixteen guaranteed bits in the buffer
	|may have run out.
	|In the latter case simply give up and stuff the payload bits back onto
	|the stream before fetching a literal 16-bit run length instead
.Llcopy_near:
	dbvs	d1,.Llcopy
    16fa:	\--------------------/-X dbv.s d1,1682 <_doynaxdepack_asm+0xe>

	add.l	d0,d0
    16fe:	                     |   add.l d0,d0
	eor.w	d1,d0		
    1700:	                     |   eor.w d1,d0
	ror.l	#7+1,d0					|Note that the constant MSB acts as a
    1702:	                     |   ror.l #8,d0
	move.w	(a0)+,d1				|substitute for the unfetched stop bit
    1704:	                     |   move.w (a0)+,d1
	bra.s	.Llcopy_near
    1706:	                     \-- bra.s 16fa <_doynaxdepack_asm+0x86>

00001708 <doy_table>:
    1708:	......Nu........
doy_table:
	DOY_OFFSET 3,1					|Short A
.Lreturn:
	rts
	DOY_OFFSET 4,1					|Long A
	dc.w	0						|(Empty hole)
    1718:	...?............
	DOY_OFFSET 6,1+8				|Short B
	dc.w	0						|(Empty hole)
	DOY_OFFSET 7,1+16				|Long B
	dc.w	0						|(Empty hole)
    1728:	.............o..
	DOY_OFFSET 8,1+8+64				|Short C
	dc.w	0						|(Empty hole)
	DOY_OFFSET 10,1+16+128			|Long C
	dc.w	0						|(Empty hole)
    1738:	.............o

Disassembly of section CODE:

00001746 <_doynaxdepack_vasm>:
		swap.w	d0						;encoder is in on the scheme
		endm

		;Entry point. Wind up the decruncher
_doynaxdepack_vasm:
		movea.l	(a0)+,a2				;Unaligned literal buffer at the end of
    1746:	movea.l (a0)+,a2
		adda.l	a0,a2					;the stream
    1748:	adda.l a0,a2
		move.l	a2,a3
    174a:	movea.l a2,a3
		move.l	(a0)+,d0				;Seed the shift register
    174c:	move.l (a0)+,d0
		moveq	#@70,d4					;Masks for match offset extraction
    174e:	moveq #56,d4
		moveq	#@10,d5
    1750:	moveq #8,d5
		bra.s	doy_literal
    1752:	bra.s 17bc <doy_full_000006>

00001754 <doy_lcopy>:


		;******** Copy a literal sequence ********

doy_lcopy:								;Copy two bytes at a time, with the
		move.b	(a0)+,(a1)+				;deferral of the length LSB helping
    1754:	/-> move.b (a0)+,(a1)+
		move.b	(a0)+,(a1)+				;slightly in the unrolling
    1756:	|   move.b (a0)+,(a1)+
		dbf		d1,doy_lcopy
    1758:	\-- dbf d1,1754 <doy_lcopy>

		lsl.l	#2,d0					;Copy odd bytes separately in order
    175c:	    lsl.l #2,d0
		bcc.s	doy_match				;to keep the source aligned
    175e:	    bcc.s 1762 <doy_match>

00001760 <doy_lsingle>:
doy_lsingle:
		move.b	(a2)+,(a1)+
    1760:	move.b (a2)+,(a1)+

00001762 <doy_match>:
		tst.w	d0
    1762:	tst.w d0
		bne.s	\1
    1764:	bne.s 176e <doy_mprefix>
		;******** Process a match ********

		;Start by refilling the bit-buffer
doy_match:
		DOY_REFILL1 doy_mprefix
		cmp.l	a0,a3					;Take the opportunity to test for the
    1766:	cmpa.l a0,a3
		bls.s	doy_return				;end of the stream while refilling
    1768:	bls.s 17e0 <doy_return>

0000176a <doy_mrefill>:
		move.w	(a0)+,d0				;old, but that's fine as long as the
    176a:	move.w (a0)+,d0
		swap.w	d0						;encoder is in on the scheme
    176c:	swap d0

0000176e <doy_mprefix>:
		DOY_REFILL2

doy_mprefix:
		;Fetch the first three bits identifying the match length, and look up
		;the corresponding table entry
		rol.l	#3+3,d0
    176e:	rol.l #6,d0
		move.w	d0,d1
    1770:	move.w d0,d1
		and.w	d4,d1
    1772:	and.w d4,d1
		eor.w	d1,d0
    1774:	eor.w d1,d0
		movem.w	doy_table(pc,d1.w),d2/d3/a4
    1776:	movem.w (17da <doy_table>,pc,d1.w),d2-d3/a4

		;Extract the offset bits and compute the relative source address from it
		rol.l	d2,d0					;Reduced by 3 to account for 8x offset
    177c:	rol.l d2,d0
		and.w	d0,d3					;scaling
    177e:	and.w d0,d3
		eor.w	d3,d0
    1780:	eor.w d3,d0
		suba.w	d3,a4
    1782:	suba.w d3,a4
		adda.l	a1,a4
    1784:	adda.l a1,a4
		tst.w	d0
    1786:	tst.w d0
		bne.s	\1
    1788:	bne.s 178e <doy_full_000003>
		move.w	(a0)+,d0				;old, but that's fine as long as the
    178a:	move.w (a0)+,d0
		swap.w	d0						;encoder is in on the scheme
    178c:	swap d0

0000178e <doy_full_000003>:

		;Decode the match length
		DOY_REFILL
		and.w	d5,d1					;Check the initial length bit from the
    178e:	and.w d5,d1
		beq.s	doy_mcopy				;type triple
    1790:	beq.s 17a8 <doy_mcopy>

		moveq	#1,d1					;This loops peeks at the next flag
    1792:	moveq #1,d1
		tst.l	d0						;through the sign bit bit while keeping
    1794:	tst.l d0
		bpl.s	doy_mendlen2			;the LSB in carry
    1796:	bpl.s 17a4 <doy_mendlen2>
		lsl.l	#2,d0
    1798:	lsl.l #2,d0
		bpl.s	doy_mendlen1
    179a:	bpl.s 17a2 <doy_mendlen1>

0000179c <doy_mgetlen>:
doy_mgetlen:
		addx.b	d1,d1
    179c:	/-> addx.b d1,d1
		lsl.l	#2,d0
    179e:	|   lsl.l #2,d0
		bmi.s	doy_mgetlen
    17a0:	\-- bmi.s 179c <doy_mgetlen>

000017a2 <doy_mendlen1>:
doy_mendlen1:
		addx.b	d1,d1
    17a2:	addx.b d1,d1

000017a4 <doy_mendlen2>:
doy_mendlen2:

		;Copy the match data a word at a time. Note that the minimum length is
		;two bytes
		lsl.l	#2,d0					;The trailing length payload bit is
    17a4:	lsl.l #2,d0
		bcc.s	doy_mhalf				;stored out-of-order
    17a6:	bcc.s 17aa <doy_mhalf>

000017a8 <doy_mcopy>:
doy_mcopy:
		move.b	(a4)+,(a1)+
    17a8:	move.b (a4)+,(a1)+

000017aa <doy_mhalf>:
doy_mhalf:
		move.b	(a4)+,(a1)+
    17aa:	move.b (a4)+,(a1)+
		dbf		d1,doy_mcopy
    17ac:	dbf d1,17a8 <doy_mcopy>

		;Fetch a bit flag to see whether what follows is a literal run or
		;another match
		add.l	d0,d0
    17b0:	add.l d0,d0
		bcc.s	doy_match
    17b2:	bcc.s 1762 <doy_match>
		tst.w	d0
    17b4:	tst.w d0
		bne.s	\1
    17b6:	bne.s 17bc <doy_full_000006>
		move.w	(a0)+,d0				;old, but that's fine as long as the
    17b8:	move.w (a0)+,d0
		swap.w	d0						;encoder is in on the scheme
    17ba:	swap d0

000017bc <doy_full_000006>:

		DOY_REFILL						;Replenish the shift-register
doy_literal:
		;Extract delta-coded run length in the same swizzled format as the
		;matches above
		moveq	#0,d1
    17bc:	moveq #0,d1
		add.l	d0,d0
    17be:	add.l d0,d0
		bcc.s	doy_lsingle				;Single out the one-byte case
    17c0:	bcc.s 1760 <doy_lsingle>
		bpl.s	doy_lendlen
    17c2:	bpl.s 17ca <doy_lendlen>

000017c4 <doy_lgetlen>:
doy_lgetlen:
		addx.b	d1,d1
    17c4:	/-> addx.b d1,d1
		lsl.l	#2,d0
    17c6:	|   lsl.l #2,d0
		bmi.s	doy_lgetlen
    17c8:	\-- bmi.s 17c4 <doy_lgetlen>

000017ca <doy_lendlen>:
doy_lendlen:
		addx.b	d1,d1
    17ca:	addx.b d1,d1

000017cc <doy_lcopy_near>:
		;or greater, in which case the sixteen guaranteed bits in the buffer
		;may have run out.
		;In the latter case simply give up and stuff the payload bits back onto
		;the stream before fetching a literal 16-bit run length instead
doy_lcopy_near:
		dbvs	d1,doy_lcopy
    17cc:	/-> dbv.s d1,1754 <doy_lcopy>

		add.l	d0,d0
    17d0:	|   add.l d0,d0
		eor.w	d1,d0		
    17d2:	|   eor.w d1,d0
		ror.l	#7+1,d0					;Note that the constant MSB acts as a
    17d4:	|   ror.l #8,d0
		move.w	(a0)+,d1				;substitute for the unfetched stop bit
    17d6:	|   move.w (a0)+,d1
		bra.s	doy_lcopy_near
    17d8:	\-- bra.s 17cc <doy_lcopy_near>

000017da <doy_table>:
    17da:	ori.b #7,d0
    17de:	.short 0xffff

000017e0 <doy_return>:
		endm

doy_table:
		DOY_OFFSET 3,1					;Short A
doy_return:
		rts
    17e0:	rts
    17e2:	ori.b #15,d1
    17e6:	.short 0xffff
    17e8:	ori.b #3,d0
    17ec:	.short 0x003f
    17ee:	.short 0xfff7
    17f0:	ori.b #4,d0
    17f4:	.short 0x007f
    17f6:	.short 0xffef
    17f8:	ori.b #5,d0
    17fc:	.short 0x00ff
    17fe:	.short 0xffb7
    1800:	ori.b #7,d0
    1804:	.short 0x03ff
    1806:	.short 0xff6f
    1808:	ori.b #7,d0
    180c:	.short 0x03ff
    180e:	.short 0xfeb7
    1810:	ori.b #10,d0
    1814:	.short 0x1fff
    1816:	.short 0xfb6f
