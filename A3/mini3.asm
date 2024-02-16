.data
msg1: .asciiz "\nPlease input an integer value greater than or equal to  0: "
errorMsg: .asciiz "The value you entered is less than zero. This program only works with values greater than or equal to zero."
inputMsg: .asciiz "Your input: "
factorialRes: .asciiz "\nThe factorial is: "
restartMsg: .asciiz "\n Would you like to do this again (Y/N): "

.text
.globl main
main:
    li $v0, 4            # print the string
    la $a0, msg1         # from the address linked to msg1 (So print msg1)
    syscall              # call function
    
    li $v0, 5            # read the integer
    syscall              # call function
    
    move $s0, $v0        # move the result in $v0 to $a0
    bltz $s0, displayErrorMsg # if $a0 is less than  0 then go to displayErrorMsg
    
    jal factorial        # jump & connect to the factorial function


    move $s2, $v1        # Move the result of the factorial calculation to $s0


    li $v0, 4            # print string
    la $a0, inputMsg     # the inputMsg
    syscall              # call function
    
    move $a0, $s0        # moving $s0 to $a0
    li $v0, 1            # prints the integer
    syscall              # calling function
       
    li $v0, 4            # print the string
    la $a0, factorialRes # specifically "The factorial is: " sentence    
    syscall              # calling function
    
    move $a0, $s2        # moving $v0 to $a0
    li $v0, 1            # print integer
    syscall              # call function


    li $v0, 4		# asking for retry
    la $a0, restartMsg	# print "Would you like to... "
    syscall
    
    li $v0, 12		# read a single char
    syscall
    
    li $t1, 'Y'
    bne $v0, $t1, exit	# if not 'Y', exit
    j main		# if 'Y' start over
    
    
displayErrorMsg:   
    li $v0, 4            # print the string
    la $a0, errorMsg     # from the address linked with errorMsg
    syscall              # call function
    
    li $v0, 10           # exit code
    syscall              # call function
  
exit: 
    li $v0, 10		# exit program
    syscall

.text
.globl factorial


# arg is $s0, return is $v1

factorial:
    addi $sp, $sp, -8   # allocating space for stack (the manual pushing method)
    sw $ra, 4($sp)      # saving return address on  stack
    sw $s0, 0($sp)      # saving value of input on stack

    # base case: if n == 0 or n == 1, return 1
    
    li $v1, 1           # return 1 if that's the case
    blez $s0, end_factorial # if n <= 0, returns 1

    # recursive case:  n*(n-1)
    
    addi $s0, $s0, -1   # n--;
    jal factorial       # recursive call


    # n * (returned factorial result)
    lw $s0, 0($sp)      # restoring n--;
    mul $v1, $s0, $v1   # n * factorial(n-1)

end_factorial:
    lw $ra, 4($sp)      # manually popping from the stack, what is on top of stack ...
    addi $sp, $sp, 8    # ... will be put back into $ra
    jr $ra              # takes me back to what was under jal factorial

    
