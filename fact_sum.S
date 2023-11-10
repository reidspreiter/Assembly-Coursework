/*
 * fact_sum.S
 *
 *  Created on: Oct 23, 2023
 *      Author: reids
 *
 * This program computes the sum of (n+b)! from n=0 to a
 */

	.text                    // program section
	.global	main           // main
	.global	fact_sum            // fact_sum
	.arch armv8-a+fp+simd  // processor type
	.type main, %function  // main function
	.type fact_sum, %function   // fact_sum function

main:
	  MOV X27, SP          // copy stack pointer to X27 so we can operate on stack without exceptions
	  MOV X1, X20          // copy a into X1
	  MOV X2, X21          // copy b into X2
	  BL fact_sum          // call the function fact_sum
	  MOV X22, X0          // copy the summation from X0 to X22
	  B exit               // exit main

/* The function fact_sum computing the factorial summation */

fact_sum:
      SUB X27, X27, #24    // make space on the stack for three registers
	  STUR X9,  [X27, #0]  // push x9 onto the stack
	  STUR X10, [X27, #8]  // push x10 onto the stack
	  STUR X11, [X27, #16] // push x11 onto the stack
	  MOV X9, XZR          // set n = 0
	  MOV X0, XZR   	   // initialize final summation
loop: CMP X9, X1           // compare n with a
	  BGT pop              // if n > a then pop the stack
	  ADD X10, X9, X2	   // add n+b
      ADD X11, X10, XZR    // move n+b to start computing the factorial
lfac: SUB X10, X10, #1     // sub 1
      CMP X10, #1		   // if X10 < 1
      BLT sum			   // jump to sum because factorial calculation is done
	  MUL X11, X10, X11    // multiply into factorial computation
	  B lfac               // loop back to factorial loop start
sum:  ADD X0, X0, X11      // add new factorial to final summation
      ADD X9, X9, #1       // n++
      B loop               // loop back to start of summation loop
pop:  LDUR X9,  [X27, #0]  // pop x9 from the stack
	  LDUR X10, [X27, #8]  // pop x10 from the stack
	  LDUR X11, [X27, #16] // pop x11 from the stack
      ADD X27, X27, #24    // restore the stack pointer
	  BR X30               // return back to caller

exit: NOP
