#include <iostream>

#include <time.h>

#include <stdlib.h>

using namespace std;

char bylo[62];

char tworzenie() {
  int wyjdz = 1;
  int r;
  do {
    r = rand() % 60;
    if (bylo[r] == 0) {
      wyjdz = 0;
      bylo[r] = 1;
      if (r < 10) {
        r = r + 48;
      } else {
        if (r < 36) {
          r = r + 55;
        } else {
          r = r + 61;
        }
      }
    }
  }

  while (wyjdz == 1);
  return r;

}

int main(int argc, char ** argv) {
  string slowo = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
  srand(time(NULL));
  int dlugosc = atoi(argv[1]);
  int powtorzenia = atoi(argv[2]);
  if (powtorzenia == 0) {
    powtorzenia++;
    for (int i = 1; i <= dlugosc; i++) {
      powtorzenia = powtorzenia * i;
    }
  }
  string sprawdz[powtorzenia];
  for (int i = 0; i < dlugosc; i++) {
    slowo[i] = tworzenie();
  }
  slowo = slowo.substr(0, dlugosc);
  string glowne = slowo;
  for (int k = 0; k < powtorzenia; k++) {
    char budka;
    for (int i = 0; i < dlugosc; i++) {
      int r = rand() % dlugosc;
      budka = slowo[r];
      int w = rand() % dlugosc;
      slowo[r] = slowo[w];
      slowo[w] = budka;
    }
    bool czy = true;
    for (int j = 0; j < k; j++) {
      if (sprawdz[j] == slowo) {
        czy = false;
      }
    }
    if (czy = true) {
      cout << slowo << endl;
      sprawdz[k] = slowo;
    } else
      k--;
  }
  cout << glowne << endl;
  return 0;
}