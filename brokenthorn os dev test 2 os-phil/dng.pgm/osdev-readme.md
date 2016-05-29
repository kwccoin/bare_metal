osdev-readme.md

about the rom

# The ROM BIOS controls what the PC does when it first powers on. 
# Normally, you can use a precompiled BIOS in the source or binary distribution 
# called BIOS-bochs-latest. 
# The default ROM BIOS is usually loaded starting at address 0xfffe0000, 
# and it is exactly 128k long.  <-- dennis: align with windows file size
# The legacy version of the Bochs BIOS is usually loaded starting at address 0xffff0000, 
# and it is exactly 64k long.   <-- dennis: align with windows file size
# You can use the environment variable $BXSHARE to specify the location of the BIOS. 
# The usage of external large BIOS images (up to 512k) at memory top is now supported, 
# but we still recommend to use the BIOS distributed with Bochs. 
# The start address is optional, since it can be calculated from image size.
# 
# note the size of 0xf0000 as in osdev3 is not used ... the size is different
#
# BIOS must end at the end of the first megabyte (0xFFFFF) in memory
# given 128 KB, the BIOS must start at : 0xFFFFF - 128 KB(10) / 20000 = 0xDFFFF but
#
# bochs start with ip = 0xf000:0xfff0 i.e. 0xffff0 
#                     -> jumpf 0xf000:e05b
# if you look at the memory it looks like it really is
#    0xE0000 (or 0xDFFFF + 1) start the romimage and up to 0xFFFFF
#    (under http://bochs.sourceforge.net/doc/docbook/user/rom-images.html
		  romimage: file=BIOS-bochs-latest, address=0xe0000)
	Its content is right (disassmble and see address and l.address panel)
		31 C0		xor ax,ax
		BF 1007		mov di,0x0710
		0000		add byte ptr ds:[bx+si],al
	
	and hexdump -x BIOS-bochs-latest | tail
	
	001ff00 e6ef 65e9 4df0 41f8 fef8 39e3 59e7 2ef8
	001ff10 d2e8 de2f f296 6ee6 53fe 53ff 00ff de00
	001ff20 00ef 0000 ...
	*
	001ff50 0000 cf00 00ba b804 2d8e cfef 0000 0000
	*
	001fff0 5bea 00e0 30f0 2f34 3831 312f 0035 0cfc
	0020000 
	
	same as disassmble 0xffffe (512 long)
	
	000ffffe (2) 0000			add byte ptr ds:[bx+si],al		# dummy 
	000ffff0 (5) ea5be000f0 	jumpf 0x0f000;e05b 				# note 5bea00e0 f0 ...
	000ffff5 (2) 3034			xor byte ptr ds:[si],dh ...
	
	and similarly
	
	and hexdump -x BIOS-bochs-latest | more
	
	00000 c031 10bf 0007 b900 0764 0000 f929 aaf3
	00010 c8be 0e31 bf00 0700 0000 0cb9 0007 2900
	
	000dfffc (2) ffff 			(invalid)
	000dfffe (2) ffff 			(invalid)
	000e0000 (2) 31c0 			xor ax,ax			# once again note c031 on file
	000e0002 (3) bf1007			mov di,0x0710		# in fact this is confusing as 
	000e0005 (2) 0000			dummy ...			# just read swap byte every time (swap byte...)
	000e0007 (3) B96407			mov cx,0x0764
	0000
	
cyliner calcalution
	sort of remember little book has one ... need to check
	

osdev3:

	vfd can create image but cannot actually partcopy as there is no A drive
	use dd as under makefile instead


