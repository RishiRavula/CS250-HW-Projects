#include <stdio.h>
#include <string.h>
#include <stdlib.h>
struct LinkedList{
  char person[100];
  char infects[100];
  struct LinkedList* next;
};


void iterator(char* name, char* infected, LinkedList* head){
	while(head != NULL){
		if(strcmp(name,head -> person) == 0){ 
			strcat(head -> infects,infected);
			strcat(head -> infects," ");
			break;
			}
		else{
		head = head -> next;
		}
		
	}
}

void printfunction(LinkedList* head){
	while(head != NULL){
	printf("%s %s\n",head -> person, head -> infects);
	head = head -> next;
	}
}



int main(int args, char* argv[]){
  FILE *file;
  int t = 0;
  file = fopen(argv[1],"r");
  if (file == NULL){
  t = 1;
  }
  char* infected;
  char* infector;
  char line[200];
  char s[2] = " ";
  char* token;
  int allocSize = 1;
  LinkedList* head = (LinkedList*) malloc(sizeof(LinkedList));
  strcpy(head -> person,"BlueDevil");
  LinkedList* running_ptr = head;
  while(1){
  	fgets(line,200,file);
  	if(strcmp(line,"DONE\n") == 0){
  		break;
  	}
  	LinkedList* tmp = (LinkedList*) malloc(sizeof(LinkedList));
  	running_ptr -> next = tmp;
  	token  = strtok(line,s);
  	infected = token;
  	printf("Infected %s\n",infected);
  	strcpy(tmp -> person,infected);
  	token = strtok(NULL,s); //TODO: ISSUE HERE TO FIX, INFECTOR NOT BEING STORES, token = 0x0
  	infector = token;
  	infector =  strtok(infector, "\n"); //REMOVE NEW LINE AT THE END OF INFECTOR
  	printf("Infector %s\n",infector);
  	iterator(infector,infected,head);
  	running_ptr = running_ptr -> next;
  	  	
  }
  fclose(file);
  printfunction(head);
  return(0);
}
