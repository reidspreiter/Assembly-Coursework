/* Name:	Reid Spreiter
 * Date:	11/30/2023
 * Description:	Compute cosx^2 via sum of (-1)^n(x^(4n)/(2n)!) from n = 0 to a
 */

	.text				// program section
	.global	main			// main
	.arch armv8-a+fp+simd		// processor type
	.type	main, %function		// main function

main:
	FMOV D21, XZR			// initialize D21 with 0.0
	MOV X9, XZR			// set n = 0
loop:	CMP X9, X20			// compare n with a
	BGT exit			// branch to exit if n > a
	LSL X10, X9, #2			// get 4n
	FMOV D9, #1.0			// move 1 to D9
pow:	CMP X10, XZR			// compare 4n with 0
	BEQ epow			// if 0, branch out of powloop
	FMUL D9, D9, D20		// multiply D9 by x
	SUB X10, X10, #1		// decrement 4n
	B pow				// branch back to pow
epow:	LSL X10, X9, #1			// get 2n
	MOV X11, #1			// move 1 to X11
fac:	CMP X10, XZR			// compare 2n with 0
	BEQ efac			// if 0, branch out of facloop
	MUL X11, X11, X10		// multiply factorial
	SUB X10, X10, #1		// decrement 2n
	B fac				// branch back to fac
efac:	UCVTF D10, X11			// convert (2n)! to floating point val
	FDIV D9, D9, D10		// divide x^(4n)/(2n)!
	TST X9, #1			// test n with 1 to check if odd power
	BNE odd				// branch if odd
	FADD D21, D21, D9		// add D9 if (-1)^n evaluates to 1
	B inc				// branch to inc
odd:	FSUB D21, D21, D9		// sub D9 if (-1)^n evaluates to -1
inc:	ADD X9, X9, #1			// increment n
	B loop				// branch back to start of summation
exit:	NOP
