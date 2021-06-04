.data
	.align 0
	entrada: .asciiz "Número a ser lido: "
	stringLida: .space 64
	
.text

.globl main

main:
	# Imprime string para entrada de dados
	li $v0, 4
	la $a0, entrada
	syscall
	
	# Lê entrada como string
	li $v0, 8
	la $a0, stringLida
	li $a1, 64
	syscall
	
	# Fim de programa
	j fim 
	
fim:
	# Chamada de sistema de fim de programa
	li $v0, 10
	syscall