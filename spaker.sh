#!/bin/bash
dpkg -l | grep linux-image | awk '{print$2}' | grep -vwE linux-image-"generic|$(uname -r)" > temp.tmp

echo "Καλώς ήρθατε στο SpaKeR (Spare Kernel Remover)"
echo "----------------------------------------------"
while true 
do
num=0 
	while IFS= read -r line
	do
		num=$(( $num + 1 ))
		echo "["$num"]" $line
	done < "temp.tmp"
echo "----------------------------------------------"


read -rp "Διαλέξτε Πυρήνα για αφαίρεση (Q/q για έξοδο): " input

	if [[ $input = "q" ]] || [[ $input = "Q" ]] 
	   	then
		rm temp.tmp
		echo "Έξοδος..."
		tput cnorm   -- normal  # Εμφάνιση cursor
		exit 0
	fi

	if [ $input -gt 0 -a $input -le $num ]; #έλεγχος αν το input είναι μέσα στο εύρος της λίστας των σταθμών
		then
		kernel=$(cat temp.tmp | head -n$(( $input )) | tail -n1 | cut -d "," -f1)
		echo "Επιλέξατε για αφαίρεση τον πυρήνα $kernel"
		sudo apt remove -y --purge $kernel && sudo apt autoclean && sudo apt autoremove	&& echo "Επιτυχής αφαίρεση πυρήνα"
		rm temp.tmp
		sudo update-grub	
		break

		else
		echo -e "Αριθμός εκτός λίστας"
		# sleep 2
		clear
		echo "----------------------------------------------"
		
	fi
done
