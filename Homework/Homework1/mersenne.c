#include <stdio.h>
#include <math.h>

int main(int argc, char* argv[]){
  int input = atoi(argv[1]);
  int  mersenne = pow(2,input) - 1;
  printf("%d \n",mersenne);
}
