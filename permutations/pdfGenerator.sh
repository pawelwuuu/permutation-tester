#!/bin/bash

filename=$1
#checking if configuration file exists
if [[ -n "$1" ]]
then
    if ! [ -e $filename ]
		then
			echo "Unable to find or open configuration file."
			exit 1
		fi
else
    echo "You have forgotten about config filename."
    exit 2
fi


setLength=()
permutationsAmount=()

#loading parameters to arrays: setLength and permutationsAmount.
while read line; do
    #parameters is an array that stores splited parameters from read
    #line e.g line (2 5) and line (8 6) will be stored in
    #parameters array like that [2, 5, 8, 6].
    parameters=()
    numberOfParamInLine=0
    for value in $line; do
        parameters+=($value)
        let numberOfParamInLine++
    done

    #checking if number of parameters in line are in number of two
    if ! [[ numberOfParamInLine -eq 2 ]]
    then
        echo "There are more or less parameters than 2 in config file."
        exit 14
    fi

    setLength+=(${parameters[0]})
    permutationsAmount+=(${parameters[1]})
done < $filename

#Validating parameters
#checking if file ends with empty line character
fileContent=`cat -e $filename`
if [[ ${fileContent: -1} != '$' ]]; then
    echo "Invalid configuration parameters, there should be an empty line at the end of file."
    exit 3
fi

#checking if there is enough parameters
if ! [[ ${#setLength[@]} -eq ${#permutationsAmount[@]} ]]
then
	echo "Invalid number of parameters, it should be in 1-1 ratio."
	exit 4
fi

#checking if parameters are numbers
numRegex='^[0-9]+$'
for parameter in ${setLength[@]}
do
    if ! [[ $parameter =~ $numRegex ]] ; then
        echo "Invalid configuration parameters, there should be only numbers in config file. Wrong parameter is: $parameter"
        exit 5
    fi
done

for parameter in ${permutationsAmount[@]}
do
    if ! [[ $parameter =~ $numRegex ]] ; then
        echo "Invalid configuration parameters, there should be only numbers in config file. Wrong parameter is: $parameter"
        exit 6
    fi
done

#checking if numbers are positive
for parameter in ${setLength[@]}
do
    if [ $parameter -lt 0 ] ; then
        echo "Invalid configuration parameters, there should be only positive numbers in config file."
        exit 7
    fi
done

for parameter in ${permutationsAmount[@]}
do
    if [ $parameter -lt 0 ] ; then
        echo "Invalid configuration parameters, there should be only positive numbers in config file."
        exit 8
    fi
done

#checking if set lenght parameters are in limit of 60
for parameter in ${setLength[@]}
do
    if [[ $parameter -gt 60 ]] ; then
        echo "Invalid configuration parameters, limit of set length is 60."
        exit 9
    fi
done



#array of required files
req_files=("subsectionGenerator.sh" "build" "build/permutations" "build/cycleNotation" "build/permutationIversions" "build/numberOfInversions" "build/permutationLimitChecker" "build/permutationEveness" "build/permutationSquare" "build/orderOfPermutations")

#testing if required files exist
for req_file in ${req_files[@]}
do
    if ! [ -a $req_file ] ; then
        echo "Error! $req_file is missing. Check if that file exists, otherwise use make command in build folder."
        exit 10
    fi
done

#checking if args.tmp exists
if [ -a ./args.tmp ] ; then
        rm args.tmp
fi

#checking if permutations amount is in range of permutations avalible to obtain
for ((j=0; j<${#setLength[@]}; j++))
do
    possibleToObtain=`./build/permutationLimitChecker ${setLength[$j]} ${permutationsAmount[$j]}`
	if [ $possibleToObtain = "F" ]
	then
		echo "Invalid configuration parameters, you can only obtain  permutations from ${setLength[$j]} an element set."
        exit 11
	fi
done


#creation of pdf
rm -r ./generatedPdf
mkdir generatedPdf
touch ./generatedPdf/sketch.tex

#strcuture of latex
echo "Creating pdf in progress..."
echo "\documentclass{article}" >> ./generatedPdf/sketch.tex
echo "\usepackage[T1]{fontenc}" >> ./generatedPdf/sketch.tex
echo "\usepackage[legalpaper, margin=1.2in]{geometry}" >> ./generatedPdf/sketch.tex
echo "\usepackage{longtable}" >> ./generatedPdf/sketch.tex
echo "\begin{document}" >> ./generatedPdf/sketch.tex

for ((i=0; i<${#setLength[@]}; i++))
do
    #CREATING FILE TO STORE ARGUMENTS
    touch args.tmp

	if [ ${permutationsAmount[$i]} -eq 0 ]
	then
        if [ ${setLength[$i]} -gt 19 ]; then
            echo "Option to generate all permutations is avaliable only for sets consist of 19 and below length. Generation canceled."
            rm args.tmp
            rm -r generatedPdf
            exit 12
        fi
		echo "\section{Wszystkie permutacje zbioru ${setLength[$i]}-elementowego}" >> ./generatedPdf/sketch.tex
        echo "`./build/permutations ${setLength[$i]} A`" >> args.tmp
        echo "" >> args.tmp
        ./subsectionGenerator.sh args.tmp ${setLength[$i]}
	else
		echo "\section{Zbiór ${setLength[$i]}-elementowy zawierający permutacje w ilości ${permutationsAmount[$i]}}" >> ./generatedPdf/sketch.tex
        echo "`./build/permutations ${setLength[$i]} ${permutationsAmount[$i]}`" >> args.tmp
        echo "" >> args.tmp
        ./subsectionGenerator.sh args.tmp ${setLength[$i]}
	fi
	
	sleep 0.5
    echo "Chapter $(( $i+1 )) generated."

    #DELETING FILE TO STORE ARGUMENTS
    rm args.tmp
done

#strcuture of latex
echo "\end{document}" >> ./generatedPdf/sketch.tex


pdflatex  -output-directory=generatedPdf -jobname="Generated PDF" --interaction=batchmode ./generatedPdf/sketch.tex > /dev/null

echo "Success! Generated file is in generatedPdf folder."
exit 0