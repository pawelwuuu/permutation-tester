#!/bin/bash

filename=$1
startTime=`date +"%Y.%m.%d %H:%M:%S"`

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

#checking if first line is number and if there is enough lines of data in file
fistLine=`head -n 1 $filename`

if ! echo "$fistLine" | grep -Eq '^[0-9]+$'; then
    echo "First line must be a number of tests aplied."
	exit 6
fi

numOfLines=`wc -l $filename | grep -Po "\\d+"`
let numOfLines++
let "requirdeNumLines = fistLine * 2 + 2"

if ! [[ $numOfLines -eq $requirdeNumLines ]]
then
	echo "Incorrect number of lines in config file"
	exit 7
fi

#loading parameters and validating them
IFS=$'\n' read -d '' -r -a lines < $filename

#creating logs file if does not exist
if ! [[ -e ./logs ]]
then
	mkdir logs
	if (( $? != 0 ))
	then
		echo "Unable to create logs folder."
		exit 10
	fi
fi

#creating folder id and folder inside logs folder
folderIdentifier=$(date +"%Y%m%d%H%M%S")
folderRelPath="./logs/$folderIdentifier"
if [[ -e $folderRelPath ]]
then
	echo "Unable to create test folder."
	exit 11
fi
mkdir $folderRelPath

#creating temp file which contain relative paths to times
if [[ -e tmpFile.txt ]]
then
	rm tmpFile.txt
	touch tmpFile.txt
fi

#creating config file for general document
generalPrmCfgPath="`pwd`/permutations/general.cfg"
if [[ -e $generalPrmCfgPath ]]
then
	rm $generalPrmCfgPath
	touch $generalPrmCfgPath
else
	touch $generalPrmCfgPath
fi

if (( $? != 0 ))
then
	echo "Problem with pemutations general parameters file."
	exit 15
fi


generatorCfgRel="./permutations/config.cfg"
echo "Testing..."
for (( i=0; i<${#lines[@]}; i++ ));
do
	if (( $i % 2 != 0 ))
	then
		if echo "${lines[$i]}" | grep -Eq '^A$'
		then
			#test of type A
			let "parTestA = i + 1"
    		if echo "${lines[$parTestA]}" | grep -Eq '^[0-9]+([ ]+[0-9]+)*$'
			then
				#creating config file for generator
				if [[ -e $generatorCfgRel ]]
				then
					rm $generatorCfgRel
				fi
				touch $generatorCfgRel

				#creating txt file with times
				fileRelPath="$folderRelPath/A$i"
				touch $fileRelPath
				if (( $? != 0 ))
				then
					echo "Unable to create times file."
					exit 12
				fi

				#appending data about type of test
				echo "A" >> $fileRelPath

				#appending params to config file and launching generator
				params=(${lines[$parTestA]})
				for param in "${params[@]}"
				do
					echo "$param 0" > $generatorCfgRel
					echo "$param 0" >> $generalPrmCfgPath

					echo $param >> $fileRelPath
					cd ./permutations
					/usr/bin/time -ao ../$fileRelPath -f "%e" ./pdfGenerator.sh ./config.cfg >> /dev/null
					if (( $? != 0 ))
					then
						echo "Error durring creation of pdf occurred."
						rm -rf $folderRelPath
						exit 10
					fi
					cd ..

				done
				#appending information about localisation of log file
				echo $fileRelPath >> tmpFile.txt
			else
				let parTestA++
    			echo "Error in line $parTestA of config file, such syntax of test does not exist."
				exit 8
			fi
		elif echo "${lines[$i]}" | grep -Eq '^B [0-9]+$'
		then
    		#test of type B
			let "parTestB = i + 1"
    		if echo "${lines[$parTestB]}" | grep -Eq '^[0-9]+([ ]+[0-9]+)*$'
			then
				#creating txt file with times
				fileRelPath="$folderRelPath/B$i"
				touch $fileRelPath
				if (( $? != 0 ))
				then
					echo "Unable to create times file."
					exit 12
				fi

				#appending params to config file and launching generator
				bDefinition=(${lines[$i]})
				permutationSize=${bDefinition[1]}
				params=(${lines[$parTestB]})

				#appending data about type of test
				echo "B $permutationSize" >> $fileRelPath
				for param in "${params[@]}"
				do
					echo "$permutationSize $param" > $generatorCfgRel
					echo "$permutationSize $param" >> $generalPrmCfgPath
					echo "$param" >> $fileRelPath

					cd ./permutations
					/usr/bin/time -ao ../$fileRelPath -f "%e" ./pdfGenerator.sh ./config.cfg >> /dev/null
					if (( $? != 0 ))
					then
						echo "Error durring creation of pdf occurred."
						rm -rf $folderRelPath
						exit 10
					fi
					cd ..
				done
				#appending information about localisation of log file
				echo $fileRelPath >> tmpFile.txt
			else
				let parTestB++
    			echo "Error in line $parTestB of config file, such syntax of test does not exist."
				exit 8
			fi
		else
			echo "Error in line $i of config file, such syntax of test does not exist."
			#todo add removing tmp files
			exit 9
		fi
	fi
done

#generating pdf document with whole permutations and moving it to folder path
echo "Generating master pdf document..."
cd ./permutations
./pdfGenerator.sh $generalPrmCfgPath >> /dev/null
cd ..
if (( $? != 0 ))
then
	echo "Error durring creation of pdf occurred."
	rm -rf $folderRelPath
	exit 10
fi
mv -f ./permutations/generatedPdf/ $folderRelPath


endTime=`date +"%Y.%m.%d %H:%M:%S"`

#generating file with general information
generalLogRelPath="$folderRelPath/general.txt"
if (( $? != 0 ))
then
	echo "Cannot create general log file."
	rm -rf $folderRelPath
fi

#appending data to general log file
echo $startTime >> $generalLogRelPath
echo $endTime >> $generalLogRelPath
echo $1 >> $generalLogRelPath
cd $folderRelPath
echo `pwd` >> ../../$generalLogRelPath
cd ../..
echo `pwd` >> $generalLogRelPath
echo $fistLine >> $generalLogRelPath
echo "`pwd`/permutations/generatedPdf/" >> $generalLogRelPath
echo $folderRelPath >> $generalLogRelPath

echo $generalLogRelPath >> tmpFile.txt

#info about logs
cd $folderRelPath
echo "Logs are saved in: `pwd`."
cd ..
cd ..

#stating igors and karbowsky script
#./skrypt.sh ./tmpFile.txt

