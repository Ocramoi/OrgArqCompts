#include<stdio.h>
#include<stdlib.h>

void decToBin(int num){
    int partials = num, counter = 33, i;
    int buffer[33];

    while(partials != 0 && counter >=0){
        counter--;
		buffer[counter] = partials%2;
        partials = partials/2;
    }

    printf("Numero em Bin: ");
	for(i = counter; i < 33; i++){
		printf("%d", buffer[i]);
	}
	printf("\n");
}