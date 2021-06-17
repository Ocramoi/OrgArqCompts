.data 
	hexadec: .asciiz "0x"
.text
.globl decToHex


#A ideia aqui é bem simples e consiste de alguns passos básicos:
#1 - Copiar o conteúdo de $a1 para $s1
#2 - Definir $v0 como 1, para a syscall de impressão e para a comparação lógica
#3 - Definirmos o número máximo de bits que o número pode ter
#4 - Repetir esses passos:	
	#4.1 - Fazer o shift lógico de $s1 para a direita(Dividir por 2) N vezes e guardar isso  
	#4.2 - Fazer um AND do resultado do shift lógico com o número 15, pra pegar os 4 bits menos significativos
	#4.3 - Imprimir o resultado
	#4.4 - Decrescer N em 4(dessa forma dividimos por 16 em vez de por 2 em cada iteração)
	#4.5 - Se N não for -1, voltar para #4.1
#5 - Encerrar o programa

#Por conta de como é implementado, ele sempre vai imprimir 8 hexadecits(?), então o número 1, por exemplo, sairia como:
#0x00000001

#OBS: Armazenar o número que queremos transformar no registrador $a1, já que $a0 será usado para impressão
decToHex:
	move $t0, $a1  #numeroGrande = atributo
	li $t2, 15 #para a comparação
	li $t1, 28 #int i = 31
	
	la $a0, hexadec
	li $v0, 4 
	syscall #printf("0x")
	
	
 	#do{
 	inicioLoop:
		srlv $a0, $t0, $t1  	#parcial = numeroGrande / 2^i, sendo que i é sempre um multiplo de 4   
		and $a0, $a0, $t2	#parcial = parcial%16
		li $v0, 1 #Para a syscall
		bge $a0, 10, printString#if(parcial> 9)goto printString 
		returnFromPrintString:
		syscall			#imprime parcial como numero ou caractere dependendo se parcial é menor que 10 ou nao
		addi $t1, $t1, -4	#i = i-4;
		bne $t1, -4, inicioLoop	#}while(i >= 0)
	
	
	 jr $ra #return
	
	#Basicamente a gente ajeita o valor do $a0 e do $v0 pra ele imprimir A, B,..., F em vez de 10, 11,..., 15
	printString:
		addi $a0, $a0, 55 #A é 65 no ASCII. $a0 ==10 é pra ser A, entao somamos 55 no valor de $a0 e imprimimos como caracter
		li $v0, 11 #mudamos o $v0 para imprimir um caracter em vez de um numero
		j returnFromPrintString