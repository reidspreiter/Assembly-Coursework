/*
 * strrev.S.S
 *
 *  Created on: Nov 9, 2023
 *      Author: Reid Spreiter
 *		  Info:	Reverses an input string
 */

	 .data                       	// data section
	 .type	str, %object         	// defining object str
	 .size	str, 10              	// str size

str:
	 .asciz	"DoodleBob\0"        	// char values as string

	 .text                  	 	// program section
	 .global main           	 	// main
	 .global strrev         	 	// strrev
	 .arch armv8-a+fp+simd  	 	// processor type
	 .type main, %function     	 	// main function
	 .type strrev, %function   	 	// strrev function

main:
	  MOV X27, SP          // copy the stack pointer to register X27 so that we can operate on the stack without any exceptions
	  ADR X9, str          // load base address of str into X9
	  MOV X1, X9           // copy the base address of str into register X1
	  BL strrev            // call the function strrev
	  B exit               // exit the main, X9 now stores reversed string

/* The function strrev for reversing a given input string */

strrev:
	  SUB X27, X27, #32    // make space on the stack for 4 registers
	  STUR X9,  [X27, #0]  // push X9 onto the stack
	  STUR X10, [X27, #8]  // push X10 onto the stack
	  STUR X11, [X27, #16] // push X11 onto the stack
	  STUR X12, [X27, #24] // push X12 onto the stack
	  MOV X9, X1           // set i = base addres
loop: LDURB W10, [X9, #0]  // load str[i] into W10
	  CBZ W10, rev	   	   // branch to rev if /0
	  ADD X9, X9, #1       // i++
      B loop               // branch to loop
rev:  SUB X9, X9, #1       // str[i-1] is address of last character before /0
      MOV X10, X1          // set j = base address
loo2: LDURB W11, [X10, #0] // get end of str
      LDURB W12, [X9, #0]  // get beginning of str
      STURB W11, [X9, #0]  // swap end with beginning
      STURB W12, [X10, #0] // swap beginning with end
      SUB X9, X9, #1       // sub 1 from end index i
      ADD X10, X10, #1     // add 1 to beginning index j
      CMP X10, X9		   // compare beginning and end indexes
      B.GT ret             // if beginning is greater than end, branch to ret
      B loo2               // otherwise, branch to loo2
ret:  LDUR X9,  [X27, #0]  // pop X9 from the stack
	  LDUR X10, [X27, #8]  // pop X10 from the stack
	  LDUR X11, [X27, #16] // pop X11 from the stack
	  LDUR X12, [X27, #24] // pop X12 from the stack
      ADD X27, X27, #16    // restore the stack pointer
	  BR X30               // return back to caller

exit: NOP
