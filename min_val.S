/*
 * min_val.S
 *
 *  Created on: Oct 23, 2023
 *      Author: reids
 *
 * This program finds the minimum value of an array
 */

	.data                    // data section
	.type	v, %object         // defining object v
	.size	v, 5               // size 5 elements

v:                         // v array
	.xword	5, 2, 3, 1, 4    // elements of size 64-bit


	.text                    // program section
	.global	main             // main
	.global	min_val          // min_val
	.arch armv8-a+fp+simd    // processor type
	.type main, %function    // main function
	.type min_val, %function // min_val function

main:
	  MOV X27, SP            // copy stack pointer to X27 so we can operate on stack without exceptions
	  ADR X9, v              // load base address of array v into X9
	  MOV X1, X9             // copy the base address of array v into register X1
	  MOV X2, X20            // copy the value of n into register X2
	  BL min_val             // call the function min_val
	  MOV X21, X0            // copy the sum from X0 to register X21
	  B exit                 // exit main

/* The function min_val for finding smallest value of array */

min_val:
    SUB X27, X27, #16      // make space on the stack for two registers
	  STUR X9,  [X27, #0]    // push X9 onto the stack
	  STUR X10, [X27, #8]    // push X10 onto the stack
	  MOV X9, #1             // set i = 1 because we initialize min_val with 0
	  LDUR X0, [X1, #0]      // min_value = first elem in array
loop: 
    CMP X9, X2             // compare i with input n
	  BGE pop                // if i >= n then pop the stack
	  LSL X10, X9, #3        // multiply i by 8 to get the offset
	  ADD X10, X10, X1       // add to the base address of array v
	  LDUR X10, [X10, #0]    // load the value
	  CMP X10, X0		         // compare with current min_val
	  BGE else			         // if not smaller, branch to else
    MOV X0, X10            // if smaller, replace min_val
else: 
    ADD X9, X9, #1         // i++
    B loop                 // loop back
pop:  
    LDUR X9,  [X27, #0]    // pop X9 from the stack
	  LDUR X10, [X27, #8]    // pop X10 from the stack
    ADD X27, X27, #16      // restore the stack pointer
	  BR X30                 // return back to caller

exit: NOP
