#!/bin/bash

chmod +x test.py
#Control Stage
Check=$(./test.py)
if [[ $Check != "ok" ]]; then
	echo "what"
	while true;
	do
		cat CheckFalse.txt
		read Install
		if [[ ${Install:0:1} == "y" || ${Install:0:1} == "Y" ]]; then
			cat text/Install.txt
			read OS
			if [[ "$OS" == 1 ]]; then
				yum install python3 -y
				break
			elif [[ "$OS" == 2 ]]; then
				apt install python3 -y
				break
			elif [[ "$OS" == 3 ]]; then
				cat text/InvalidOS.txt
				exit
			else
				cat text/InvalidInput.txt
			fi
		fi
	done	
fi


#Last Check
Check=$(./test.py)
if [[ $Check != "ok" ]]; then
	echo "what"
	cat text/NotSolvedProblem.txt
	exit
fi

#Welcome
cat text/Welcome.txt

read SecretName


mkdir -p temp
while true;
do
	cat text/DefaultPassword.txt
	read Confirm
	if [[ ${Confirm:0:1} == "y" || ${Confirm:0:1} == "Y" ]]; then
		while true;
		do
			cat text/SelectByte.txt
			read ByteNumber
			if [[ "$ByteNumber" -lt 1 || "$ByteNumber" -gt 128000 ]]; then
				cat text/InvalidByte.txt
			else
				echo $ByteNumber > temp/ByteNumber.txt
				break
			fi
		done
		break
	elif [[ ${Confirm:0:1} == "n" || ${Confirm:0:1} == "N" ]]; then
		break
	else
		cat text/InvalidInput.txt
	fi
done
ByteNumber=128
if test -f temp/ByteNumber.txt
then

	ByteNumber=$(cat temp/ByteNumber.txt)

fi

#permissions
chmod +x PasswordGenerator.py

password=$(python3 PasswordGenerator.py $ByteNumber)

printf $password | docker secret create $SecretName -
echo "Your secret ($SecretName) created!"
rm -rf temp