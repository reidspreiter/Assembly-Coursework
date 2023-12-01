/* Name:		Reid Spreiter
 * Date:		11/24/2023
 * Description:	Find median value of sorted array
 */

    .data						// data section
	.type	s, %object			// defining object s
	.size	s, 5				// single-precision values

s:                            	// s array
	.float 1.1, 2.3, 4.5, 4.7, 6.7

	.text						// program section
	.global	main				// main
	.arch armv8-a+fp+simd		// processor type
	.type	main, %function		// main function

main:
	MOV X27, SP					// copy stack pointer to X27
	ADR X19, s					// load label address of s into X19
	MOV X1, X19					// copy base address of array to X1
	MOV X2, X20					// copy array size to X2
	BL med_val					// call med_val
	FMOV S20, S0				// move result to S20
	B exit						// branch to exit

/* The function med_val to find median of a sorted array */

med_val:
	SUB X27, X27, #16			// make space on the stack for two registers
	STUR X9, [X27, #0]			// push X9 onto the stack
	STUR S9, [X27, #8]			// push S9 onto the stack
	LSR X9, X2, #1				// divide length by 2 to get midval if odd
	LSL X9, X9, #2				// multiply by 4
	ADD X9, X9, X1				// add to base address of array
	TST X2, #1					// tst size with #1 to check if even
	BNE odd						// branch if odd accordingly
	LDUR S0, [X9, #0]			// get 2nd midval if even
	SUB X9, X9, #4				// sub 2 to get index of 1st midval
	LDUR S9, [X9, #0]			// get 2nd midval if even
	FADD S0, S0, S9				// add 1st and 2nd midvals
	FMOV S9, #2.0				// insert 2.0 into S9
	FDIV S0, S0, S9				// divide by 2 to get average
	B ret						// branch to return
odd:  
	LDUR S0, [X9, #0]			// load val at median index
ret:  
	LDUR X9,  [X27, #0]			// pop X9 from the stack
	LDUR S9, [X27, #8]			// pop S9 from the stack
	ADD X27, X27, #16			// restore the stack pointer
	BR X30						// return back to caller
exit: 
	NOP
