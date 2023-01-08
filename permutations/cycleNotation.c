#include<stdio.h>
#include<string.h>
#include<stdbool.h>

int main( int argc, char *argv[] )
{   
    int a=strlen(argv[1]);
    char  cycle[a];
    //int order=1;
    
   
    for(int k=0;k<a;k++)
    {   
        if(argv[1][k]!=1)
        {   
            int y=0;
            printf("(");
            cycle[y]=argv[1][k];
            printf("%c",cycle[y]);
            
            for (int z=0;z<a;z++)
                {   
                    if(argv[1][z]==cycle[y])
                    {
                    
                    y++;
                    cycle[y]=argv[2][z];
                    argv[1][z]=1;
                    if(cycle[y]!=cycle[0])
                    printf("%c",cycle[y]);
                    }
                }
            printf(") ");
            //order=order*y;
        }
    }
    //printf("%d",order);
}