rem seems to need to add : into Floppy16.inc 


..\..\..\NASM\nasm -f bin Stage2.asm -o KRNLDR.SYS

rem assume mount a by VFD
rem already stage 1 is in the root sector (with the file there just info)
rem need stage3 which is a PE file call .exe

copy KRNLDR.SYS  A:\KRNLDR.SYS


pause
