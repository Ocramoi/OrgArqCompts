.data 
	hexadec: .asciiz "0x"
.text
.globl decToHex


#A ideia aqui � bem simples e consiste de alguns passos b�sicos:
#1 - Copiar o conte�do de $a1 para $s1
#2 - Definir $v0 como 1, para a syscall de impress�o e para a compara��o l�gica
#3 - Definirmos o n�mero m�ximo de bits que o n�mero pode ter
#4 - Repetir esses passos:	
	#4.1 - Fazer o shift l�gico de $s1 para a direita(Dividir por 2) N vezes e guardar isso  
	#4.2 - Fazer um AND do resultado do shift l�gico com o n�mero 15, pra pegar os 4 bits menos significativos
	#4.3 - Imprimir o resultado
	#4.4 - Decrescer N em 4(dessa forma dividimos por 16 em vez de por 2 em cada itera��o)
	#4.5 - Se N n�o for -1, voltar para #4.1
#5 - Encerrar o programa

#Por conta de como � implementado, ele sempre vai imprimir 8 hexadecits(?), ent�o o n�mero 1, por exemplo, sairia como:
#0x00000001

#OBS: Armazenar o n�mero que queremos transformar no registrador $a1, j� que $a0 ser� usado para impress�o
decToHex:
	move $t0, $a1  #numeroGrande = atributo
	li $t2, 15 #para a compara��o
	li $t1, 28 #int i = 31
	
	la $a0, hexadec
	li $v0, 4 
	syscall #printf("0x")
	
	
 	#do{
 	inicioLoop:
		srlv $a0, $t0, $t1  	#parcial = numeroGrande / 2^i, sendo que i � sempre um multiplo de 4   
		and $a0, $a0, $t2	#parcial = parcial%16
		li $v0, 1 #Para a syscall
		bge $a0, 10, printString#if(parcial> 9)goto printString 
		returnFromPrintString:
		syscall			#imprime parcial como numero ou caractere dependendo se parcial � menor que 10 ou nao
		addi $t1, $t1, -4	#i = i-4;
		bne $t1, -4, inicioLoop	#}while(i >= 0)
	
	
	 jr $ra #return
	
	#Basicamente a gente ajeita o valor do $a0 e do $v0 pra ele imprimir A, B,..., F em vez de 10, 11,..., 15
	printString:
		addi $a0, $a0, 55 #A � 65 no ASCII. $a0 ==10 � pra ser A, entao somamos 55 no valor de $a0 e imprimimos como caracter
		li $v0, 11 #mudamos o $v0 para imprimir um caracter em vez de um numero
		j returnFromPrintString