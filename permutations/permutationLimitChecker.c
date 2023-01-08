#include<stdlib.h>
#include<stdio.h>

int main(int argc, char *argv[]){
    unsigned long long int permutationLimit = 1;
    int permutationDegree = atoi(argv[1]);
    int requestedPermutationLength = atoi(argv[2]);

    for (int i=1; i<=permutationDegree; i++){
        permutationLimit *= i;
    }

    //prints T if permutation is possible to obtain, other way prints F
    if (permutationLimit >= requestedPermutationLength){
        printf("T");
    } else{
        printf("F");
    }
}
