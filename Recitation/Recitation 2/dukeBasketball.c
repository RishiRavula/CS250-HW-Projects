/* scanf example */
#include <stdio.h>
int main()
{
  char str[80]; //allocating space to write
  int height;
  int apg;

  printf ("Please input player information: ");
  scanf("%s %d %d", str,&height,&apg);
  printf("Player %s", str);
  
  float api = (float) apg / (float) height;
  
  printf(" scored an average of %f points per inch", api);
  

  return 0;
 }
