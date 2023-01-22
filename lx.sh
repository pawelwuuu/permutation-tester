#!/bin/bash

# Tworzenie pliku LaTeX
echo "\documentclass{article}" > hello.tex
echo "\usepackage[T1]{fontenc}" >> hello.tex
echo "\usepackage{graphicx}" >> hello.tex
echo "\usepackage{titlesec}" >> hello.tex
echo "\begin{document}" >> hello.tex

j=0

droga=droga
lines=$(wc -l < tmpFile.txt)

# Tworzenie tablicy
lines_array=()

# Iteracja po wszystkich liniach z pliku, z wyjątkiem ostatniej
for ((a=1; a<$lines; a++)); do
    # Pobieranie linii z pliku
    line=$(sed -n "${a}p" tmpFile.txt)
    line=${line:2}
    cp $line .
    droga=$line
    # Dodawanie linii do tablicy
    staty=${line:20}
# Tworzenie tablicy do przechowywania linii z pliku
linie_pliku=()
czasy=()
permutacje=()

# Otwarcie pliku staty.txt do odczytu
while IFS= read -r line; do
    # Dodanie aktualnie przetwarzanej linijki do tablicy
    linie_pliku+=("$line")
done < $staty

#Tworzenie dwoch tablic
for ((i=1;i<${#linie_pliku[*]};i++));do
    if [[ $((i % 2)) -eq 0 ]]; then
        czasy+=("${linie_pliku[i]}")
    else
        permutacje+=("${linie_pliku[i]}")
    fi
done


dlugosc=${#linie_pliku[*]}
dlugosc=$(((dlugosc - 1) / 2))




	echo "\begin{table}" >> hello.tex
	if [ "$linie_pliku" = "A" ]; then
	    echo "\subsection{Dlugosc wykonywania testu A dla wszystkich permutacji}" >> hello.tex
	else
	    echo "\subsection{Dlugosc wykonywania testu B dla permutacji ${linie_pliku:2} elementowej}" >> hello.tex
	fi
	echo "\centering" >> hello.tex
	echo "\begin{tabular}{|c|c|}" >> hello.tex
	echo "\hline" >> hello.tex
	echo "Ilosc permutacji & Czas\\\\" >> hello.tex
	echo "\hline\hline" >> hello.tex
	rm input.txt
	for ((i=0;i<${dlugosc};i++));do
	    echo "${permutacje[$i]} & ${czasy[$i]} \\\\ " >> hello.tex
	    echo "${permutacje[$i]} ${czasy[$i]}" >> input.txt
	done
	echo "$j" >> input.txt
	./pnginator.sh
	echo "\hline" >> hello.tex
	echo "\end{tabular}" >> hello.tex
	echo "\end{table}" >> hello.tex
	echo "\vspace{-12pt}" >> hello.tex
	echo "\begin{figure}" >> hello.tex
	echo "\includegraphics[scale=0.4]{$j.png}" >> hello.tex
	echo "\centering" >> hello.tex
	echo "\end{figure}" >> hello.tex

j=$(($j+1))

rm $staty
done

last_line=$(sed -n "${lines}p" tmpFile.txt)
last_line=${last_line:2}
cp $last_line .
last_line=${last_line:20}

koniec=()

while read line; do
	koniec+=$line
done < $last_line

echo "Data ropoczecia skryptu : ${koniec[0]}\\\\" >> hello.tex
echo "Data zakonczenia skryptu: ${koniec[1]}\\\\" >> hello.tex
echo "Nazwa pliku configuracyjnego: ${koniec[2]}\\\\" >> hello.tex
echo "Folder zawierajacy pliki z poszczegolnych testow: ${koniec[3]}\\\\" >> hello.tex
echo "Folder, w ktorym jest tester: ${koniec[4]}\\\\" >> hello.tex
echo "Liczba testow: ${koniec[5]}\\\\" >> hello.tex
rm $last_line
echo "\end{document}" >> hello.tex

# Kompilacja pliku LaTeX do PDF
pdflatex hello.tex >> /dev/null

droga=${droga:0:20}
for ((a=0; a+1<$lines; a++)); do
mv $a.png $droga
done

