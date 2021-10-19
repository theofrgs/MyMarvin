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
    echo -e -n "${cyanclair}"
    printf "Usage:\n"
    echo -e -n "\e[3m\t(at your root)\e[0m"
    echo -e -n "${cyanclair}"
    printf "./myMarvin.sh | column -t -s $'\\\t' \n"
    exit value 0
fi

Test()
{
    testTitle="$1"
    myRslt="$2"
    expectedRslt="$3"
    diff $myRslt $expectedRslt > trace.txt

    echo -e -n "${jaune}$testTitle:"
    if [ -s trace.txt ]
    then
        echo -e "\t${rougefonce}FALSE  ✗"
        echo -e -n "${neutre}"
        # read -p "Display it ?(y/n): " display
        false=$((false+1))
        display="y"
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

./303Make > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "No args" "myRslt.txt" "intraRslt.txt"

./303Make loremp > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad file" "myRslt.txt" "intraRslt.txt"

./303Make loremp erg rgt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Too many args" "myRslt.txt" "intraRslt.txt"

# echo -e "Jesus is friends with Chuck Norris\nCindy Crawford is friends with Nicole Kidman\nV is friends with Barack Obama\nChuck Norris is friends with Barack Obama\nV is friends with François Hollande\nPenelope Cruiz is friends with Tom Cruise\nNicole Kidman is friends with Tom Cruise\nKatie Holmes is friends with Tom Cruise\nSim is friends with Lara Croft\nSim is friends with Chuck Norris\nLara Croft is friends with V\nYvette Horner is friends with Sim\nFrançois Hollande is friends with Barack Obama\nSim is friends with Jesus\nTom Cruise is friends with Barack Obama" > input.txt
# echo -e "Barack Obama\nChuck Norris\nCindy Crawford\nFrançois Hollande\nJesus\nKatie Holmes\nLara Croft\nNicole Kidman\nPenelope Cruiz\nSim\nTom Cruise\nV\nYvette Horner\n\n0 1 0 1 0 0 0 0 0 0 1 1 0\n1 0 0 0 1 0 0 0 0 1 0 0 0\n0 0 0 0 0 0 0 1 0 0 0 0 0\n1 0 0 0 0 0 0 0 0 0 0 1 0\n0 1 0 0 0 0 0 0 0 1 0 0 0\n0 0 0 0 0 0 0 0 0 0 1 0 0\n0 0 0 0 0 0 0 0 0 1 0 1 0\n0 0 1 0 0 0 0 0 0 0 1 0 0\n0 0 0 0 0 0 0 0 0 0 1 0 0\n0 1 0 0 1 0 1 0 0 0 0 0 1\n1 0 0 0 0 1 0 1 1 0 0 0 0\n1 0 0 1 0 0 1 0 0 0 0 0 0\n0 0 0 0 0 0 0 0 0 1 0 0 0\n\n0 1 3 1 2 2 2 2 2 2 1 1 3\n1 0 0 2 1 3 2 3 3 1 2 2 2\n3 0 0 0 0 3 0 1 3 0 2 0 0\n1 2 0 0 3 3 2 3 3 3 2 1 0\n2 1 0 3 0 0 2 0 0 1 3 3 2\n2 3 3 3 0 0 0 2 2 0 1 3 0\n2 2 0 2 2 0 0 0 0 1 3 1 2\n2 3 1 3 0 2 0 0 2 0 1 3 0\n2 3 3 3 0 2 0 2 0 0 1 3 0\n2 1 0 3 1 0 1 0 0 0 3 2 1\n1 2 2 2 3 1 3 1 1 3 0 2 0\n1 2 0 1 3 3 1 3 3 2 2 0 3\n3 2 0 0 2 0 2 0 0 1 0 3 0" > intraRslt.txt
# ./303Make input.txt 3 > myRslt.txt
# echo -e "exit value: $?" >> myRslt.txt
# echo -e "exit value: 0" >> intraRslt.txt
# Test "exmple 3" "myRslt.txt" "intraRslt.txt"

# echo -e "Jesus is friends with Chuck Norris\nCindy Crawford is friends with Nicole Kidman\nV is friends with Barack Obama\nChuck Norris is friends with Barack Obama\nV is friends with François Hollande\nPenelope Cruiz is friends with Tom Cruise\nNicole Kidman is friends with Tom Cruise\nKatie Holmes is friends with Tom Cruise\nSim is friends with Lara Croft\nSim is friends with Chuck Norris\nLara Croft is friends with V\nYvette Horner is friends with Sim\nFrançois Hollande is friends with Barack Obama\nSim is friends with Jesus\nTom Cruise is friends with Barack Obama" > input.txt
# echo -e "Degree of separation between Yvette Horner and Barack Obama: 3" > intraRslt.txt
# ./303Make input.txt "Yvette Horner" "Barack Obama" > myRslt.txt
# echo -e "exit value: $?" >> myRslt.txt
# echo -e "exit value: 0" >> intraRslt.txt
# Test "exmple \"Yvette Horner\" \"Barack Obama\"" "myRslt.txt" "intraRslt.txt"

echo -e -n "${neutre}["
echo -e -n "${bleufonce}===="
echo -e -n "${neutre}] Synthesis: Tested: "
echo -e "${bleufonce}$nbrTest${neutre} | Passing: ${vertfonce}$ok${neutre} | Failing: ${rougefonce}$false${neutre}"
echo -e -n "${neutre}["
echo -e -n "${bleufonce}===="
echo -e -n "${neutre}] Tot: "
echo -e -n "${vertfonce}"
echo -e -n 'print("%0.2f" % ('$ok/$nbrTest*100'), end="")' | python3
echo -e "%"

rm intraRslt.txt
rm myRslt.txt
rm input.txt