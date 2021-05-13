#!/bin/bash

noir='\e[0;30m'
gris='\e[1;30m'
rougefonce='\e[0;31m'
rose='\e[1;31m'
vertfonce='\e[0;32m'
vertclair='\e[1;32m'
orange='\e[0;33m'
jaune='\e[1;33m'
bleufonce='\e[0;34m'
bleuclair='\e[1;34m'
violetfonce='\e[0;35m'
violetclair='\e[1;35m'
cyanfonce='\e[0;36m'
cyanclair='\e[1;36m'
grisclair='\e[0;37m'
blanc='\e[1;37m'
neutre='\e[0;m'
ok=0
false=0
nbrTest=0

if [ "$1" = "--help" ]
then
    echo -ne "${cyanclair}"
    printf "Usage:\n"
    echo -ne "\e[3m\t(at your root)\e[0m"
    echo -ne "${cyanclair}"
    printf "./myMarvin.sh | column -t -s $'\\\t' \n"
    exit 0
fi

Test()
{
    testTitle="$1"
    myRslt="$2"
    expectedRslt="$3"
    diff $myRslt $expectedRslt > trace.txt

    echo -ne "${jaune}$testTitle:"
    if [ -s trace.txt ]
    then
        echo -e "\t${rougefonce}FALSE  ✗"
        echo -ne "${neutre}"
        read -p "Display it ?(y/n): " display
        false=$((false+1))
        if [ "$display" = "y" ]
        then
            cat trace.txt | cat -e
        fi
    else
        echo -e "\t${vertclair}OK 🗸"
        rm trace.txt 2>/dev/null
        ok=$((ok+1))
    fi
    nbrTest=$((nbrTest+1))
}

clear

./208dowels > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 84" > intraRslt.txt
Test "No args" "myRslt.txt" "intraRslt.txt"

./208dowels 6 4 10 18 20 19 11 5 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 84" > intraRslt.txt
Test "Not enough args" "myRslt.txt" "intraRslt.txt"

./208dowels a 4 10 18 20 19 11 5 7 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 84" > intraRslt.txt
Test "Bad arg small" "myRslt.txt" "intraRslt.txt"

./208dowels 6 4 10 18 b 19 11 5 7 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 84" > intraRslt.txt
Test "Bad arg random" "myRslt.txt" "intraRslt.txt"

./208dowels 6 4 10 18 20 19 11 5 7 > myRslt.txt
echo -e "   x    | 0-1   | 2     | 3     | 4     | 5     | 6     | 7+    | Total\n  Ox    | 10    | 10    | 18    | 20    | 19    | 11    | 12    | 100\n  Tx    | 8.0   | 13.8  | 19.2  | 19.9  | 16.3  | 11.1  | 11.7  | 100\nDistribution:           B(100, 0.0410)\nChi-squared:            2.029\nDegrees of freedom:     5\nFit validity:           80% < P < 90%" > intraRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 0" >> intraRslt.txt
Test "Basic 01" "myRslt.txt" "intraRslt.txt"

./208dowels 6 4 10 8 20 19 11 5 17 > myRslt.txt
echo -e "   x    | 0-1   | 2-3   | 4     | 5     | 6-7   | 8+    | Total\n  Ox    | 10    | 18    | 20    | 19    | 16    | 17    | 100\n  Tx    | 5.2   | 26.7  | 19.1  | 17.7  | 22.2  | 9.0   | 100\nDistribution:           B(100, 0.0460)\nChi-squared:            16.119\nDegrees of freedom:     4\nFit validity:           P < 1%" > intraRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 0" >> intraRslt.txt
Test "Basic 02" "myRslt.txt" "intraRslt.txt"

./208dowels 4 5 13 19 20 16 12 7 4 > myRslt.txt
echo -e "   x    | 0-2   | 3     | 4     | 5     | 6     | 7+    | Total\n  Ox    | 22    | 19    | 20    | 16    | 12    | 11    | 100\n  Tx    | 23.1  | 19.7  | 19.9  | 16.0  | 10.6  | 10.7  | 100\nDistribution:           B(100, 0.0401)\nChi-squared:            0.270\nDegrees of freedom:     4\nFit validity:           P > 99%" > intraRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 0" >> intraRslt.txt
Test "Basic 03" "myRslt.txt" "intraRslt.txt"

echo -ne "${neutre}["
echo -ne "${bleufonce}===="
echo -ne "${neutre}] Synthesis: Tested: "
echo -e "${bleufonce}$nbrTest${neutre} | Passing: ${vertfonce}$ok${neutre} | Failing: ${rougefonce}$false${neutre}"
echo -ne "${neutre}["
echo -ne "${bleufonce}===="
echo -ne "${neutre}] Tot: "
echo -ne "${vertfonce}"
echo -ne 'print("%0.2f" % ('$ok/$nbrTest*100'), end="")' | python3
# echo "print('{0:.2f}'.format($ok/$nbrTest*100))" | python
echo -e "%"

rm intraRslt.txt
rm myRslt.txt
