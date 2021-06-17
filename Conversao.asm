.data
	.align 0
	inicioPrompt: .asciiz "#############################\n#        Bem vinde!         #\n#  Para iniciar o programa  #\n#       digite ENTER        #\n#############################\n"
	baseEntrada: .asciiz "Base do número a ser lido [2, 10, 16]: "
	baseSaida: .asciiz "Base de saída [2, 10, 16]: "
	baseIgual: .asciiz "Base de saída não pode ser a mesma de entrada!\n"
	erroBase: .asciiz "Valor inválido!\n"
	valorEntrada2: .asciiz "Valor binário a ser lido: "
	valorEntrada10: .asciiz "Valor decimal a ser lido: "
	valorEntrada16: .asciiz "Valor hexa a ser lido [para letras, utilize minúsculas]: "
	debug: .asciiz ":::::: "
	quebraDeLinha: .asciiz "\n"
	promptConvertido: .asciiz "Valor convertido: "
	stringLida: .space 64
	
.text

.globl main

## Funções base de programa ##

# Função de entrada do programa
main:
	# Imprime string para entrada de dados
	li $v0, 4
	la $a0, inicioPrompt
	syscall
	
	# Lê string (idealmente nula)
	li $v0, 8
	syscall
	
	# Prompt de entrada de base
	li $v0, 4
	la $a0, baseEntrada
	syscall
	
	# Lê base como inteiro
	li $v0, 5
	syscall
	
	# Confere entrada
	beq $v0, 2, entradaBin
	beq $v0, 10, entradaDec
	beq $v0, 16, entradaHex
	
	# Caso base digitada não válida
	li $v0, 4
	la $a0, erroBase
	syscall
	
	# Fim de programa
	j fim

# Caso um valor digitado seja inválido
numeroInvalido:
	li $v0, 4
	la $a0, erroBase
	syscall
	
	j fim
	
# Lê base para saída, conferindo se base inválida (igual a de entrada) em $t7
promptSaida:
	li $v0, 4
	la $a0, baseSaida
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, $t7, confBaseIgual
	jr $ra
	
	#  Caso base igual a de entrada
	confBaseIgual:
		# Mensagem de erro
		li $v0, 4
		la $a0, baseIgual
		syscall
		
		# Finaliza program
		j fim

converteValor:
	# Se não for carater de número
	bgt $t5, 58, ehLetra
	# Menor que '0'
	ble $t5, 48, numeroInvalido
	
	addi $t5, $t5, -48
	j endConvVal
	
	ehLetraConv:
		ble $t5, 96 , numeroInvalido 	# Checa se é letra realmente
		bgt $t5, 102, numeroInvalido	# Checa se as letras são a,b,c,d,e,f
		addi $t5, $t5, -87
		
	endConvVal:
		jr $ra

# Fim de programa
fim:
	# Chamada de sistema de fim de programa
	li $v0, 10
	syscall

entradaBin:
	# Imprime string para entrada de dados
	li $v0, 4
	la $a0, valorEntrada2
	syscall
	
	# Lê entrada como string
	li $v0, 8
	la $a0, stringLida
	li $a1, 64
	syscall
	
	j fim

entradaDec:
	# Imprime string para entrada de dados
	li $v0, 4
	la $a0, valorEntrada10
	syscall
	
	j fim
	
## Entrada Hexa ##

# Lê entrada hexadecimal
entradaHex:
	# Imprime string para entrada de dados
	li $v0, 4
	la $a0, valorEntrada16
	syscall
	
	# Lê entrada como string
	li $v0, 8
	la $a0, stringLida
	li $a1, 64
	syscall
	
	# Contagem de caracteres
	li $t0, 0
	strlen:
		# Desvio de fim de string
		beq $t0, 63, numeroInvalido
		lb $t5, stringLida($t0)
		beq $t5, '\n', fimStrlen
		jal confereHex
		addi $t0, $t0, 1
		
		j strlen
	fimStrlen:
		move $s5, $t0
		
	li $t7, 16
	jal promptSaida
	
	move $s0, $v0
	
	beq $s0, 2, hexToBin
	beq $s0, 10, hexToDec
	
	j numeroInvalido

hexToDec:
	move $t0, $zero
	move $t5, $zero
	enquantoNum:
		lb $t5, stringLida($t5)
		addi $t0, $t0, 1
		
		jal converteValor
		
		# Inicia t1 com o tamanho da array para o pow loop
		move $t1, $s5
		# Base pow
		li $t2, 16
		pow:
			bge $t0, $t1, endpow
			mult $t5, $t2
			mflo $t5 # Pega resultado da multiplicação e passa pra $t5
			addi $t1, $t1, -1	# Decremento
			j pow
		endpow:
			# Soma cada casa em $s7
			add $s7, $s7, $t5
			j enquantoNum
	
	li $v0,4
	la $a0, promptConvertido
	syscall
	
	# Printar valor de dec unsigned
	li $v0, 36
	move $a0, $s7
	syscall
	
	j fim
	
hexToBin:
	j fim

# Confere se caracter atual ($t5) é número ou letra entre ['a', 'f']
confereHex:
	# Se não for carater de número
	bgt $t5, 58, ehLetra
	# Menor que '0'
	ble $t5, 48, numeroInvalido
	
	j endConfHex
	
	ehLetra:
		ble $t5, 96 , numeroInvalido 	# Checa se é letra realmente
		bgt $t5, 102, numeroInvalido	# Checa se as letras são a,b,c,d,e,f
		
	endConfHex:
		jr $ra