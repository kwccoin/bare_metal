
;********************************************
;	Enable A20 address line
;
;	OS Development Series
;********************************************

%ifndef __A20_INC_67343546FDCC56AAB872_INCLUDED__
%define __A20_INC_67343546FDCC56AAB872_INCLUDED__

bits	16

;----------------------------------------------
; ch9 Method 3.1 Enables a20 line through keyboard controller
;----------------------------------------------

EnableA20_KKbrd:

	cli
	push	ax
	mov	al, 0xdd	; send enable a20 address line command to controller
	out	0x64, al
	pop	ax
	ret

DisableA20_KKbrd:

	cli
	push	ax
	mov	al, 0xff	; send disable a20 address line command to controller
	out	0x64, al
	pop	ax
	ret


;--------------------------------------------
; ch9 Method 3.2 Enables a20 line through output port
;
; most portable
;--------------------------------------------

; and     eax,00000010b  <-- read  a bit
; and     al, 11111101b  <-- clear a bit
; or      al, 00000010b  <-- set   a bit

EnquiryA20_KKbrd_Out:

	cli
	pusha

        call    wait_input
        mov     al,0xAD
        out     0x64,al		; disable keyboard
        call    wait_input

        mov     al,0xD0
        out     0x64,al		; tell controller to read output port
        call    wait_output

        in      al,0x60
        xchg    bx,bx
        xchg    bx,bx
        and     eax,00000010b		; should be in eax and zero
        							; use and ..., 00000010b to get a bit status
        							; cha9 m3.2 status bit bit 1 should be 1 if A20 is enabled
        xchg    bx,bx
        xchg    bx,bx
;        push    eax		; get output port data and store it
;        call    wait_input
;
;        mov     al,0xD1
;        out     0x64,al		; tell controller to write output port
;        call    wait_input
;
;        pop     eax
;        or      al,2		; set bit 1 (enable a20)          <- set use or (al,00000010b) 
;        out     0x60,al		; write out data back to the output port
;
;        call    wait_input
;        mov     al,0xAE		; enable keyboard
;        out     0x64,al
;
;        call    wait_input
	popa
        sti
        ret


DisableA20_KKbrd_Out:

	cli
	pusha

        call    wait_input
        mov     al,0xAD
        out     0x64,al		; disable keyboard
        call    wait_input

        mov     al,0xD0
        out     0x64,al		; tell controller to read output port
        call    wait_output

        in      al,0x60
        push    eax		; get output port data and store it
        call    wait_input

        mov     al,0xD1
        out     0x64,al		; tell controller to write output port
        call    wait_input

        pop     eax
        and     al,11111101b		; set bit 1 to 0 (disable a20) <-- clear use and (al,11111101b)
        out     0x60,al		; write out data back to the output port

        call    wait_input
        mov     al,0xAE		; enable keyboard
        out     0x64,al

        call    wait_input
	popa
        sti
        ret

	; wait for input buffer to be clear


EnableA20_KKbrd_Out:

	cli
	pusha

        call    wait_input
        mov     al,0xAD
        out     0x64,al		; disable keyboard
        call    wait_input

        mov     al,0xD0
        out     0x64,al		; tell controller to read output port
        call    wait_output

        in      al,0x60
        push    eax		; get output port data and store it
        call    wait_input

        mov     al,0xD1
        out     0x64,al		; tell controller to write output port
        call    wait_input

        pop     eax
        or      al,2		; set bit 1 (enable a20)
        out     0x60,al		; write out data back to the output port

        call    wait_input
        mov     al,0xAE		; enable keyboard
        out     0x64,al

        call    wait_input
	popa
        sti
        ret

	; wait for input buffer to be clear

wait_input:
        in      al,0x64
        test    al,2
        jnz     wait_input
        ret

	; wait for output buffer to be clear

wait_output:
        in      al,0x64
        test    al,1
        jz      wait_output
        ret

;--------------------------------------
; ch9 Method 2 - Enables a20 line through bios
; 
; only some Bochs support this
;
;--------------------------------------

EnableA20_Bios:
	pusha
	mov	ax, 0x2401
	int	0x15
	popa
	ret

DisableA20_Bios:
	pusha
	mov	ax, 0x2400
	int	0x15
	popa
	ret

CheckStatusA20_Bios:
	pusha
	mov	ax, 0x2402
	int	0x15
	popa
	ret

QuerySupportA20_Bios:
	pusha
	mov	ax, 0x2403
	int	0x15
	popa
	ret


;-------------------------------------------------
; ch9 Method 1 - Enables a20 line through system control port A
;   
;  MCA and EISA etc. 
;
;-------------------------------------------------

EnableA20_SysControlA:
	push	ax
	mov	al, 2      ; actually set bit 1 not bit 2 as in ch9 Method 1 said
	out	0x92, al
	pop	ax
	ret

%endif
