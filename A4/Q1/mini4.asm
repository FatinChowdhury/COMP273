.text
# 0xffff0004
.globl GETCHAR

GETCHAR:
   lui $a3, 0xffff0004		# base memory of address map
CkReady:
   lw $t1, 0($a3)		# read from receiver control reg
   andi $t1, $t1, 0x1		# extract ready bit
   beqz $t1, CkReady		# if $t1 == 1 then go to CkReady
   lw $v0, 4($a3)		# load char from keyboard
   jr $ra			# return address (go back to normal area)

