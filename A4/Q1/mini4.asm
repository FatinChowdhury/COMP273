.data
buffer
.text
# 0xffff0004
.globl GETCHAR
.globl PUTCHAR

GETCHAR:
   lui $a3, 0xffff0004		# base memory of address map
CkReady:
   lw $t1, 0($a3)		# read from receiver control reg
   andi $t1, $t1, 0x1		# extract ready bit
   beqz $t1, CkReady		# if $t1 == 1 then go to CkReady
   lw $v0, 4($a3)		# load char from keyboard
   jr $ra			# return address (go back to normal area)

PUTCHAR:
  lui $a3, 0xffff0004 		# base address of memory map
XReady:
  lw $t1, 8($a3)		# read from transmitter control reg
  andi $t1, $t1, 0x1 		# extract ready bit
  beqz $t1, XReady 		# if 1, then store char, else loop
  sw $a0, 12($a3) 		# send character to display
  jr $ra 			

