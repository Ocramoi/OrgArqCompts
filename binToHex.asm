.data	
	.align 0
	msg_input: .asciiz "Digite um numero na base binaria:"
	print_decimal: .asciiz "Decimal convertido:"
	hexadec: .asciiz "\n0x"	
	buffer: .space 32	#can convert until 2,147,483,647 (max value for 4bytes int)
.text
.globl main

main:
	li $v0, 4		#print msg_input
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
	beq $t2, $zero, binToHex
	subi $t2, $t2, 48	#transform ascii into 0 or 1
	beq $t2, 0, isZero	#verify if it is 0
	beq $t2, 1, isOne	#verify if it is 1
	j binToHex
	
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
	
binToHex:
	srlv $t9, $t9, $t4	#fix decimal bytes
	
	move $t0, $t9		#move integer in $t9 to $t0
	li $t2, 15
	li $t1, 28
	
	la $a0, hexadec
	li $v0, 4 
	syscall 		#printf("0x")
	
startLoop:
	srlv $a0, $t0, $t1  	#parcial = numeroGrande / 2^i, sendo que i é sempre um multiplo de 4   
	and $a0, $a0, $t2	#parcial = parcial%16
	li $v0, 1 		#Para a syscall
	bge $a0, 10, printString#if(parcial> 9)goto printString 
returnFromPrintString:		#prints parcial as a number, depending on its value (<10 or >10)
	syscall			#imprime parcial como numero ou caractere dependendo se parcial é menor que 10 ou nao
	addi $t1, $t1, -4	#i = i-4;
	bne $t1, -4, startLoop	#}while(i >= 0)
	
	 j exit #return
	 
	#fix values from $a0 and $v0 to print in hex(10 = A, 11 = B, 12 = C, 13 = D, 14 = E, 15 = F)
printString:
	addi $a0, $a0, 55 #A é 65 no ASCII. $a0 ==10 é pra ser A, entao somamos 55 no valor de $a0 e imprimimos como caracter
	li $v0, 11 #print $v0 as a char, instead of a number
	j returnFromPrintString
	
exit:
	li $v0, 10		#exit program
	syscall			
	
