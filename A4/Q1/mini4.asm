.data
firstName: .space 100
lastName: .space 100
buffer: .space 100
prompt1:   .asciiz "First name: "
prompt2:   .asciiz "Last name: "
output:    .asciiz "\nYou entered: "
comma:     .asciiz ", "
.text
.globl main
main:
     # ask for 1st name
    la $a0, prompt1
    jal puts              			# puts is for printing string
    
    # read 1st name
    la $a1, firstName     			# firstName: buffer to store first name
read_first_name:
    jal getChar           			# getChar to read char
    sb $v0, 0($a1)        			# store char byte into $v0
    beqz $v0, end_first_name 			# if we read the \0, end loop
    addiu $a1, $a1, 1     			# buffer pointer ++
    j read_first_name     			# loop back to read next char
end_first_name:
    
    # ask for last name
    la $a0, prompt2
    jal puts              			# prints
    
    # read last name
    la $a1, lastName      			# lastName: buffer to store last name
read_last_name:
    jal getChar           			# read char -> $v0
    sb $v0, 0($a1)        			# store char byte in buffer
    beqz $v0, end_last_name 			# if we read \0, end the loop
    addiu $a1, $a1, 1     			# buffer pointer ++
    j read_last_name      			# loop (read next char)
end_last_name:

    # display the output
    la $a0, output
    jal puts              			# print "You entered: "
    
    la $a0, lastName
    jal puts             			# print the last name
    
    la $a0, comma
    jal puts              			# print ", "
    
    
    la $a0, firstName				# print first name
    jal puts              			
    
    

    li $v0, 10            			# exit program
    syscall               			

getChar:
   lui $a3, 0xffff				# base memory of address map

CkReady:
   lw $t1, 0($a3)				# read from receiver control reg
   andi $t1, $t1, 0x1				# extract ready bit
   beqz $t1, CkReady				# if $t1 == 1 then go to CkReady
   lw $v0, 4($a3)				# load char from keyboard
   jr $ra					# return address (go back to normal area)

putChar:
  lui $a3, 0xffff 				# base address of memory map

XReady:
   lw $t1, 8($a3)				# read from transmitter control reg
   andi $t1, $t1, 0x1 				# extract ready bit
   beqz $t1, XReady 				# if 1, then store char, else loop
   sw $a0, 12($a3) 				# send character to display
   jr $ra 			


gets:

    move $t0, $a0				# initializing buffer pointer and char count
    move $t1, $zero


    readChar:					# read char till we cant
    jal getChar					# goes to getChar
    beq $v0,  10, endReading 			# reach \n, end reading
    beq $t1, $a1, endReading 			# limit reached, end reading
    sb $v0,  0($t0) 				# store char in buffer
    addiu $t0, $t0,  1 				# buffer pointer++
    addiu $t1, $t1,  1 				# char count++
    j readChar	


    endReading:					# "\0"- ing the string
    sb $zero,  0($t0)


    move $v0, $t1				# return # char read
    jr $ra


puts:

    move $t0, $a0				# buffer pointer initialized


    writeChar:
    lb $a0,  0($t0) 				# load char from buffer
    beqz $a0, endWrite 				# if \n, end writing
    jal putChar					# jump to putChar
    addiu $t0, $t0,  1 				# buffer pointer++
    j writeChar					# jump to writeChar
	

    endWrite:				
    move $v0, $t1				# returning $# char written
    jr $ra
