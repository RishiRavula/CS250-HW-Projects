#include <stdio.h>
#include <stdlib.h>

int recurse (int num){
  if(num == 0){
    return -2;
  }
  else{
    return (3*num) + (2*recurse(num-1)) - 2;
  }
}

int main(int argc, char* argv[]){
  int num = atoi(argv[1]);
  int ans = recurse(num);
  printf("%d \n",ans);
  return 0;
  
}
