/*
 * strcat.S
 *
 *  Created on: Nov 6, 2023
 *      Author: Reid Spreiter
 *        Info: Appends source string to end of destination string
 */

	 .data						// data section
	 .type	strS, %object       // defining object strS - Source
	 .size	strS, 7             // strS size
	 .type	strD, %object       // defining object strD - Destination
	 .size	strD, 7             // strD size

strS:
	 .asciz	"burger\0"        	// char values as string

strD:
	 .asciz	"cheese\0"         	// char values as string

	 .text                		// program section
	 .global main           	// main
	 .global strcat        	 	// strcat
    .arch armv8-a+fp+simd  	// processor type
	 .type main, %function     	// main function
	 .type strcat, %function   	// strcat function

main:
	  MOV X27, SP          	// copy the stack pointer to register X27 so that we can operate on the stack without any exceptions
	  ADR X9, strD          // load base address of destination str
	  MOV X1, X9           	// copy the base address of destination str
	  ADR X9, strS			// load base address of source string
	  MOV X2, X9			// copy base address of source str
	  BL strcat            	// call the function strchr
	  ADR X9, strD         	// check if strcat was succesful, at this point, the entire concatenation will be visible from base address X9 in the memory
	  B exit               	// exit the main

/* The function strcat for appending a source string to a destination string */

strcat:
	  SUB X27, X27, #24    	// make space on the stack for 3 registers
	  STUR X9,  [X27, #0]  	// push X9 onto the stack
	  STUR X10, [X27, #8]  	// push X10 onto the stack
	  STUR X11, [X27, #16] 	// push X11 onto the stack
	  MOV X9, X1            // set i to base address of strD
	  MOV X10, X2          	// set j to base address of strS
loop: LDURB W11, [X9, #0]   // load strD[i] into W10
	  CBZ W11, loo2	       	// branch to loo2 if /0
	  ADD X9, X9, #1       	// i++
      B loop               	// branch to loop
loo2: LDURB W11, [X10, #0]  // load strS[j]
      STURB W11, [X9, #0]  	// store strS[j] at strD[i]
      CBZ W11, ret         	// return if last character appended was /0
      ADD X9, X9, #1       	// i++
      ADD X10, X10, #1     	// j++
      B loo2               	// branch back to loo2
ret:  LDUR X9,  [X27, #0]  	// pop X9 from the stack
	  LDUR X10, [X27, #8]  	// pop X10 from the stack
	  LDUR X11, [X27, #16] 	// pop X11 from the stack
      ADD X27, X27, #24    	// restore the stack pointer
	  BR X30               	// return back to caller

exit: NOP
