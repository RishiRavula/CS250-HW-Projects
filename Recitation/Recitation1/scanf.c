/* scanf example */
#include <stdio.h>
int main()
{
  char str[80]; //allocating space to write
  int i;

  printf ("Enter your family name: ");
  scanf("%s",str); // reads a string (string code is %s, stored in str[80]
  printf ("Enter your age: ");
  scanf ("%d",&i); // reads an in (int code is %d) stored into i (&i)
  printf ("Mr. %s , %d years old. \n",str,i); // %s is 1st input %d is second input, param arguments are str for 1, i for 2)

  return 0;
 }
