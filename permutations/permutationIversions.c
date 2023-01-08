#include <stdio.h>
#include <string.h>

int main(int argc, const char *const *argv){
    const char *mainPermutation;
    mainPermutation = argv[1];

    const char *computedPermutation;
    computedPermutation = argv[2];

    int permutationLength = strlen(mainPermutation);


    for (int i = 0; i < permutationLength; i++)
    {
        char actualDigit = computedPermutation[i];

        for (int j = i + 1; j < permutationLength; j++)
        {
            int indexOfSuccesor = 0;
            for (int h = 0; h < permutationLength; h++)
            {
                if ((mainPermutation[h] == computedPermutation[j])){
                    indexOfSuccesor = h;
                }
            }

            int indexOfActualDigit = 0;
            for (int g = 0; g < permutationLength; g++)
            {
                if ((mainPermutation[g] == computedPermutation[i])){
                    indexOfActualDigit = g;
                }
            }
            
            if (indexOfActualDigit > indexOfSuccesor){
                printf("(%c %c) ", actualDigit, computedPermutation[j]);
            }
        }
        
    }

    return 0;
}