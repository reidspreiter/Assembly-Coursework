/*
 * question1.S
 *
 *  Created on: Nov 6, 2023
 *      Author: Reid Spreiter
 *		  Info:	Finds index of first occurance of character in a string
 */

	.data                       	// data section
	.type	str, %object         	// defining object str1
	.size	str, 12              	// str size

str:
	.asciz	"Hello World\0"        	// char values as string

	.text                  	 	// program section
	.global main           	 	// main
	.global strchr         	 	// strchr
	.arch armv8-a+fp+simd  	 	// processor type
	.type main, %function     	// main function
	.type strchr, %function   	// strchr function

main:
	MOV X27, SP          	// copy the stack pointer to register X27 so that we can operate on the stack without any exceptions
	ADR X9, str          	// load base address of str into X9
	MOV X1, X9           	// copy the base address of str into register X1
	MOV W2, W20          	// copy the value of n into register X2
	BL strchr            	// call the function strchr
	MOV X21, X0          	// copy the sum from X0 to register X21
	B exit               	// exit the main

/* The function strchr for finding index of first occurance of character in string */

strchr:
	SUB X27, X27, #16    	// make space on the stack for two registers
	STUR X9,  [X27, #0]  	// push X9 onto the stack
	STUR X10, [X27, #8]  	// push X10 onto the stack
	MOV X9, XZR          	// set i = 0
loop: 	ADD X10, X9, X1      	// get base address of str[i]
	LDURB W10, [X10, #0] 	// load str[i] into W10
	CMP W10, W2		// compare str[i] with search character
	B.EQ yes             	// branch to yes if they are equal
	CBZ W10, no	  	// branch to no if /0
	ADD X9, X9, #1       	// i++
      	B loop               	// branch to loop
no:   	MOV X0, #-1      	// if not found, set return to -1
	B ret			// branch to ret
yes:  	MOV X0, X9           	// if found, set return to index
ret:  	LDUR X9,  [X27, #0]  	// pop x9 from the stack
	LDUR X10, [X27, #8]  	// pop x10 from the stack
      	ADD X27, X27, #16    	// restore the stack pointer
	BR X30               	// return back to caller

exit: NOP
