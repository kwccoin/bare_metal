
;*******************************************************
;
;	Stage2.asm
;		Stage2 Bootloader
;
;	OS Development Series
;*******************************************************

bits	16

; Remember the memory map-- 0x500 through 0x7bff is unused above the BIOS data area.
; We are loaded at 0x500 (0x50:0)

org 0x500

jmp	main				; go to start

;*******************************************************
;	Preprocessor directives
;*******************************************************

%include "osdev9-stdio.inc"			; basic i/o routines
%include "osdev9-Gdt.inc"			; Gdt routines
%include "osdev9-A20.inc"

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

	cli				; clear interrupts
	xchg	bx,bx
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
	xchg	bx,bx
	call	Puts16

	;-------------------------------;
	;   Install our GDT		;
	;-------------------------------;

	xchg	bx,bx
	call	InstallGDT		; install our GDT

	;-------------------------------;
	;   Enable A20			;
	;-------------------------------;

	xchg	bx,bx
	call    EnquiryA20_KKbrd_Out
	xchg    bx,bx
	call	DisableA20_KKbrd_Out
	xchg	bx,bx
	call    EnquiryA20_KKbrd_Out
	xchg    bx,bx
	call	EnableA20_KKbrd_Out
	xchg    bx,bx
	call    EnquiryA20_KKbrd_Out ; call earlier ... seems down there you cause issues
	xchg    bx,bx
	
	;-------------------------------;
	;   Go into pmode		;
	;-------------------------------;

	cli				; clear interrupts
	xchg	bx,bx
	xchg	bx,bx
	mov	eax, cr0		; set bit 0 in cr0--enter pmode
	or	eax, 1
	mov	cr0, eax

	jmp	CODE_DESC:Stage3	; far jump to fix CS.

	xchg	bx,bx
	xchg	bx,bx
	xchg	bx,bx
	
	
	; Note: Do NOT re-enable interrupts! Doing so will triple fault!
	; We will fix this in Stage 3.

;******************************************************
;	ENTRY POINT FOR STAGE 3
;******************************************************

bits 32

Stage3:

	;-------------------------------;
	;   Set registers		;
	;-------------------------------;

	xchg	bx,bx
	xchg	bx,bx
	xchg	bx,bx
	xchg	bx,bx
	
	mov		ax, DATA_DESC		; set data segments to data selector (0x10)
	mov		ds, ax
	mov		ss, ax
	mov		es, ax
	mov		esp, 90000h		; stack begins from 90000h
	; call    EnquiryA20_KKbrd_Out ; physical address error ...
	xchg	bx,bx
	xchg	bx,bx
	xchg	bx,bx
	xchg	bx,bx
	xchg	bx,bx
	xchg	bx,bx
	
	cli
	hlt
