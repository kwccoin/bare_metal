; osdev6-stage2.asm

; osdev5 cannot work as you cannot just put a code to anywhere you like ... I guess

; mount this and copy like normal file need

; sudo mkdir -p /media/osdev6
; sudo mount -o loop /home/chichunng/Desktop/hgfs/2016-05-20c-mac.osdev/dng.pgm/osdev/osdev6.flp /media/osev6/
; ?sudo? cp osdev6-steage2.bin /media/floppy6/STAGE2.SYS

; sudo umount /media/floppy6 

; Note: Here, we are executed like a normal
; COM program, but we are still in Ring 0.
; We will use this loader to set up 32 bit
; mode and basic exception handling
 
; This loaded program will be our 32 bit Kernel.
 
; We do not have the limitation of 512 bytes here,
; so we can add anything we want here!
 
org 0x0		; offset to 0, we will set segments later
 
bits 16		; we are still in real mode
 
; we are loaded at linear address 0x10000
 
jmp main	; jump to main
 
;*************************************************;
;	Prints a string
;	DS=>SI: 0 terminated string
;************************************************;
 
Print:
			lodsb		; load next byte from string from SI to AL
			or	al, al	; Does AL=0?
			jz	PrintDone	; Yep, null terminator found-bail out
			mov	ah,	0eh	; Nope-Print the character
			int	10h
			jmp	Print	; Repeat until null terminator found
PrintDone:
			ret		; we are done, so return
 
;*************************************************;
;	Second Stage Loader Entry Point
;************************************************;
 
main:
			xchg bx,bx
			xchg bx,bx
			
			cli		; clear interrupts
			push	cs	; Insure DS=CS
			pop	ds
 
			mov	si, Msg
			call	Print
 
 			xchg bx,bx
			xchg bx,bx
			xchg bx,bx
			cli		; clear interrupts to prevent triple faults
			hlt		; hault the system
 
;*************************************************;
;	Data Section
;************************************************;
 
Msg	db	"Preparing to load operating system... staeg 2 ",13,10,0