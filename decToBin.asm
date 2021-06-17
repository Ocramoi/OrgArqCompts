.data
.text
.globl decToBin
#A ideia aqui é bem simples e consiste de alguns passos básicos:
#1 - Copiar o conteúdo de $a1 para $s1
#2 - Definir $v0 como 1, para a syscall de impressão e para a comparação lógica
#3 - Definirmos o número máximo de bits que o número pode ter
#4 - Repetir esses passos:	
	#4.1 - Fazer o shift lógico de $s1 para a direita(Dividir por 2) N vezes e guardar isso  
	#4.2 - Fazer um AND do resultado do shift lógico com o número 1, pra pegar só o bit menos significativo
	#4.3 - Imprimir o resultado
	#4.4 - Decrescer N em 1
	#4.5 - Se N não for -1, voltar para #4.1
#5 - Encerrar o programa

#Por conta de como é implementado, ele sempre vai imprimir 32 bits, então o número 1, por exemplo, sairia como:
#00000000000000000000000000000001

#OBS: Armazenar o número que queremos transformar no registrador $a1, já que $a0 será usado para impressão
decToBin:
	move $t0, $a1  #numeroGrande = atributo
	li $v0, 1 #Para a syscall e comparação
	li $t1, 31 #int i = 31
	
 	#do{
 	inicioLoop:
		srlv $a0, $t0, $t1  	#parcial = numeroGrande / 2^i       
		and $a0, $a0, $v0	#parcial = parcial%2
		syscall			#printf("%d", parcial)
		addi $t1, $t1, -1	#i--;
		bne $t1, -1, inicioLoop	#}while(i >= 0)
	
	
	 jr $ra #return

