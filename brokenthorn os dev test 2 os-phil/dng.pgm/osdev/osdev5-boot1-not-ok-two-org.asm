;*********************************************
;	Boot1.asm
;		- A Simple Bootloader
;
;	Operating Systems Development Tutorial
;*********************************************
 
bits	16							; We are still in 16 bit Real Mode

org		0x7c00						; We are loaded by BIOS at 0x7C00

start:          jmp loader					; jump over OEM block

;*************************************************;
;	OEM Parameter block
;*************************************************;

TIMES 0Bh-$+start DB 0

bpbBytesPerSector:  	DW 512
bpbSectorsPerCluster: 	DB 1
bpbReservedSectors: 	DW 1
bpbNumberOfFATs: 	    DB 2
bpbRootEntries: 	    DW 224
bpbTotalSectors: 	    DW 2880
bpbMedia: 	            DB 0xF0
bpbSectorsPerFAT: 	    DW 9
bpbSectorsPerTrack: 	DW 18
bpbHeadsPerCylinder: 	DW 2
bpbHiddenSectors: 	    DD 0
bpbTotalSectorsBig:     DD 0
bsDriveNumber: 	        DB 0
bsUnused: 	            DB 0
bsExtBootSignature: 	DB 0x29
bsSerialNumber:	        DD 0xa0a1a2a3
bsVolumeLabel: 	        DB "MOS FLOPPY "
bsFileSystem: 	        DB "FAT12   "

msg						db	"Welcome to My Operating System!", 0

;***************************************
;	Prints a string
;	DS=>SI: 0 terminated string
;***************************************

Print:
			lodsb
			or			al, al				; al=current character
			jz			PrintDone			; null terminator found
			mov			ah,	0eh			; get next character
			int			10h
			jmp			Print
PrintDone:
			ret


;*************************************************;
;	Bootloader Entry Point
;*************************************************;

loader:

	xchg 	bx, bx 
	mov 	eax, 4
	xchg 	bx, bx
	
	xor		bx, bx		; A faster method of clearing BX to 0
	mov		ah, 0x0e
	mov		al, 'A'
	xchg 	bx, bx
	int		0x10
	xor		bx, bx		; A faster method of clearing BX to 0
	mov		ah, 0x0e
	mov		al, 'A'
	xchg 	bx, bx
	int		0x12
	xchg 	bx, bx 		; ax got the memory size got 0x27f or 639 in decimal
						; only 64KB
	
; Error Fix 1 ------------------------------------------

	xor		ax, ax		; Setup segments to insure they are 0. Remember that
	mov		ds, ax		; we have ORG 0x7c00. This means all addresses are based
	mov		es, ax		; from 0x7c00:0. Because the data segments are within the same
						; code segment, null em.

	mov		si, msg
	xchg 	bx, bx
	call	Print
	xchg 	bx, bx

	
	cli					; Clear all Interrupts
	xchg bx, bx
	; hlt					; halt the system

;*************************************************;
;	Bootloader 2 Entry Point
;*************************************************;
 
loader2:
 
.Reset:
	xchg bx, bx
	mov		ah, 0					; reset floppy disk function
	mov		dl, 0					; drive 0 is floppy drive
	int		0x13					; call BIOS
	jc		.Reset					; If Carry Flag (CF) is set, there was an error. Try resetting again
 
	xchg bx, bx
	mov		ax, 0x1000				; we are going to read sector to into address 0x1000:0
	mov		es, ax
	xor		bx, bx
 
	mov		ah, 0x02				; read floppy sector function
	mov		al, 1					; read 1 sector
	mov		ch, 1					; we are reading the second sector past us, so its still on track 1
	mov		cl, 2					; sector to read (The second sector)
	mov		dh, 0					; head number
	mov		dl, 0					; drive number. Remember Drive 0 is floppy drive.
	int		0x13					; call BIOS - Read the sector
	
 
	xchg bx, bx
	jmp		0x1000:0x0				; jump to execute the sector!
 
 
times 510 - ($-$$) db 0						; We have to be 512 bytes. Clear the rest of the bytes with 0
 
dw 0xAA55							; Boot Signiture
 
; End of sector 1, beginning of sector 2 ---------------------------------
 
 
org 0x1000							; This sector is loaded at 0x1000:0 by the bootsector
 
xchg bx, bx
cli								; just halt the system
hlt
