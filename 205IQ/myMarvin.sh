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
        # read -p "Display it ?(y/n): " display
        false=$((false+1))
        display = "y"
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

./205IQ > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 84" > intraRslt.txt
Test "No args" "myRslt.txt" "intraRslt.txt"

./205IQ 12 12 12 12 12 12 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 84" > intraRslt.txt
Test "Too much args" "myRslt.txt" "intraRslt.txt"

./205IQ a > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 84" > intraRslt.txt
Test "Invalid args - 1" "myRslt.txt" "intraRslt.txt"

./205IQ 12 a > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 84" > intraRslt.txt
Test "Invalid args - 2" "myRslt.txt" "intraRslt.txt"

./205IQ 12 12 a > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 84" > intraRslt.txt
Test "Invalid args - 3" "myRslt.txt" "intraRslt.txt"

./205IQ 12 12 2001 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 84" > intraRslt.txt
Test "Invalid args - 4" "myRslt.txt" "intraRslt.txt"

./205IQ 12 12 200 100 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 84" > intraRslt.txt
Test "Invalid args - too large qmin" "myRslt.txt" "intraRslt.txt"

./205IQ 12 12 100 300 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 84" > intraRslt.txt
Test "Invalid args - too large qmax" "myRslt.txt" "intraRslt.txt"

./205IQ 12 12 -1 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 84" > intraRslt.txt
Test "Invalid args - negative qmin" "myRslt.txt" "intraRslt.txt"

./205IQ 12 12 20 -1 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 84" > intraRslt.txt
Test "Invalid args - negative qmax" "myRslt.txt" "intraRslt.txt"

./205IQ -1 12 20 100 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 84" > intraRslt.txt
Test "Invalid args - negativ mu" "myRslt.txt" "intraRslt.txt"

./205IQ 201 12 20 200 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 84" > intraRslt.txt
Test "Invalid args - too large mu" "myRslt.txt" "intraRslt.txt"

./205IQ 100 15 > data
head -n 2 data > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 0" >> intraRslt.txt
echo -e "0 0.00000\n1 0.00000\nexit: 0" > intraRslt.txt
Test "Density function - 01" "myRslt.txt" "intraRslt.txt"

./205IQ 100 15 > data
head -n 120 data | tail -n 10 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 0" >> intraRslt.txt
echo -e "110 0.02130\n111 0.02033\n112 0.01931\n113 0.01827\n114 0.01721\n115 0.01613\n116 0.01506\n117 0.01399\n118 0.01295\n119 0.01192\nexit: 0" > intraRslt.txt
Test "Density function - 02" "myRslt.txt" "intraRslt.txt"

./205IQ 100 15 > data
tail -n 2 data > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 0" >> intraRslt.txt
echo -e "199 0.00000\n200 0.00000\nexit: 0" > intraRslt.txt
Test "Density function - 03" "myRslt.txt" "intraRslt.txt"

./205IQ 100 24 90 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 0" >> intraRslt.txt
echo -e "33.8% of people have an IQ inferior to 90\nexit: 0" > intraRslt.txt
Test "Percent q1" "myRslt.txt" "intraRslt.txt"

./205IQ 100 24 90 95 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 0" >> intraRslt.txt
echo -e "7.9% of people have an IQ between 90 and 95\nexit: 0" > intraRslt.txt
Test "Percent q2" "myRslt.txt" "intraRslt.txt"

echo -ne "${neutre}["
echo -ne "${bleufonce}===="
echo -ne "${neutre}] Synthesis: Tested: "
echo -e "${bleufonce}$nbrTest${neutre} | Passing: ${vertfonce}$ok${neutre} | Failing: ${rougefonce}$false${neutre}"
echo -ne "${neutre}["
echo -ne "${bleufonce}===="
echo -ne "${neutre}] Tot: "
echo -ne "${vertfonce}"
echo -ne 'print("%0.2f" % ('$ok/$nbrTest*100'), end="")' | python3
echo -e "%"

rm intraRslt.txt
rm myRslt.txt
rm data