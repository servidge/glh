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
	if [[ $ZEILE = *"ipfw_log"* ]]; then
		#echo $ZEILE
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
			fi
			((counter++))
		done
	fi
[ "$OUTPUT" ] && echo $OUTPUT
OUTPUT=""
done < $FILE

IFS=$OIFS
