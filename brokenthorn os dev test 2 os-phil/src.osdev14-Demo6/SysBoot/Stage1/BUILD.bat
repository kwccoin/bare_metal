rem need to add 3 colons into Boot1.asm as warning

..\..\..\pgm.for.w7-32\NASM\nasm -f bin Boot1.asm -o Boot1.bin

pause

rem assume mount r/w by VFD I guess (as A i.e. f0)

rem also one can copy 200 instead this odd arrangement of copying to boot and under FAT12 as file

..\..\..\pgm.for.w7-32\PARTCOPY\PARTCOPY Boot1.bin 0 3 -f0 0 

rem not sure it seems not there but still running ... overriden as it does not add FAT12 dir entry 

..\..\..\pgm.for.w7-32\PARTCOPY\PARTCOPY Boot1.bin 3E 1C2 -f0 3E 

pause
