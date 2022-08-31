# Author: Zaid
# Global variables: space, newline
# A program that uses bubble_sort algorithm which sorts a list in non-decreasing order
	.globl bubble_sort

	.data

space:		.asciiz " "
newline:	.asciiz "\n"

	.text
main:
	# copies $sp to $fp
    addi $fp, $sp, 0

	# allocates local variables on stack
	addi $sp, $sp, -8
	# the_list is at -4($fp)
	# i is at -8($fp)

	# allocate array
   	addi $a0, $0, 20       	 		# array size+1, size*4
	addi $v0, $0, 9					# call code for allocate
	syscall
	sw $v0, -4($fp)

	# my_list = [4, -2, 6, 7]
    addi $t0, $0, 4
    sw $t0, ($v0)           		#size of array is 4
    addi $t0, $0, 4
    sw $t0, 4($v0)          		# the_list[0] = 4
    addi $t0, $0, -2
    sw $t0, 8($v0)          		# the_list[1] = -2
    addi $t0, $0, 6
    sw $t0, 12($v0)         		# the_list[2] = 6
	addi $t0, $0, 7
    sw $t0, 16($v0)         		# the_list[3] = 7

	# bubble_sort(the_list)
	# 1 arg = 4 bytes
   	addi $sp $sp, -4

   	#arg = the_list
   	lw $t0, -4($fp)					# load the_list
   	sw $t0, ($sp) 					# arg 1 = the_list

   	jal bubble_sort

	#remove arguement by popping allocated space
   	addi $sp, $sp, 4

   	# for i in range(len(the_list)):
   	sw $0, -8($fp)					# i = 0

main_loop:
	lw $t0, -8($fp)         		# load i
   	lw,$t1, -4($fp)					# load my_list
	lw $t2, ($t1)					# load len
    slt $t0, $t0, $t2       		# if i < len then continue
    beq $t0, $0, end_main_loop    	# if not go to endloop

    # print(the_list[i], end='')
    lw $t0, -4($fp)					# load the_list
    lw $t1, -8($fp)         		# load i
   	sll $t1, $t1, 2					# 4i
	add $t0, $t0, $t1
	lw $t1, 4($t0)					# load the_list[i]
	add $a0, $0, $t1
    addi $v0, $0, 1					# call code for print int
    syscall
	# print(' ', end='')
    addi $v0, $0, 4
    la $a0, space
    syscall

    lw $t0, -8($fp) 				# i
	addi $t0, $t0, 1 				# i+1
	sw $t0, -8($fp) 				# i=i+1

    j main_loop

end_main_loop:

	#remove arguement by popping allocated space
   	addi $sp, $sp, 4

	#print newline
	addi $v0, $0, 4					# call code for print string
    la $a0, newline
    syscall

   	#remove local variable, exit
   	addi $sp, $sp, 8
   	addi $v0, $0, 10
   	syscall

bubble_sort:
	#def bubble_sort(the_list: List[int]) -> None:

	# saves value of $ra on stack
    addi $sp, $sp, -4
    sw $ra, ($sp)

    # saves value of $fp on stack
    addi $sp, $sp, -4
    sw $fp, ($sp)

   	# copy $sp to $fp
   	addi $fp, $sp 0

   	# allocate 5 local variables, 20 bytes
   	# n at -4($fp)
	# a at -8($fp)
	# i at -12($fp)
	# item at -16($fp)
	# item_to_right	at -20($fp)
	addi $sp, $sp, -20

	# n = len(the_list)
	lw $t0, 8($fp)          			# load arg the_list
   	lw $t1, ($t0)          				# load size from the_list
    sw $t1, -4($fp)         			# n = len(the_list)

    # for a in range(n-1):
    # a = 0
    sw $0, -8($fp)         				# a = 0
outer_loop:
	lw $t0, -8($fp)         			# load a
	lw $t1, -4($fp)						# load n
	addi $t1, $t1, -1					# n-1
    slt $t0, $t0, $t1       			# is a < n-1
    beq $t0, $0, end_outer_loop    		# if not goto end_outer_loop
	sw $0, -12($fp)         			# i = 0

inner_loop:
	#for i in range(n-1):
    lw $t0, -12($fp)         			# load i
	lw $t1, -4($fp)						# load n
	addi $t1, $t1, -1					# n-1

    slt $t0, $t0, $t1       			# is i < n-1
    beq $t0, $0, end_inner_loop   		# if not goto increment a

    # item = the_list[i]
    lw $t0, 8($fp)						# load the_list
    lw $t1, -12($fp)         			# load i
   	sll $t1, $t1, 2						# 4i
	add $t0, $t0, $t1					# load address of i in the_list
	lw $t2, 4($t0)						# the_list[i]
	sw $t2, -16($fp)					# item = the_list[i]

	# item_to_right = the_list[i+1]
	lw $t0, 8($fp)						# load the_list
    lw $t1, -12($fp)         			# load i
    addi $t1, $t1, 1					# i + 1
   	sll $t1, $t1, 2						# 4i
	add $t0, $t0, $t1					# load address of i in the_list
	lw $t2, 4($t0)						# the_list[i
	sw $t2, -20($fp)					# item_to_right = the_list[i+1]

	# if item > item_to_right:
	lw $t0, -16($fp)        			# load item
    lw $t1, -20($fp)         			# load item_to_right
    slt $t0, $t1, $t0      	 			# if item_to_right < item, goto increment_i
    beq $t0, $0, increment_i

    # the_list[i] = item_to_right
    lw $t0, -20($fp)         			# load item_to_right
    lw $t1, 8($fp)						# load the_list
    lw $t2, -12($fp)         			# load i
   	sll $t2, $t2, 2						# 4i
	add $t1, $t1, $t2					# load address of i in the_list
	sw $t0, 4($t1)						# the_list[i] = item_to_right

    # the_list[i+1] = item
    lw $t2, -16($fp)					# load item
    lw $t0, 8($fp)						# load the_list
    lw $t1, -12($fp)         			# load i
    addi $t1, $t1, 1					# i + 1
   	sll $t1, $t1, 2						# 4i
	add $t0, $t0, $t1		 			# load address of i in the_list
	sw $t2, 4($t0)						# the_list[i+1] = item

increment_i:

    lw $t0, -12($fp) 					# i
	addi $t0, $t0, 1 					# i+1
	sw $t0, -12($fp) 					# i=i+1
    j inner_loop

end_inner_loop:

	lw $t0, -8($fp) 					# a
	addi $t0, $t0, 1 					# a+1
	sw $t0, -8($fp) 					# a=a+1
    j outer_loop

end_outer_loop:
	#clear local variables off stack
	addi $sp, $sp, 20

    # restores saved $fp off stack
    lw $fp, ($sp)
    addi $sp, $sp, 4

    # restores saved $ra off stack
    lw $ra, ($sp)
    addi $sp, $sp, 4

	jr $ra
