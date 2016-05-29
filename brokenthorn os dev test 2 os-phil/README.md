### bare metal programming and network towards a philosophy of some kind # brokenthorn

#### 1.1 Notes on Brokenthorn

    * explanation is clear.  
    * minor issues 
        * Some spelling mistakes.  Also, not sure about those bit 2 as 2 is bit 1 (count from bit 0)
        * quite dead in terms of development ... 
    * but to repeat, its explanation is best among others
    * I tried little book, mikeos, (Chinese) linux 0.11 and another 2 (?) plus OSDEV
    * OSDEV is good if you can cross-compile but here just barebone to only nasm essentially
    * a lot comes out if you google: write a simple os from scratch
    * One complimentary one is good from Dr Eike Ritter (https://www.cs.bham.ac.uk/~exr/)
        * --> Good to try this next: https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf
    * or other info like MIT etc.
    * may tie it a bit later but stop at OSDev11 (with a sample OSDev14) code for my own reference later


    * from OSDev1 to OSDev11, you can just use flat binary (COM, no ELF, PE etc.)
        * cygwin under wins
            * dd
            * make
            * nasm
        * win7-32
            * partcopy
            * dosbatch
            * vfd
            * nasm
    * i.e. up to 32 bit protection code
    * you may note I add also xchg bx,bx and magictoken in bochc; this helps a lot in debug and understand the flow
    * I think it would be easy to run under mac and ubuntu (given cygwin is so easy but ...)


    * use bochs and qemu would be a challenge
        *bochs
            * my batch assumed under windows bochs installed at D:\bochs-2.6.8
        * qemu
            * sorry still not working ... arm seems ok but not x86, to be done

    * brokenthorn is 16->32 bit, assembly and flat binary

    * no GRUB, self loader 


#### 1.1.1 helpful links

##### BrokenThorn OS Development

    - http://www.brokenthorn.com/Resources/OSDevIndex.html
    - http://www.brokenthorn.com/forums/index.php
    - (whilst you can go direct here; not suggested) http://www.brokenthorn.com/Resources/Demos/

##### (optional for me) VC++ 2015

    If you want to do after OSDEV 14, you can try to downloand their "free" express edition.  It seems to work at least for the OSDev14

    - https://www.google.com.hk/search?client=safari&rls=en&q=Microsoft+visual+studio+2005+express+edition+vc%2B%2B&ie=UTF-8&oe=UTF-8&gfe_rd=cr&ei=iClKV4PrG8rU8AfvjKfwBg

    or 

    - http://apdubey.blogspot.hk/2009/04/microsoft-visual-studio-2005-express.html

    Please note you need to do some patching:

    - https://www.microsoft.com/en-us/download/details.aspx?id=804

      * I guess you can just patch Visual C++ 2005 Express Edition SP1 - VS80sp1-KB926748-X86-INTL.exe




