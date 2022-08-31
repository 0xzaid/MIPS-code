# Author: Zaid
# Global variables: first, second, result, firstPrompt, secondPrompt,
#                      resultPrompt, newline
# A program that inputs 2 integers and returns a result based on which conditions the integers satisfy

	.data

first:		.word 0
second:		.word 0
result: 	.word 0

firstPrompt:	.asciiz "Enter first: "
secondPrompt:	.asciiz "Enter second: "
resultPrompt:	.asciiz "Result: "
newline:		.asciiz "\n"

    .text

	#first = int(input("Enter first: "))
	addi 	$v0, $0, 4					# call code for print string
	la 		$a0, firstPrompt
	syscall
	addi 	$v0, $0, 5					# call code for input integer
	syscall
	sw 		$v0, first					# first = input()

	#second = int(input("Enter second: "))
	addi 	$v0, $0, 4					# call code for print string
	la 		$a0, secondPrompt
	syscall
	addi 	$v0, $0, 5					# call code for input integer
	syscall
	sw 		$v0, second					# second = input()

if:
	#if first > 0 and second >= 0:
	lw $t0, first
	lw $t1, second
	slt $t2, $t0, $0					# if first <= 0
	slt $t3, $t1, $0					# if second < 0
	# AND
	or $t1, $t2, $t3					# if both conditions pass, do result
	bne $t1, $0, elif 					# else go to elif

	#result = second//first
	lw $t0, first
	lw $t1, second
	div $t1, $t0						# second//first
	mflo $t0
	sw $t0, result						# result = second//first
	j endif

elif:
	# elif first == second or first < second:
	lw $t0, first						# load first
	lw $t1, second						# load second
	bne $t0, $t1, elifResult			# if first==second, go elifResult, else try second cond

	# first < second
	lw $t0, first						# load first
	lw $t1, second						# load second
	slt $t0, $t0, $t1					# if first < second, do calculation
	beq $t0, $0, else					# otherwise, go to else

elifResult:
	# result = first * second
	lw $t0, first
	lw $t1, second
	mult $t0, $t1						# first*second
	mflo $t0
	sw $t0, result						# result = first*second
	j endif

else:
	# result = second * 2
	lw $t0, second						# no conditions valid, so else
	addi $t1, $0, 2
	mult $t0, $t1						# second*2
	mflo $t0							
	sw $t0, result						# result = second*2
	
endif:
	# print("Result: " + str(result))
	addi $v0, $0, 4			 			# call code for print string
	la $a0, resultPrompt
	syscall

	addi $v0, $0, 1						# call code for print int
	lw $a0, result
	syscall

	addi $v0, $0, 4						# call code for print string
	la $a0, newline
	syscall
	
	addi $v0, $0, 10					# quit
	syscall
