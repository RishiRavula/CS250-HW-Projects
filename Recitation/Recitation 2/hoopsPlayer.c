#include <stdio.h>

  struct HoopsPlayer{
    int playerNum;
    float ppg;
  };
 struct HoopsPlayer playerList[10];

void printPlayers(HoopsPlayer playerList[], int counter){
  for(int i = 0; i < counter; i++){
    printf("Player #%d: %f Average Points Per Game \n",playerList[i].playerNum, playerList[i].ppg);
  }
}


void swap(HoopsPlayer* xp, HoopsPlayer* yp)
{
    HoopsPlayer temp = *xp;
    *xp = *yp;
    *yp = temp;
}
 
// Function to perform Selection Sort
void selectionSort(struct HoopsPlayer arr[], int n)
{
    int i, j, min_idx;
 
    // One by one move boundary of unsorted subarray
    for (i = 0; i < n - 1; i++) {
 
        // Find the minimum element in unsorted array
        min_idx = i;
        for (j = i + 1; j < n; j++)
            if (arr[j].ppg < arr[min_idx].ppg)
                min_idx = j;
 
        // Swap the found minimum element
        // with the first element
        swap(&arr[min_idx], &arr[i]);
    }
}

  
int main(){
  int currNum;
  float currPPG;
  int counter = 0;
  for(int i = 0; i < 10; i++){
    printf("Enter Player's Number: ");
    scanf("%d",&currNum);
    if(currNum == -1){
      break;
    }
    
    printf("Enter Player's Points Per Game: ");
    scanf("%f", &currPPG);

    playerList[i].playerNum = currNum;
    playerList[i].ppg = currPPG;
    counter++;
    
    }
    selectionSort(playerList,counter);
    printPlayers(playerList,counter);
    return 0;
  }  

