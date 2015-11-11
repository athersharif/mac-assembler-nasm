;======================================================================
;
; .title		Dump Program
;
; Original File Info:
;
; File:			macDump.s
; Author:		George J. Grevera, Ph.D.
; Date:			7-nov-2010
; Description:	This file contains a simple console program and includes a function
;   			that can be called to dump the contents of registers.
; Build:		Simply type the following to create an executable:
;				/Application/Xcode.app/Contents/Developer/usr/bin/gcc -m32 -o dump.exe dump.s
;				./dump.exe
;   			Or for a debug version:
;				/Application/Xcode.app/Contents/Developer/usr/bin/gcc -m32 -g -o dump.exe dump.s
;				gdb ./dump.exe
; Resource:		http://sourceware.org/binutils/docs-2.17/as/index.html
;
; ---------------------------------------------------------------------
;
; Modified File Info:
;
; File:			macDump.s
; Developer: 	Ather Sharif
; Date:			31-oct-2014
; Description:	Simple console program written for Mac OS i386 architecture using NASM
;				to display the contents of the registers.
; Build:		nasm -f macho -o macDump.o macDump.s && ld -o macDump macDump.o -arch i386 -lc -macosx_version_min 10.6 && ./macDump
; Notes:		Must have either Xcode or gcc installed. 
;				Run Xcode once after install and agree to the Terms and Conditions
;				Must have NASM install
;				(Download NASM 2.11.06: http://www.nasm.us/pub/nasm/releasebuilds/2.11.06/)
;				(Instructions: http://www.neuraladvance.com/compiling-and-installing-nasm-on-mac-os-x.html)
;				(Manual: http://www.nasm.us/pub/nasm/releasebuilds/2.11.06/doc/nasmdoc.pdf)
;
;======================================================================

																; (insert symbol definitions here)
extern 		_printf
extern 		_exit
extern 		_getchar

global 		start

			CR 		equ 	13									; carriage return or '\r'
			LF 		equ		10									; linefeed or '\n'

section 	.data												; (insert variables definitions here)

			prompt:		db		"<press any key to exit>", 0	; user prompt
																; (some of the) eflags bits:
																; ID-bit 21, OF-bit 11, SF-bit 7, ZF-bit 6, AF-bit 4, CF-bit 0
			CF			equ		0x001							; carry flag bit
			ZF			equ		0x040							; zero flag bit
			SF			equ		0x080							; sign flag bit
			OF			equ		0x800							; overflow flag bit

			mEax:		db		"eax", 0						; string caption for eax
			mEbx:		db		"ebx", 0						; string caption for ebx
			mEcx:		db		"ecx", 0						; string caption for ecx
			mEdx:		db		"edx", 0						; string caption for edx

			mEsp:		db		"esp", 0						; string caption for esp
			mEbp:		db		"ebp", 0						; string caption for ebp
			mEsi:		db		"esi", 0						; string caption for esi
			mEdi:		db		"edi", 0						; string caption for edi
			mEip:		db		"eip", 0						; string caption for eip

			mEflags:	db		"eflags", 0						; string caption for eflags

			mCF0:		db		"CF:0 ", 0						; string caption for CF when it is 0
			mCF1:		db		"CF:1 ", 0						; string caption for CF when it is 1
			mZF0:		db		"ZF:0 ", 0						; string caption for ZF when it is 0
			mZF1:		db		"ZF:1 ", 0						; string caption for ZF when it is 1
			mSF0:		db		"SF:0 ", 0						; string caption for SF when it is 0
			mSF1:		db		"SF:1 ", 0						; string caption for SF when it is 1
			mOF0:		db		"OF:0 ", 0						; string caption for OF when it is 0
			mOF1:		db		"OF:1 ", 0						; string caption for OF when it is 1

			A:			equ 	1 								; A = 1 (Dec)
			B:			equ 	12Q 							; B = 12 (Oct)
			X:			dd 		0xA1, 0 						; X = A1 (Hex)
			Y:			dd 		11001001B, 0 					; Y = 11001001 (Bin)
			Ystr: 		db 		"11001001", 0 					; string value of Binary Y
			sum: 		dd 		0 								; sum of A, B, X, Y

;----------------------------------------------------------------------

section		.text												; (insert executable instructions here)

start:															; program execution begins here
			mov		eax, 1										; assign the value 1 to EAX
			mov		ebx, 2										; assign the value 2 to EBX
			mov		ecx, 3										; assign the value 3 to ECX
			mov		edx, 4										; assign the value 4 to EDX
			mov		esi, 5										; assign the value 5 to ESI
			mov		edi, 6										; assign the value 6 to EDI
			add		eax, 1										; add the value 1 to EAX

			call	dump										; show contents of regs

			mov     ebp, esp 									; copy the contents of stack pointer to base pointer
    		and     esp, 0xFFFFFFF0 							; aligning the stack pointer on 16 bytes

    		mov     dword[ esp ], prompt 						; copy user prompt to stack
			call 	_printf 									; output user prompt
			call 	_getchar 									; get character from console

			mov 	dword[ esp ], 0 							; empty the contents of stack pointer
			call 	_exit 										; exit program

;-----------------------------------------------------------------------

																; (insert additional procedures/functions here)
nl:			db		CR, LF, 0 									; string value for '\r\n'
																; this macro outputs a newline (CR,LF)
	%macro	newline 0 											; begin macro

			mov     ebp, esp 									; copy the contents of stack pointer to base pointer
    		and     esp, 0xFFFFFFF0 							; aligning the stack pointer on 16 bytes

    		mov     dword[ esp ], nl 	 						; copy nl to stack
			call 	_printf 									; output nl

			mov 	esp, ebp 									; restore the contents of stack pointer

	%endmacro													; end macro

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

																; this macro outputs a given variable (mEax, ..)
	%macro	print 1 											; begin macro

			mov     ebp, esp 									; copy the contents of stack pointer to base pointer
    		and     esp, 0xFFFFFFF0 							; aligning the stack pointer on 16 bytes

    		mov     dword[ esp ], %1 							; copy value to stack
			call 	_printf 									; output argument

			mov 	esp, ebp 									; restore the contents of stack pointer

	%endmacro	 												; end macro

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

buff:		db		"%s: %08x", 10, 0							; format to output values of registers
																; this macro outputs the contents of registers (eax, ..)
	%macro	show 2 												; begin macro

			mov     ebp, esp 									; copy the contents of stack pointer to base pointer
    		and     esp, 0xFFFFFFF0 							; aligning the stack pointer on 16 bytes

			mov     dword[ esp ], buff 							; copy format to stack
			mov     dword[ esp + 4 ], %1 						; copy first value to stack
			mov     dword[ esp + 8 ], %2						; copy second value to stack
			call 	_printf 									; output registers

			mov 	esp, ebp 									; restore the contents of stack pointer

	%endmacro 													; end macro

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

resfmt:		dd 		"Result=> Hex:%x", 0 						; format to output result
																; this macro outputs the result of addition
	%macro showResult 1 										; begin macro

			mov     ebp, esp 									; copy the contents of stack pointer to base pointer
    		and     esp, 0xFFFFFFF0 							; aligning the stack pointer on 16 bytes

			mov     dword[ esp ], resfmt 						; copy format to stack
			mov 	ebx, [%1] 									; copy result to ebx
			mov     dword[ esp + 4 ], ebx 						; result in hex
			call 	_printf 									; output result

			mov 	esp, ebp 									; restore the contents of stack pointer

	%endmacro 													; end macro

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

varfmt:		dd 		"Variables=> A:%d, B:%o, X:%X, Y:%s", 0 	; format to output the variables
																; this macro outputs the variables A, B, X, Y
	%macro showVariables 0 										; begin macro

			mov     ebp, esp 									; copy the contents of stack pointer to base pointer
    		and     esp, 0xFFFFFFF0 							; aligning the stack pointer on 16 bytes

			mov     dword[ esp ], varfmt 						; output format
			mov     dword[ esp + 4 ], A 						; push variable A to stack
			mov     dword[ esp + 8 ], B 						; push variable B to stack
			mov 	ebx, [X]									; copy X to ebx
			mov     dword[ esp + 12 ], ebx 						; push variable X to stack
			mov     dword[ esp + 16 ], Ystr						; push variable Y to stack
			call 	_printf 									; output variables

			mov 	esp, ebp 									; restore the contents of stack pointer

	%endmacro 													; end macro

;-----------------------------------------------------------------------

																; this function dumps the contents of the registers to the console.
																; all of the callers registers are preserved.
dump:
			pushf												; save eflags
			pusha												; save registers (order is: eax, ecx, edx, ebx,
																; esp, ebp, esi, and edi)
			newline												; output empty line
																; output registers
			show		mEax, eax 								; output eax
			show		mEbx, ebx								; output ebx
			show		mEcx, ecx								; output ecx
			show		mEdx, edx								; output edx
			newline												; output empty line

			show		mEsp, esp								; output esp
			show		mEbp, ebp								; output ebp
			show		mEsi, esi								; output esi
			show		mEdi, edi								; output edi

			call 		getNextInstr 							; jump to getNextInstr
			getNextInstr: 										; to get the eip by calling an instruction
						pop 	eax 							; copy the contents of eip in eax

			show		mEip, eax								; output addr of next instruction: eip
			newline												; output empty line

			lahf												; store flags in ah
			movzx 		ecx, ah 								; convert ah to ecx
			show		mEflags, ecx							; output eflags
			newline												; output empty line

			showVariables
			newline												; output empty line
			newline 											; output empty line

			mov 		eax, A 									; copy A into eax
			add 		eax, B 									; add B to eax
			add 		eax, [X] 								; add X to eax
			add 		eax, [Y] 								; add Y to eax
			mov 		[sum], eax 								; copy eax to sum
			showResult 	sum 									; output sum
			newline 											; output empty line
			newline 											; output empty line
																; C flag
			mov			ebx, esp								; fetch contents of saved eflags
			test		ebx, CF									; carry set?
			jz			cf0										; jump if 0 and call cf0
			print		mCF1 									; output "CF = 1" if CF is 1
			jmp			Con1 									; jump to Con1

;-----------------------------------------------------------------------

cf0:
			print		mCF0 									; output "CF = 0"

;-----------------------------------------------------------------------

Con1:															; Z flag
			mov			ebx, esp								; fetch contents of saved eflags
																; might have been changed due to sys call
			test		ebx, ZF 								; carry set?
			jz			zf0 									; jump if 0 and call zf0
			print		mZF1 									; output "ZF = 1" if ZF is 1
			jmp			Con2 									; jump to Con2

;-----------------------------------------------------------------------

zf0:
			print		mZF0 									; output "ZF = 0"

;-----------------------------------------------------------------------

Con2:															; S flag
			mov			ebx, esp								; fetch contents of saved eflags
																; might have been changed due to sys call
			test		ebx, SF 								; carry set?
			jz			sf0 									; jump if 0 and call sf0
			print		mSF1 									; output "SF = 1" if SF is 1
			jmp			Con3 									; jump to Con3

;-----------------------------------------------------------------------

sf0:
			print		mSF0 									; output "SF = 0"

;-----------------------------------------------------------------------

Con3:															; O flag
			mov			ebx, esp 								; fetch contents of saved eflags
																; might have been changed due to sys call
			test		ebx, OF 								; carry set?
			jz			of0 									; jump if 0 and call of0
			print		mOF1 									; output "OF = 1" if 0F is 1
			jmp			Con4 									; jump to Con4

;-----------------------------------------------------------------------

of0:
			print		mOF0 									; output "0F = 0"

;-----------------------------------------------------------------------

Con4:
			newline												; output empty line
			newline												; output empty line
			popa												; restore pushed registers
			popf												; restore eflags
			ret													; return to caller

;======================================================================
