/*
 * summ.S
 *
 *  Created on: Oct 23, 2023
 *      Author: reids
 *
 * This program computes the summation of (n^2 + n) from n=1 to a
 */

	.text                  // program section
	.global	main           // main
	.global	summ           // summ
	.arch armv8-a+fp+simd  // processor type
	.type main, %function  // main function
	.type summ, %function  // summ function

main:
	  MOV X27, SP          // copy stack pointer to X27 so we can operate on stack without exceptions
	  MOV X1, X20          // copy a into X1
	  BL summ              // call the function summ
	  MOV X21, X0          // copy the summation from X0 to X22
	
