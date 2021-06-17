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
	hexadec: .asciiz "0x"
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

# Transforma valor em $t5 de caracater [0...9, 'a', 'b', 'c', 'd', 'e', 'f'] para inteiro
converteValor:	
	# Se não for carater de número
	bgt $t5, 58, ehLetraConv
	# Menor que '0'
	ble $t5, 47, numeroInvalido
	
	addi $t5, $t5, -48
	j endConvVal
	
	ehLetraConv:
		ble $t5, 96 , numeroInvalido 	# Checa se é letra realmente
		bgt $t5, 102, numeroInvalido	# Checa se as letras são a, b, c, d, e f
		addi $t5, $t5, -87
		
	endConvVal:
		jr $ra

# Fim de programa
fim:
	li $v0, 4
	la $a0, quebraDeLinha
	syscall

	# Chamada de sistema de fim de programa
	li $v0, 10
	syscall

## Entrada binária ##

# Lê entrada binária
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
	
	li $t7, 2
	jal promptSaida
	move $s0, $v0
	
	converteParaInt:
		li $t5, 1 # Contador para exponencial
		la $t3, stringLida
		move $a0, $t3
		li $t4, 64
		li $t9, 0 # Valor decimal inicial
	
	beq $s0, 10, binToDec
	beq $s0, 16, binToHex
	
	j numeroInvalido

binToDec:
	converteByteBin:
		lb $t2, ($t3) # Carrega caracter da string
	
		beq $t2, '\n', printDecimalBin
		bgt $t2, 49, numeroInvalido
		blt $t2, 48, numeroInvalido
		
		subi $t2, $t2, 48 # Transforma ascii para 0/1
		beq $t2, 0, ehZeroBin # Caso 0
		beq $t2, 1, ehUmBin # Caso 1
		j printDecimalBin
	
	ehZeroBin:
		addi $t3, $t3, 1	# Byte offset++
		subi $t4, $t4, 1	# Contador--
		j converteByteBin
	
	ehUmBin:
		# Adiciona exponencial do contador
		addi $t3, $t3, 1	# Byte offset++
		subi $t4, $t4, 1	# Contador--
		sllv $t6, $t5, $t4
		add $t9, $t9, $t6	# Computa valor da exponencial para $t9
		j converteByteBin
	
	printDecimalBin:
		srlv $t9, $t9, $t4	
				# Shift de $t4 << contador concertando posição de byte
				# Exemplo: convertendo (11)_2 -> 11000000000...
				# então, para consertar, fazemos o shift para ...00000000000011, obtendo (3)_10
	
		# Mensagem de saída
		la $a0, promptConvertido
		li $v0, 4
		syscall
	
		# Exibe valor convertido
		move $a0, $t9
		li $v0, 1
		syscall
	
	j fim
	
binToHex:
	converteByteHex:
		lb $t2, ($t3) # Carrega caracter da string
	
		beq $t2, '\n', valBinHex
		bgt $t2, 49, numeroInvalido
		blt $t2, 48, numeroInvalido
		
		subi $t2, $t2, 48 # Transforma ascii para 0/1
		beq $t2, 0, ehZeroHex # Caso 0
		beq $t2, 1, ehUmHex # Caso 1
		j valBinHex

	ehZeroHex:
		addi $t3, $t3, 1	# Byte offset++
		subi $t4, $t4, 1	# Contador--
		j converteByteHex
		
	ehUmHex:
		# Computa exponencial do contador
		addi $t3, $t3, 1	# Byte offset++
		subi $t4, $t4, 1	# Contador--
		sllv $t6, $t5, $t4
		add $t9, $t9, $t6	# Adiciona resultado do exponencial para $t9
		j converteByteHex

	j fim

valBinHex:
	srlv $t9, $t9, $t4	# Concerta bytes decimais
	
	move $t0, $t9 # Salva inteiro de $t9 em $t0
	li $t2, 15
	li $t1, 28
	
	# Exibe mensagem de saída
	la $a0, promptConvertido
	li $v0, 4
	syscall
	
	# Exibe incício de hexa
	la $a0, hexadec
	li $v0, 4
	syscall

startLoopBinHex:
	srlv $a0, $t0, $t1  	#parcial = numeroGrande / 2^i, sendo que i é sempre um multiplo de 4   
	and $a0, $a0, $t2	#parcial = parcial%16
	li $v0, 1 		#Para a syscall
	bge $a0, 10, printStringBinHex #if(parcial> 9)goto printString 
	
returnFromPrintStringBinHex:		#prints parcial as a number, depending on its value (<10 or >10)
	syscall			#imprime parcial como numero ou caractere dependendo se parcial é menor que 10 ou nao
	addi $t1, $t1, -4	#i = i-4;
	bne $t1, -4, startLoopBinHex	#}while(i >= 0)
	
	j fim #return
	 
	#fix values from $a0 and $v0 to print in hex(10 = A, 11 = B, 12 = C, 13 = D, 14 = E, 15 = F)
printStringBinHex:
	addi $a0, $a0, 87 # 'a' é 87 no ASCII. $a0 == 10 é pra ser 'a', então somamos 87 no valor de $a0 e imprimimos como caracter
	li $v0, 11 # Print $v0 como caracter
	j returnFromPrintStringBinHex

## Entrada decimal ##

# Lê valor decimal
entradaDec:
	# Imprime string para entrada de dados
	li $v0, 4
	la $a0, valorEntrada10
	syscall
	
	# Lê entrada como string
	li $v0, 8
	la $a0, stringLida
	li $a1, 64
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
	
	beq $s0, 10, hexToDec
	beq $s0, 2, hexToDec
	j numeroInvalido

hexToDec:
	move $t0, $zero
	enquantoNum:
		lb $t5, stringLida($t0)
		beq $t5, '\n', fimHexToDec
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
	
	fimHexToDec:
		beq $s0, 2, hexToBin
	
		li $v0,4
		la $a0, promptConvertido
		syscall
	
		# Printar valor de dec unsigned
		li $v0, 36
		move $a0, $s7
		syscall
	
		j fim
	
hexToBin:
	li $t0, 0 	# Inicia index no 0
	li $t2, 2	# Valor 2 para dividir
	ateZerarQuotient:
		divu $s7, $t2		# Divide por 2 para achar cada digito  do binário
 		
		mflo $s7
		mfhi $t3
		
		addiu $sp, $sp, -1	# Salva para stack cada byte do módulo
		sb $t3,($sp)
		
		addi $t4, $t4, 1	# Incrementa para usarmos depois quando formos printar a string de trás para frente
		
		bnez $s7, ateZerarQuotient
	
	# Printar mensagem para resultado bin
	li $v0, 4	
	la $a0, promptConvertido
	syscall
		
	ateFinalString:			#escreve a string de trás para frente
		lb $t3,($sp)		#carrega da stack
		addi $sp, $sp, 1
	
		addi $t4, $t4, -1	# Contador bits
	
		li $v0, 1		# Printar valor de bin
		move $a0, $t3
		syscall
	
		bgtz $t4, ateFinalString

	j fim

# Confere se caracter atual ($t5) é número ou letra entre ['a', 'f']
confereHex:
	# Se não for carater de número
	bgt $t5, 58, ehLetra
	# Menor que '0'
	ble $t5, 47, numeroInvalido
	
	j endConfHex
	
	ehLetra:
		ble $t5, 96 , numeroInvalido 	# Checa se é letra realmente
		bgt $t5, 102, numeroInvalido	# Checa se as letras são a,b,c,d,e,f
		
	endConfHex:
		jr $ra