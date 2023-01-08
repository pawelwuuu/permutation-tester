#!/bin/bash
IFS=$'\n' read -d '' -r -a permutations < $1
originalPermutation=${permutations[-1]}
setLength=$2

echo "\sloppy \textbf{Główna permutacja to $originalPermutation}" >> ./generatedPdf/sketch.tex

for ((i=0; i<${#permutations[@]}-1; i++))
do
    echo "\subsection{${permutations[i]}}" >> ./generatedPdf/sketch.tex

    if [[ $setLength -gt 45 ]]
    then
        echo "\begin{longtable}{ |p{4.5cm}|p{12.5cm}| }" >> ./generatedPdf/sketch.tex
    else
        echo "\begin{tabular}{ |p{4.5cm}|p{12.5cm}| }" >> ./generatedPdf/sketch.tex
    fi
    echo  "\hline" >> ./generatedPdf/sketch.tex

    echo  "Rząd permutacji & `./build/orderOfPermutations $originalPermutation ${permutations[i]}` \\\\"  >> ./generatedPdf/sketch.tex 
    echo  "\hline" >> ./generatedPdf/sketch.tex

    echo  "Notacja cykliczna & `./build/cycleNotation $originalPermutation ${permutations[i]}` \\\\"  >> ./generatedPdf/sketch.tex 
    echo  "\hline" >> ./generatedPdf/sketch.tex

    echo "Kwadrat permutacji & `./build/permutationSquare $originalPermutation ${permutations[i]}` \\\\" >> ./generatedPdf/sketch.tex
    echo  "\hline" >> ./generatedPdf/sketch.tex
    
    echo "Liczba inwersji & `./build/numberOfInversions $originalPermutation ${permutations[i]}` \\\\" >> ./generatedPdf/sketch.tex
    echo  "\hline" >> ./generatedPdf/sketch.tex

    echo "Inwersje permutacji & `./build/permutationIversions $originalPermutation ${permutations[i]}` \\\\" >> ./generatedPdf/sketch.tex
    echo  "\hline" >> ./generatedPdf/sketch.tex

    echo "Parzystość permutacji & `./build/permutationEveness $originalPermutation ${permutations[i]}` \\\\" >> ./generatedPdf/sketch.tex
    echo  "\hline" >> ./generatedPdf/sketch.tex

    if [[ $setLength -gt 45 ]]
    then
        echo "\end{longtable}" >> ./generatedPdf/sketch.tex
    else
        echo "\end{tabular}" >> ./generatedPdf/sketch.tex
    fi
done