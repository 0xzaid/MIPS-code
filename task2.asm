# Author: Zaid
# Global variables: size, the_list, min_item, i, arrayPrompt,
#		    intPrompt, resultPrompt, newline
# A program that computes the minimum element in an array and prints it

	.data

size:			.word	0
the_list:		.word 	0
min_item:		.word 	0
i:				.word 	0

arrayPrompt:	.asciiz	"Array length: "
intPrompt:		.asciiz "Enter num: "
resultPrompt:	.asciiz "The minimum element in this list is "
newline:		.asciiz "\n"

	.text

	# size = int(input("Array length: "))
	addi $v0, $0, 4						# call code for print string
	la $a0, arrayPrompt
	syscall

	addi $v0, $0, 5						# call code for input integer
	syscall
	sw $v0, size						# size = input()

	# the_list = [None] * size
	lw $t0, size						# load size
	addi $t0, $0, 1						# size+1, for length
	sll $a0, $t0, 2						# (size+1)*4
	addi $v0, $0, 9						# allocating
	syscall
	sw $v0, the_list					# address of the_list in heap

	#set size as first array element
	lw $t0, size						# load size
	lw $t1, the_list					# load address of the_list
	sw $t0, ($t1)						# the_list.length = size

	#for i in range(len(the_list)):
loop:
	# i < size
	lw $t0, i
	lw $t1, size
	slt $t0, $t0, $t1					# if i < size continue
	beq $t0, $0, endloop				# not i<size go endloop

	# the_list[i] = int(input("Enter num: "))
	addi $v0, $0, 4						# call code for print string
	la $a0, intPrompt
	syscall
	addi $v0, $0, 5						# call code for input int
	syscall
	lw $t0, i
	sll $t0, $t0, 2						# 4i
	lw $t1, the_list					# load address of the_list in the heap
	add $t0, $t0, $t1					# address of i in the_list
	sw $v0, 4($t0)						# the_list[i] = input(), which contains input

	#if i == 0 or min_item > the_list[i]:
	lw $t1, i
	beq $t1, $0, ifResult				# if first condition is true, just go ifResult
										# if not, try second condition
	#min_item > the_list[i]:
	lw $t1, min_item					# load min_item
	lw $t0, i							# load i
	sll $t0, $t0, 2						# 4i
	lw $t2, the_list					# load address of the_list in the heap
	add $t0, $t0, $t2					# address of i in the_list
	lw $t2, 4($t0)						# load the_list[i]
	slt $t1, $t2, $t1					# if min_item > the_list[i] go to ifResult
	beq $t1, $0, endif					# else go endiff

ifResult:
	# min_item = the_list[i]
	lw $t0, i							# load i
	sll $t0, $t0, 2						# 4i
	lw $t1, the_list					# load address of the_list in the heap
	add $t0, $t0, $t1					# address of i in the_list
	lw $t1, 4($t0)						# load the_list[i]
	sw $t1, min_item					# min_item = the_list[i]

endif:
	# i++
	lw $t1, i
	addi $t1, $t1, 1
	sw $t1, i							# i = i + 1
	j loop

endloop:
	#print("The minimum element in this list is " + str(min_item))
	addi $v0, $0, 4
	la $a0, resultPrompt				# call code for print string
	syscall

	addi $v0, $0, 1						# call code for print integer
	lw $a0, min_item
	syscall

	addi $v0, $0, 4						# call code for print string
	la $a0, newline
	syscall

	addi $v0, $0, 10					# quit
	syscall
