.data				#Lucas Massao Fukusawa Dagnone - 11295810 
.align 0
pular:			.asciiz " "
promptHexNum:		.asciiz "\nDigite o n�mero em hexadecimal, para as letras use as min�sculas: "
promptQualConvert:	.asciiz "\nDigite 1 para converter para decimal e 2 para bin�rio: "
msgOverflow:		.asciiz "\nOcorreu overflow, algum valor inserido � invalido. O programa ir� terminar agora."
msgInvalido:		.asciiz "\nN�mero invalido. O programa ir� terminar agora."
resDec:			.asciiz "\nO resultado da convers�o para decimal �: "
resBin:			.asciiz "\nO resultado da convers�o para bin�rio �: "
.align 2
userInput:		.space 10         #aloca 10 bytes de mem�ria para o numero hex, 9 digitos e finalizador de string, ffff ffff � o n�mero m�ximo que se pode ter em um inteiro de 32 bits
.text
.globl main
		
main:
	#Printar prompt para n�mero hex
	li $v0, 4		#C�digo para printar 
	la $a0, promptHexNum
	syscall
	
	#Pegar input do usu�rio para o n�mero hex em texto
	li $v0, 8		#C�digo 8 para ler texto
	la $a0, userInput  	
	li $a1, 10          	#Passa como argumento o tamanho da array
	syscall
	
	strlen:					#checa o tamanho da string
		beq $t0, 9, numeroInvalido	# checa se chego no final da string
		lb $t5, userInput($t0)		#carrega um byte do array para $t6
			beq $t5, '\n', exitstrlen	#sai se atingir caract�r "\n"
			addi $t0, $t0, 1	#Offset de 1 byte
		j strlen
	exitstrlen:
		addi $s5, $t0, 0		#$s5 ser� o tamanho da string
	
	#Printar prompt para qual converter
	li $v0, 4
	la $a0, promptQualConvert
	syscall
	
	#Pegar input para qual convers�o � desejada
	li $v0, 5			#C�digo 5 para ler inteiro
	syscall			
	move $s0, $v0
	
	addi $s1, $zero, 1
	addi $s2, $zero, 2
	
	addi $t0, $zero, 0 	#Inicia index no 0
	
	j convertDec
	
	j fimProg

convertDec:
	addi $t0, $zero, 0 	#Inicia index no 0
	enquantoAindaTemNum:
		beq $t0, 9, exit		#caso atinja o final do array va para exit
		
		lb $t5, userInput($t0)		#carrega um byte do array para $t6
			beq $t5, '\n', exit	
			addi $t0, $t0, 1	#Offset de 1 byte
		
		jal tratarLetra
		
		
		addi $t1, $s5, 0		#inicia t1 com o tamanho da array para o pow loop
		addi $t2, $zero, 16		#da a t2 a base 
		pow:
			bge $t0, $t1, endpow	
			mult $t5, $t2
			mflo $t5		#pega resultado da multiplica��o e passa pra $t5
			#mfhi $t6
			#bnez $t6, overflow	#printa caso tenha overflow, n�o necess�rio, pois j� tratamos isso anteriormente
			addi $t1, $t1, -1	#decremento
			j pow
		endpow:
		
		add $s7, $s7, $t5		#soma cada casa em $s7	
			
		j enquantoAindaTemNum
		
	exit:
	
	beq $s0,$s2 convertBin
	
	#Printar mensagem para resultado dec
	li $v0, 4		
	la $a0, resDec
	syscall
	
	li $v0, 1		#printar valor de dec
	move $a0, $s7
	syscall


	j fimProg
	
convertBin:
	addi $t0, $zero, 0 	#Inicia index no 0
	addi $t2, $zero, 2	#da valor 2 para dividir
	ateZerarQuotient:
		div $s7, $t2		#divide por 2 para achar cada digito  do bin�rio
 
		mflo $s7
		mfhi $t3
		
		addi $sp, $sp, -1
		sb $t3,($sp)
		
		addi $t4, $t4, 1
		
		bnez $s7, ateZerarQuotient
	
	#Printar mensagem para resultado bin
	li $v0, 4	
	la $a0, resBin
	syscall
		
	ateFinalString:
		lb $t3,($sp)
		addi $sp, $sp, 1
	
		addiu $t4, $t4, -1
	
		li $v0, 1		#printar valor de bin
		move $a0, $t3
		syscall
	
		bgtz $t4, ateFinalString
	
	j fimProg
	
tratarLetra:
	bgt $t5, 58, tratarLetra	#se o valor ascii for maior que 58 (para letras)
	ble $t5, 48 , numeroInvalido 	#checa se � n�mero realmente
	addi $t5, $t5, -48		#caso tenhamos n�meros
	
	j endtratarLetra
	
	ble $t5, 96 , numeroInvalido 	#checa se � letra realmente
	bgt $t5, 102, numeroInvalido	#checa se as letras s�o a,b,c,d,e,f
	addi $t5, $t5, -87 		#caso tenhamos letra
		
	endtratarLetra:
	
	jr $ra
	
overflow:
	#Printar mensagem final programa para overflow
	li $v0, 4
	la $a0, msgOverflow
	syscall
	
	j fimProg
	
numeroInvalido:
	#Printar mensagem final programa para n�mero invalido como g, h, a, e.
	li $v0, 4
	la $a0, msgInvalido
	syscall
	
	j fimProg
	
fimProg: 			#encerra o programa
	li $v0, 10		#load para v0, 10 � o c�digo de sa�da
	syscall			#E/S
	
		
