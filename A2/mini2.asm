.data
buffer: .space 31  # Allocate 31 bytes (30 for input + 1 for null-terminator)
buffer2: .space 31 # Allocate 31 bytes for the shifted string
msg1: .asciiz "Input a string 30 characters or less: "
msg2: .asciiz "Input an integer greater than 0: "
errorMsg1: .asciiz "No input. Run again."
errorMsg2: .asciiz "Wrong input. Run again."
shiftedMsg: .asciiz "Shifted string = ["
closeBracket: .asciiz "]"

.text			# instructions
.globl main		
main:
    	# print msg1
    	li $v0, 4		# asking system to print string
    	la $a0, msg1	# its address
    	syscall

    	# read msg1
    	li $v0, 8		# asking system to read string
    	la $a0, buffer	
    	li $a1, 31		# the space
    	syscall

    	# if nothing was inputted
    	lb $t0, buffer 		# load 1st byte of buffer
    	beqz $t0, errorNoInput	# if 1st byte == 0 then goto errorNoInput
    	
    	# errorNoInput to be defined after main:

    	# print msg2
    	li $v0, 4		
    	la $a0, msg2
    	syscall

    	# read int
    	li $v0, 5
    	syscall

    	# if $v0 >= 0, goto errorWrongInput
    	blez $v0, errorWrongInput
    	    	
	# errorWrongInput to be defined after main:

   	 # Store number in $t1
    	move $t1, $v0

    	# Shift characters in buffer and store in buffer2
    	la $a0, buffer    # load buffer's address
    	la $a1, buffer2   # load buffer2's address
    	li $t2, 0         # Index for buffer2

    	# Calculate string length
    	la $t3, buffer
    	li $t6, 0
    	calc_length:
        	lb $t5, 0($t3)
        	beqz $t5, end_calc_length
        	addiu $t3, $t3, 1
        	addiu $t6, $t6, 1
        	j calc_length
    	end_calc_length:

    	# Adjust shift amount
    	subu $t1, $t1, $t6
    	bgez $t1, end_adjust
    	add $t1, $t1, $t6
    	rem $t1, $t1, $t6
    	end_adjust:

    	# Shift characters in buffer and store in buffer2
    	la $a0, buffer
    	la $a1, buffer2
    	addu $a0, $a0, $t1
    	shift_loop:
        	lb $t3, 0($a0)
        	beqz $t3, end_shift_loop
        	sb $t3, 0($a1)
        	addiu $a0, $a0, 1
        	addiu $a1, $a1, 1
        	j shift_loop
    	end_shift_loop:
        	la $a0, buffer
        	lb $t3, 0($a0)
        	beqz $t3, display
        	sb $t3, 0($a1)
        	addiu $a0, $a0, 1

display:
    	# Display shifted string message
    	li $v0, 4
    	la $a0, shiftedMsg
    	syscall

    	# Display shifted string
    	la $a0, buffer2   # Load address of buffer2
	li $v0, 4
    	syscall

    	# Display closing bracket
    	li $v0, 4
    	la $a0, closeBracket
    	syscall

   	j exit

errorNoInput:
    	# Display error message for no input
    	li $v0, 4
    	la $a0, errorMsg1
    	syscall
    	j exit

errorWrongInput:
    	# Display error message for wrong number input
    	li $v0, 4
    	la $a0, errorMsg2
    	syscall
    	j exit

exit:
    	li $v0, 10 # Exit system call
    	syscall
