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

    echo -ne "${jaune}Test $testTitle:"
    if [ -s trace.txt ]
    then
        echo -e "\t${rougefonce}FALSE  ✗"
        echo -ne "${neutre}"
        read -p "Display it ?(y/n): " display
        if [ "$display" = "y" ]
        then
            cat trace.txt
        fi
    else
        echo -e "\t${vertclair}PASSED 🗸"
        rm trace.txt 2>/dev/null
    fi
}

clear

./204ducks > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 84" > intraRslt.txt
Test "No args" "myRslt.txt" "intraRslt.txt"

./204ducks "-14" > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 84" > intraRslt.txt
Test "Invalide args - Negative" "myRslt.txt" "intraRslt.txt"

./204ducks "aaaaaa" > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "exit: 84" > intraRslt.txt
Test "Invalide args - NoDigit" "myRslt.txt" "intraRslt.txt"

./204ducks "0" > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "Average return time: 0m 45s\nStandard deviation: 0.559\nTime after which 50% of the ducks are back: 0m 37s\nTime after which 99% of the ducks are back: 2m 39s\nPercentage of ducks back after 1 minute: 74.8%\nPercentage of ducks back after 2 minutes: 96.4%\nexit: 0" > intraRslt.txt
Test "0" "myRslt.txt" "intraRslt.txt"

./204ducks "1" > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "Average return time: 1m 07s\nStandard deviation: 0.960\nTime after which 50% of the ducks are back: 0m 51s\nTime after which 99% of the ducks are back: 4m 37s\nPercentage of ducks back after 1 minute: 57.4%\nPercentage of ducks back after 2 minutes: 85.6%\nexit: 0" > intraRslt.txt
Test "1" "myRslt.txt" "intraRslt.txt"

./204ducks 1.6 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "Average return time: 1m 21s\nStandard deviation: 1.074\nTime after which 50% of the ducks are back: 1m 04s\nTime after which 99% of the ducks are back: 5m 04s\nPercentage of ducks back after 1 minute: 46.9%\nPercentage of ducks back after 2 minutes: 79.1%\nexit: 0" > intraRslt.txt
Test "1.6" "myRslt.txt" "intraRslt.txt"

./204ducks 0.2 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "Average return time: 0m 50s\nStandard deviation: 0.676\nTime after which 50% of the ducks are back: 0m 39s\nTime after which 99% of the ducks are back: 3m 16s\nPercentage of ducks back after 1 minute: 71.3%\nPercentage of ducks back after 2 minutes: 94.2%\nexit: 0" > intraRslt.txt
Test "0.2" "myRslt.txt" "intraRslt.txt"

./204ducks 1.76 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "Average return time: 1m 25s\nStandard deviation: 1.094\nTime after which 50% of the ducks are back: 1m 08s\nTime after which 99% of the ducks are back: 5m 10s\nPercentage of ducks back after 1 minute: 44.1%\nPercentage of ducks back after 2 minutes: 77.4%\nexit: 0" > intraRslt.txt
Test "1.76" "myRslt.txt" "intraRslt.txt"

./204ducks 2.42 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "Average return time: 1m 39s\nStandard deviation: 1.142\nTime after which 50% of the ducks are back: 1m 24s\nTime after which 99% of the ducks are back: 5m 29s\nPercentage of ducks back after 1 minute: 32.6%\nPercentage of ducks back after 2 minutes: 70.2%\nexit: 0" > intraRslt.txt
Test "2.42" "myRslt.txt" "intraRslt.txt"

./204ducks 2.42 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "Average return time: 1m 39s\nStandard deviation: 1.142\nTime after which 50% of the ducks are back: 1m 24s\nTime after which 99% of the ducks are back: 5m 29s\nPercentage of ducks back after 1 minute: 32.6%\nPercentage of ducks back after 2 minutes: 70.2%\nexit: 0" > intraRslt.txt
Test "2.42" "myRslt.txt" "intraRslt.txt"

./204ducks 2 > myRslt.txt
echo -e "exit: $?" >> myRslt.txt
echo -e "Average return time: 1m 30s\nStandard deviation: 1.118\nTime after which 50% of the ducks are back: 1m 14s\nTime after which 99% of the ducks are back: 5m 18s\nPercentage of ducks back after 1 minute: 40.0%\nPercentage of ducks back after 2 minutes: 74.8%\nexit: 0" > intraRslt.txt
Test "2.42" "myRslt.txt" "intraRslt.txt"

rm intraRslt.txt
rm myRslt.txt