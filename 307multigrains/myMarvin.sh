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

nb_test=$((`cat myMarvin.json | jq '.tests | length'` - 1))

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
    cmd="$4"
    diff $myRslt $expectedRslt > trace.txt

    echo -e -n "${jaune}$testTitle:"
    if [ -s trace.txt ]
    then
        echo -e "\t${rougefonce}FALSE  ✗"
        echo -e -n "${neutre}"
        # read -p "Display it ?(y/n): " display
        false=$((false+1))
        echo -e "\e[3m\"$(< cmd.txt)\"\e[0m"
        display="y"
        if [ "$display" = "y" ]
        then
            cat trace.txt | cat -e
        fi
    else
        echo -e "\t${vertclair}OK ✔"
        rm trace.txt 2>/dev/null
        ok=$((ok+1))
    fi
    nbrTest=$((nbrTest+1))
}

clear

function clean_repository()
{
    rm intraRslt.txt 2>/dev/null
    rm myRslt.txt 2>/dev/null
    rm input.txt 2>/dev/null
    rm cmd.txt 2>/dev/null
}

for i in `seq 0 $nb_test`
do

    exit_value=`cat myMarvin.json | jq '.tests['$i'].exit_value'`

    echo -e `cat myMarvin.json | jq '.tests['$i'].output' | tail -c +2 | head -c -2` > intraRslt.txt
    echo -e `cat myMarvin.json | jq '.tests['$i'].input' | tail -c +2 | head -c -2` > cmd.txt
    bash cmd.txt > myRslt.txt

    if [ "$exit_value" = "84" ]
    then
        echo -e "exit value: 0" > intraRslt.txt
    else
        echo -e "exit value: 0" >> intraRslt.txt
    fi
    echo -e "exit value: $?" >> myRslt.txt

    Test "`cat myMarvin.json | jq '.tests['$i'].name' | tail -c +2 | head -c -2`" "myRslt.txt" "intraRslt.txt" cmd.txt

done

clean_repository