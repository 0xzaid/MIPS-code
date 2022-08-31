# Author: Zaid
# Global variables: minmimumPrompt, newline
# A program that returns the minimum integer from a given list

	.globl get_minimum
    .globl main

	.data

minimumPrompt:  .asciiz "The minimum element in this list is "
newline:	    .asciiz "\n"

	.text

main:
    # set $fp and make space for locals
    addi $fp, $sp, 0       	 	    # copy $sp into $fp
    addi $sp, $sp, -4      	 	    # $sp -4 , because one local var

    # my_list is at -4($fp)
   	# allocate array
   	addi $a0, $0, 16       	 	    # array size+1, size*4
	addi $v0, $0, 9
    syscall
   	sw $v0, -4($fp)

    #my_list = [2, 4, -1]
    addi $t0, $0, 3
    sw $t0, ($v0)           	    # size of array is 3

    addi $t0, $0, 2
    sw $t0, 4($v0)          	    # the_list[0] = 2
    addi $t0, $0, 4
    sw $t0, 8($v0)          	    # the_list[1] = 4
    addi $t0, $0, -1
    sw $t0, 12($v0)         	    # the_list[2] = -1

	#print(get_minimum(the_list)))
   	# 1 arg = 4 bytes
   	addi $sp $sp, -4

   	#arg = my_list
   	lw $t0, -4($fp)				    # load my_list
   	sw $t0, ($sp) 				    # arg 1 = my_list

   	jal get_minimum                 # link and go to get_minimum

 	#remove arguement by popping allocated space
   	addi $sp, $sp, 4

   	#store minimum int
   	sw $v0, -12($fp)

   	#print prompt
   	addi $v0, $0, 4                 # call code for print string
   	la $a0, minimumPrompt
    syscall

   	#print minmimum int             # call for print integer
   	addi $v0, $0, 1
   	lw $a0, -12($fp)
   	syscall

	#print newline
   	addi $v0, $0, 4                 # call code for print string
   	la $a0, newline
    syscall

   	#remove local variable, exit
   	addi $sp, $sp, 4
   	addi $v0, $0, 10                # quit
   	syscall


get_minimum:
    # saves value of $ra on stack
    addi $sp, $sp, -4
    sw $ra, ($sp)

    # saves value of $fp on stack
    addi $sp, $sp, -4
    sw $fp, ($sp)

   	# copy $sp to $fp
   	addi $fp, $sp, 0

    # allocate 3 local variables, 12 bytes
    # item is at -4($fp)
    # i is at -8($fp)
    # min_item is at -12($fp)
    addi $sp, $sp, -12

    # init local variables
    # min_item = my_list[0]
    lw $t0, 8($fp)          	    # load arg my_list
   	lw $t1, 4($t0)          	    # load first element of my_list
    sw $t1, -12($fp)        	    # min_item = my_list[0]

    # i = 1
    addi $t0, $0, 1
    sw $t0, -8($fp)         	    # i = 1

loop:
    lw $t0, -8($fp)         	    # load i

   	lw,$t1, 8($fp)				    # load my_list
	lw $t2, ($t1)				    # first element = size

    slt $t0, $t0, $t2       	    # is i < len?
    beq $t0, $0, endloop    	    # if not goto endloop

    # item = the_list[i]
   	lw $t0, 8($fp)                  # load the_list
    lw $t1, -8($fp)                 # load i
    lw $t2, -4($fp)			        # load item
   	sll $t1, $t1, 2                 # 4i
	add $t0, $t0, $t1               # load address of i in the_list
	lw $t2, 4($t0)                  # the_list[i]
	sw $t2, -4($fp)                 # item = the_list[i]

    # if min_item > item:
    lw $t0, -12($fp)        	    # load min_item
    lw $t1, -4($fp)         	    # load item
    slt $t0, $t1, $t0      	 	    # item < min_item goto increment_i
    beq $t0, $0, increment_i
    sw $t1, -12($fp)         	    # min_item = item

increment_i:
    lw $t0, -8($fp) 			    # i
	addi $t0, $t0, 1 			    # i+1
	sw $t0, -8($fp) 			    # i=i+1
    j loop

endloop:
	#return min in $v0
	lw $v0, -12($fp)

	#clear local variables off stack
	addi $sp, $sp, 12

    # restores saved $fp off stack
    lw $fp, ($sp)
    addi $sp, $sp, 4

    # restores saved $ra off stack
    lw $ra, ($sp)
    addi $sp, $sp, 4

	jr $ra

