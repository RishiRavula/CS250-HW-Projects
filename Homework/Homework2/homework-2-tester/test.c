#include <stdio.h>

int main()
{
    int numbers[10]; // assume numbers[0] is at address 1000

    for (int i=0; i<=4; i++){
	        *(numbers+i) = i*i;
            
    }

    for (int i=5; i<=9; i++){
	numbers[i] = numbers [i-1] + 2;
    
    }
    printf("%p\n",numbers);
    int* A = numbers+2;
    int B =   numbers[7];   // B is at address 2004
    int* C =  numbers + numbers[4]; // C is at address 2008
    int x =   numbers[3];  // x is at address 2012
    int D =  *(numbers +x); // D is at address 2016
    // int y =  (int)(&y) - (int)A; // y is at address 2020
    // #int E =  *(numbers + y - 20);  // E is at address 2024

    printf("%p\n",A);
    printf("%d\n",B);
    printf("%p\n",C);
    printf("%d\n",D);
    // printf("%d\n",E);



    return 0;
}
