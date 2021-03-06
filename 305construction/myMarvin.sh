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
        echo -e "\t${vertclair}OK ✔"
        rm trace.txt 2>/dev/null
        ok=$((ok+1))
    fi
    nbrTest=$((nbrTest+1))
}

clear

./305construction > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "No args" "myRslt.txt" "intraRslt.txt"

./305construction loremp > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad file" "myRslt.txt" "intraRslt.txt"

./305construction loremp erg rgt tg > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Too many args" "myRslt.txt" "intraRslt.txt"

echo -e "aezrtgyhtgvefzda" > input.txt
./305construction input.txt > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "inconsistent content -- 01" "myRslt.txt" "intraRslt.txt"

echo -e "car;3\nHea;heat;3;Ele;Mas" > input.txt
./305construction input.txt > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "inconsistent content -- 02" "myRslt.txt" "intraRslt.txt"

echo -e "Car:carpenter:4:Fou\nHea:heat:3:Ele:Mas\nCov:cover:2:Car\nEle:electricity:1:Cov:Mas\nFin:finishing touches:9:Cov:Ele:Mas:Plu\nFou:foundations:8:Lan\nMas:masonry:4:Lan:Fou\nPlu:plumbing:1:Ele:Mas\nLan:landscaping:3" > input.txt
./305construction input.txt > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "inconsistent content -- 03" "myRslt.txt" "intraRslt.txt"

echo -e "Car;carpenter;4;Fou\nHea;heat;3;Ele;Mas\nCov;cover;2;Car\nEle;electricity;1;Cov;Mas\nFin;finishing touches;9;Cov;Ele;Mas;Plu\nFou;foundations;8;Lan\nMas;masonry;4;Lan;Fou\nPlu;plumbing;1;Ele;Mas\nLan;landscaping;3" > input.txt
echo -e "Total duration of construction: 28 weeks\n\nLan must begin at t=0\nFou must begin at t=3\nCar must begin at t=11\nMas must begin between t=11 and t=13\nCov must begin at t=15\nEle must begin at t=17\nPlu must begin at t=18\nHea must begin between t=18 and t=25\nFin must begin at t=19\n\nLan\t(0)\t===\nFou\t(0)\t   ========\nCar\t(0)\t           ====\nMas\t(2)\t           ====\nCov\t(0)\t               ==\nEle\t(0)\t                 =\nPlu\t(0)\t                  =\nHea\t(7)\t                  ===\nFin\t(0)\t                   =========" > intraRslt.txt
./305construction input.txt > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 0" >> intraRslt.txt
Test "Basic - 01" "myRslt.txt" "intraRslt.txt"

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

rm intraRslt.txt 2>/dev/null
rm myRslt.txt 2>/dev/null
rm input.txt 2>/dev/null