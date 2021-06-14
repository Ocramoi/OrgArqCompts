#include<stdio.h>
#include<stdlib.h>

void decToHex(int num){
    int partials = num, counter = 33, i;
    int buffer[33];

    while(partials != 0 && counter >=0){
        counter--;
		buffer[counter] = partials%16;
        partials = partials/16;
    }

    printf("Numero em Hex: ");
	for(i = counter; i < 33; i++){
		if(buffer[i] > 9){
			switch(buffer[i]){
				case 10:
					printf("A");
					break;
				case 11:
					printf("B");
					break;
				case 12:
					printf("C");
					break;
				case 13:
					printf("D");
					break;
				case 14:
					printf("E");
					break;
				case 15:
					printf("F");
					break;
				default:
					break;
			}
		}else{
			printf("%d", buffer[i]);
		}
	}
	printf("\n");
}