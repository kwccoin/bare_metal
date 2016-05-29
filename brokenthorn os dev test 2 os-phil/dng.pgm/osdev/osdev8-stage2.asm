; osdev8-stage2.asm

; osdev5 cannot work as you cannot just put a code to anywhere you like ... I guess

; mount this and copy like normal file need

; sudo mkdir -p /media/osdev8
; sudo mount -o loop /home/chichunng/Desktop/hgfs/2016-05-20c-mac.osdev/dng.pgm/osdev/osdev8.flp /media/osev6/
; ?sudo? cp osdev8-steage2.bin /media/floppy6/STAGE2.SYS

; sudo umount /media/floppy6 

; Note: Here, we are executed like a normal
; COM program, but we are still in Ring 0.
; We will use this loader to set up 32 bit
; mode and basic exception handling
 
; This loaded program will be our 32 bit Kernel.
 
; We do not have the limitation of 512 bytes here,
; so we can add anything we want here!

; above old stage2
; below new stage2
 
bits	16
 
; Remember the memory map-- 0x500 through 0x7bff is unused above the BIOS data area.
; We are loaded at 0x500 (0x50:0)
 
org 0x500
 
jmp	main				; go to start
 
;*******************************************************
;	Preprocessor directives
;*******************************************************
 
%include "osdev8-stdio.inc"			; basic i/o routines
%include "osdev8-Gdt.inc"			; Gdt routines
 
;*******************************************************
;	Data Section
;*******************************************************
 
LoadingMsg db "Preparing to load operating system...", 0x0D, 0x0A, 0x00
 
;*******************************************************
;	STAGE 2 ENTRY POINT
;
;		-Store BIOS information
;		-Load Kernel
;		-Install GDT; go into protected mode (pmode)
;		-Jump to Stage 3
;*******************************************************
 
main:
 
	;-------------------------------;
	;   Setup segments and stack	;
	;-------------------------------;
 
	xchg bx,bx
	cli				; clear interrupts
	xor	ax, ax			; null segments
	mov	ds, ax
	mov	es, ax
	mov	ax, 0x9000		; stack begins at 0x9000-0xffff
	mov	ss, ax
	mov	sp, 0xFFFF
	sti				; enable interrupts
 
	;-------------------------------;
	;   Print loading message	;
	;-------------------------------;
 
	mov	si, LoadingMsg
	call	Puts16
 
	;-------------------------------;
	;   Install our GDT		;
	;-------------------------------;
 
	call	InstallGDT		; install our GDT
 
	;-------------------------------;
	;   Go into pmode		;
	;-------------------------------;
 
	cli				; clear interrupts
	mov	eax, cr0		; set bit 0 in cr0--enter pmode
	or	eax, 1
	mov	cr0, eax
 
 	xchg bx,bx
 	xchg bx,bx
 	xchg bx,bx
 	xchg bx,bx
 	
	
	jmp	08h:Stage3		; far jump to fix CS. Remember that the code selector is 0x8!
 
	; Note: Do NOT re-enable interrupts! Doing so will triple fault!
	; We will fix this in Stage 3.
 
;******************************************************
;	ENTRY POINT FOR STAGE 3
;******************************************************
 
bits 32					; Welcome to the 32 bit world!
 
Stage3:
 
	;-------------------------------;
	;   Set registers		;
	;-------------------------------;
 
	xchg    bx,bx
	mov		ax, 0x10		; set data segments to data selector (0x10)
	mov		ds, ax
	mov		ss, ax
	mov		es, ax
	mov		esp, 90000h		; stack begins from 90000h
 
;*******************************************************
;	Stop execution
;*******************************************************
 
STOP:
 
	xchg	bx,bx
	xchg	bx,bx
	xchg	bx,bx
	xchg	bx,bx
	xchg 	bx,bx
 	xchg 	bx,bx
 	
	
	cli
	hlt