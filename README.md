# Mac-Assembler-NASM
Simple assembler program for Mac OS using NASM

## Notes
1. Must have either Xcode or gcc installed.
2. Run Xcode once after install and agree to the Terms and Conditions
3. Must have NASM install

- Download NASM 2.11.06: http://www.nasm.us/pub/nasm/releasebuilds/2.11.06/
- Instructions: http://www.neuraladvance.com/compiling-and-installing-nasm-on-mac-os-x.html
- Manual: http://www.nasm.us/pub/nasm/releasebuilds/2.11.06/doc/nasmdoc.pdf

##Build		
```nasm -f macho -o macDump.o macDump.s && ld -o macDump macDump.o -arch i386 -lc -macosx_version_min 10.6 && ./macDump```

This code is a modified version of the code written by Dr. George Grevera. Suggestions, comments and improvements are welcome and appreciated.
