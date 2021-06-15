.data	
	.align 0
	msg_input: .asciiz "Digite um numero na base binaria:"
	print_decimal: .asciiz "Decimal convertido:"
	buffer: .space 32	#can convert until 2,147,483,647 (max value for 4bytes int)
.text
.globl main

main:
	li $v0, 4		#print string
	la $a0, msg_input	#load address of msg_input
	syscall			#call for I/O
	
readInput:			#allocates memory and reads string input 
	la $a0, buffer		
	li $a1, 32
	li $v0, 8		#read input string
	syscall 		#call for I/O
		
convertToInteger:
	li $t5, 1		#used for exponential
	la $t3, buffer
	move $a0, $t3	
	li $t4, 32		#counter = 32
	li $t9, 0		#number in decimal starts in 0
		
convertByte: 

	lb $t2, ($t3)		#loads first byte of string
	subi $t2, $t2, 48	#transform ascii into 0 or 1
	beq $t2, 0, isZero	#verify if it is 0
	beq $t2, 1, isOne	#verify if it is 1
	j printDecimal
	
isZero:
	addi $t3, $t3, 1	#byte offset++
	subi $t4, $t4, 1	#counter--
	j convertByte
	
isOne:				#does a simple exponential operation
				# 1 << counter = 2^counter
	addi $t3, $t3, 1	#byte offset++
	subi $t4, $t4, 1	#counter--
	sllv $t6, $t5, $t4
	add $t9, $t9, $t6	#adds result of exponential to $t9
	j convertByte
	
printDecimal:
	srlv $t9, $t9, $t4	
				#shifts $t4 << counter so it can fix byte positions
				#example: if we convert (11)_2 we get 11000000000...
				#so for fixing it, we can shift it to ...00000000000011 so we get (3)_10
	
	la $a0, print_decimal	#prints a output message
	li $v0, 4
	syscall
	
	move $a0, $t9		#actual converted decimal value
	li $v0, 1
	syscall
	j exit
	
	exit:
	li $v0, 10		#exit program
	syscall			
	
