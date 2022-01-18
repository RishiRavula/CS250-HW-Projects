#include <stdio.h>
#include <cstdlib>
#include <string.h>
struct LinkedList{
  char person[100];
  char infects[100] = " ";
  struct LinkedList* next;
};


void iterator(char* name, char* infected, LinkedList* head){
	LinkedList* first = head;
	name[strcspn(name,"\n")] = 0;
	while(first != NULL){
		if(strcmp(name,first -> person) == 0){
			strcat(first -> infects,infected);
			strcat(first -> infects,"\n");
			break;
			}
		else{
		first = first -> next;
		}
		
	}
}

void printfunction(LinkedList* head){
	while(head != NULL){
	printf("Infector: %s , Infected: %s",head -> person, head -> infects);
	head = head -> next;
	}
}



int main(int args, char* argv[]){
  FILE *file = fopen("/home/rishi/CS250-HW-Projects/Homework/Homework1/tests/covidtracker_input_1.txt", "r");
  char* infected;
  char* infector;
  char line[200];
  char s[2] = " ";
  char* token;
  int allocSize = 1;
  LinkedList* head = (LinkedList*) malloc(sizeof(LinkedList));
  strcpy(head -> person,"BlueDevil");
  LinkedList* running_ptr = head;
  while(true){
  	fgets(line,200,file);
  	if(strcmp(line,"DONE\n") == 0){
  		break;
  	}
  	LinkedList* tmp = (LinkedList*) malloc(sizeof(LinkedList));
  	running_ptr -> next = tmp;
  	token  = strtok(line,s);
  	infected = token;
  	strcpy(tmp -> person,infected);
  	token = strtok(NULL, s);
  	infector = token;
  	iterator(infector,infected,head);
  	running_ptr = running_ptr -> next;
  	  	
  }
  printf("Test Seg");
  fclose(file);
  printfunction(head);
  return(0);
}
