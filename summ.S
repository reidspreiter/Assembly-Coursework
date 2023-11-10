/*
 * summ.S
 *
 *  Created on: Oct 23, 2023
 *      Author: reids
 *
 * This program computes the summation of (n^2 + n) from n=1 to a
 */

	.text               		// program section
	.global	main           		// main
	.global	summ           		// summ
	.arch armv8-a+fp+simd  		// processor type
	.type main, %function  		// main function
	.type summ, %function  		// summ function

main:
	MOV X27, SP          		// copy stack pointer to X27 so we can operate on stack without exceptions
	MOV X1, X20          		// copy a into X1
	BL summ              		// call the function summ
	MOV X21, X0          		// copy the summation from X0 to X22
	B exit               		// exit main

/* The function summ computing the summation */

summ:
	SUB X27, X27, #16    		// make space on the stack for two registers
	STUR X30,  [X27, #0] 		// push LR onto the stack
	STUR X1, [X27, #8]   		// push x2 onto the stack
      	CMP X1, #1           		// compare n with 1. n is initially a
	BGT L1               		// if n > 1 go to L1
	ADD X0, X0, #2       		// set return value
	ADD X27, X27, #16    		// pop stack, don't bother restoring values
	BR X30               		// return
L1:   	SUB X1, X1, #1	   		// subtract 1 from n
	BL summ          		// loop back to start of summation loop
pop:	LDUR X30,  [X27, #0] 		// pop LR from the stack
	LDUR X1, [X27, #8]   		// pop x2 from the stack
	ADD X27, X27, #16    		// restore the stack pointer
	MUL X2, X1, X1       		// get n^2
	ADD X2, X2, X1       		// add n
	ADD X0, X0, X2       		// add to the final summation
	BR X30               		// return

exit: NOP
	
