#include <stdio.h>
#include <string.h>
#include <stdlib.h>
struct LinkedList{
  char person[100];
  char infects[100];
  struct LinkedList* next;
};

LinkedList* insertNode(struct LinkedList* head, char* infected){
	struct LinkedList* ll_ptr = head;
	if(strcmp(infected, head->person) < 0){ //infected comes first
		struct LinkedList* insert = (LinkedList*) calloc(1,sizeof(LinkedList));
		strcpy(insert->person,infected);
		insert -> next = head;
		return insert;
	}
	while(ll_ptr->next != NULL){
		if(strcmp(infected,ll_ptr->next -> person) < 0){
			struct LinkedList* insert = (LinkedList*) calloc(1,sizeof(LinkedList));
			strcpy(insert->person,infected);
			insert -> next = ll_ptr -> next;
			ll_ptr -> next = insert;
			return head;
		}
		ll_ptr = ll_ptr -> next;
	}
	struct LinkedList* end = (LinkedList*) calloc(1,sizeof(LinkedList));
	strcpy(end->person,infected);
	ll_ptr -> next = end;
	return head;
}

void iterator(char* name, char* infected, struct LinkedList* head){
	while(head != NULL){
		if(strcmp(name,head -> person) == 0){ 
			if(strlen(head -> infects) == 0){
				strcat(head -> infects,infected);
			}
			else{
				char* temp = head -> infects;
				if(strcmp(temp,infected)<0){ //temp comes first
				strcat(head -> infects," ");
				strcat(head -> infects,infected);
				}
				else{ //infected comes first, need to switch the current order
				char properOrder[100]= "";
				
				strcpy(properOrder,infected);
				strcat(properOrder, " ");
				strcat(properOrder, temp);
				strcpy(head->infects,properOrder);
					
				}

				strcat(head -> infects," ");
			}
			
			break;
			}
		else{
		head = head -> next;
		}
		
	}
}

void printfunction(struct LinkedList* head){
	while(head != NULL){
	printf("%s %s\n",head -> person, head -> infects);
	LinkedList* tmp = head;
	head = head -> next;
	free(tmp);
	}
}



int main(int args, char* argv[]){
  FILE *file;
  file = fopen(argv[1],"r");
  char* infected;
  char* infector;
  char line[200];
  char s[2] = " ";
  char* token;
  struct LinkedList* head = (LinkedList*) calloc(1,sizeof(LinkedList));
  strcpy(head -> person,"BlueDevil");
  struct LinkedList* running_ptr = head;
  while(1){
  	fgets(line,200,file);
  	if(strcmp(line,"DONE\n") == 0){
  		break;
  	}
	//struct LinkedList* tmp = (LinkedList*) malloc(sizeof(LinkedList));
  	//running_ptr -> next = tmp;
  	token  = strtok(line,s);
  	infected = token;
	//strcpy(tmp->person,infected);
  	token = strtok(NULL,s); 
  	infector = token;
  	infector =  strtok(infector, "\n"); //REMOVE NEW LINE AT THE END OF INFECTOR
	head = insertNode(head, infected);
  	iterator(infector,infected,head);  
	//running_ptr = running_ptr -> next;	  	
  }
  fclose(file);
  printfunction(head);
  return(0);
}
