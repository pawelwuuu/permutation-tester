#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	const char *baza;
	baza=argv[1];
	const char *permutacja;
	permutacja=argv[2];
	int dlugosc = strlen(baza);
	int ciag[dlugosc];
	int ciag2[dlugosc];
		for(int i=0;i<dlugosc;i++)
		{
			for(int j=0;j<dlugosc;j++)
			{
			if(permutacja[j]==baza[i])
				{
				ciag[i]=j;
				}
			}
		}
		for(int i=0;i<dlugosc;i++)
		{
		  int a=ciag[i];
		  ciag2[a]=i;
		}
		for(int i=0;i<dlugosc;i++)
		{
		printf("%c",permutacja[ciag2[i]]);
		}
// printf("\n");
return 0;
}