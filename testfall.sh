#!/bin/bash
# 
# Testfall für Loghelper für Syslogmeldungen vom GenuaALG
# trial and error oder Stochern im Trüben 
# Logs bestehen Blöcken zu je 8 Stellen in hex bsp: 08080808 oder deadbeef
#
# Teil von https://github.com/servidge/glh
# 
testwert=$1
echo "######################################################################"
echo "Verwendung von $testwert"
echo "##"
echo "Als ein Wert"
echo $((0x${testwert}))
echo "##"
echo "Immer 1 Stelle"
echo $((0x${testwert:0:1}))
echo $((0x${testwert:1:1}))
echo $((0x${testwert:2:1}))
echo $((0x${testwert:3:1}))
echo $((0x${testwert:4:1}))
echo $((0x${testwert:5:1}))
echo $((0x${testwert:6:1}))
echo $((0x${testwert:7:1}))
echo "##"
echo "Immer 2 Stellen"
echo $((0x${testwert:0:2}))
echo $((0x${testwert:2:2}))
echo $((0x${testwert:4:2}))
echo $((0x${testwert:6:2}))
echo "##"
echo "Erste 3 Stellen"
echo $((0x${testwert:0:3}))
echo "##"
echo "Mittleren 2 Stellen"
echo $((0x${testwert:3:2}))
echo "##"
echo "Letzten 3 Stellen"
echo $((0x${testwert:5:3}))
echo "##"
echo "Erste 4 Stellen"
echo $((0x${testwert:0:4}))
echo "##"
echo "Letzten 4 Stellen"
echo $((0x${testwert:4:4}))
echo "##"
