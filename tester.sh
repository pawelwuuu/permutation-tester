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

#configuration of permutation gen
if [ -e ./permutations/build ]
then
	rm -r ./permutations/build
	if [[ $? != 0 ]]
	then
		echo "Unable to reinstall permutations build folder, probably lack of permissions."
		exit 3
	fi
fi
mkdir ./permutations/build
cd ./permutations/build
cmake .. >> /dev/null
make >> /dev/null
if [[ $? != 0 ]]
then
	echo "Cannot build project."
	exit 4
else
	echo "Permutations project build succesful."
fi
chmod 777 ../pdfGenerator.sh
chmod 777 ../subsectionGenerator.sh
cd ..
cd ..

#checking if file ends with empty line character
fileContent=`cat -e $filename`
if [[ ${fileContent: -1} != '$' ]]; then
    echo "Invalid configuration parameters, there should be an empty line at the end of file."
    exit 5
fi

#loading parameters to arrays: setLength and permutationsAmount.
characters=($(cat $filename))
for (( i=0; i<${#characters[@]}; i++ ))
do
	if [[ $i -eq 0 ]]
	then
		numOfLines=`wc -l $filename | grep -Po "\\d+"`
		let numOfLines++
		let "requirdeNumLines = characters[0] * 2 + 2"

		if ! [[ $numOfLines -eq $requirdeNumLines ]]
		then
			echo "Incorrect number of lines in config file"
			exit 6
		fi
	fi

	
	
done