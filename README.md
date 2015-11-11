# Mac-Assembler-NASM

Simple console program written for Mac OS i386 architecture using NASM to display the contents of the registers.

## Notes

1. Must have either Xcode or gcc installed.
2. Must have either Xcode or gcc installed.
3. Must have either Xcode or gcc installed.

##Build		

```nasm -f macho -o macDump.o macDump.s && ld -o macDump macDump.o -arch i386 -lc -macosx_version_min 10.6 && ./macDump```

This code is a modified version of the code written by [Dr. George Grevera](http://people.sju.edu/~ggrevera/). Suggestions, comments and improvements are welcome and appreciated.
