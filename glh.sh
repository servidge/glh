#!/bin/bash
# glh - genua log helper oder genua little helper 
# Shell Script zum Arbeiten mit Syslogs von Genugate Firewalls. 
#
# Teil von https://github.com/servidge/glh
# äöüß
#
OIFS=$IFS
STARTSPALTE=8
SPALTEQUEL=9
SPALTEZIEL=10
PROTOSPAL=0
TYPESPAL=0
IFS=' '

FILE=$1
test -z $FILE && echo "Kein Parameter angegeben. Aufruf: $0 <<Dateiname>> " && exit
if [ ! -f $FILE ]; then
        echo "Datei nicht gefunden!"
        exit
fi

echo "Datei: $FILE"
echo "STARTSPALTE: $STARTSPALTE"
echo "SPALTEQUEL: $SPALTEQUEL"
echo "SPALTEZIEL: $SPALTEZIEL"

while read ZEILE 
do
	if [[ $ZEILE = *"ipfw_log"* ]] && [[ $ZEILE != *"messages dropped"* ]]; then
		#echo $ZEILE
		ZEIT=`echo $ZEILE | cut -d":" -f1-3`
		counter=1
		for SPALTE in $ZEILE
			do
			if [[ ${counter} -gt ${STARTSPALTE} ]]; then
				if [[ ${counter} -eq ${SPALTEQUEL} ]]; then
						spaltlen=${#SPALTE}
						ausgabe=$((0x${SPALTE:0:2})).$((0x${SPALTE:2:2})).$((0x${SPALTE:4:2})).$((0x${SPALTE:6:2}))" "$((${SPALTE:9:$spaltlen-10}))
						OUTPUT=$OUTPUT" "$ausgabe 
				fi
				if [[ ${counter} -eq ${SPALTEZIEL} ]]; then
						spaltlen=${#SPALTE}
						ausgabe=$((0x${SPALTE:0:2})).$((0x${SPALTE:2:2})).$((0x${SPALTE:4:2})).$((0x${SPALTE:6:2}))" "$((${SPALTE:9:$spaltlen-10}))
						OUTPUT=$OUTPUT" "$ausgabe 
				fi
				if [[ $SPALTE = "proto" ]]; then
					PROTOSPAL=$((counter+1))
				fi
				if [[ ${counter} -eq $PROTOSPAL ]]; then
					if [[ $SPALTE -eq "1" ]]; then
						OUTPUT="ICMP "$OUTPUT
					elif [[ $SPALTE -eq "6" ]]; then
						OUTPUT="TCP "$OUTPUT
					elif [[ $SPALTE -eq "17" ]]; then
						OUTPUT="UDP "$OUTPUT
					elif  [[ $SPALTE -eq "50" ]]; then
						OUTPUT="ESP "$OUTPUT
					elif [[ $SPALTE -eq "51" ]]; then
						OUTPUT="AH "$OUTPUT
					else
						eOUTPUT="UNBEKANNTESproto "$OUTPUT
					fi
				fi
				if [[ $SPALTE = "type" ]]; then
				        TYPESPAL=$((counter+1))
				fi 
				if [[ ${counter} -eq $TYPESPAL ]]; then
					if [[ $SPALTE -eq "8" ]]; then
						OUTPUT=$OUTPUT" ""ping"
					elif [[ $SPALTE -eq "0" ]]; then
						OUTPUT=$OUTPUT" ""reply"
					elif [[ $SPALTE -eq "3" ]]; then
						OUTPUT=$OUTPUT" ""unreeach "
					else
						OUTPUT=$OUTPUT" ""type??"
					fi
				fi 
			fi
			((counter++))
		done
	elif [[ $ZEILE = *"tcp_probe"* ]] && [[ $ZEILE != *"messages dropped"* ]] ; then
		#echo $ZEILE
		ZEIT=`echo $ZEILE | cut -d":" -f1-3`
		counter=1
		for SPALTE in $ZEILE
			do
			
			((counter++))
		done
	elif [[ $ZEILE = *"udp_probe"* ]] && [[ $ZEILE != *"messages dropped"* ]] ; then
		#echo $ZEILE
		ZEIT=`echo $ZEILE | cut -d":" -f1-3`
		counter=1
		for SPALTE in $ZEILE
			do
			
			((counter++))
			done
	fi
PROTOSPAL=0
TYPESPAL=0
[ "$OUTPUT" ] && echo $ZEIT" "ipfw_log" "$OUTPUT
OUTPUT=""
done < $FILE

IFS=$OIFS
