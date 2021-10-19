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

echo -e "tty: tty.o fc.o\ncc -o tty tty.o fc.o\n\ntty.o: tty.c fc.h\ncc -c tty.c\n\nfc.o: fc.c fc.h\ncc -c fc.c" > input.txt
echo -e "cc -c tty.c\ncc -o tty tty.o fc.o" > intraRslt.txt
./303Make input.txt tty.c > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 0" >> intraRslt.txt
Test "dependency string .c" "myRslt.txt" "intraRslt.txt"

echo -e "tty: tty.o fc.o\ncc -o tty tty.o fc.o\n\ntty.o: tty.c fc.h\ncc -c tty.c\n\nfc.o: fc.c fc.h\ncc -c fc.c" > input.txt
echo -e "cc -c fc.c\ncc -c tty.c\ncc -o tty tty.o fc.o" > intraRslt.txt
./303make input.txt fc.h > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 0" >> intraRslt.txt
Test "dependency string .h" "myRslt.txt" "intraRslt.txt"

echo -e "tty: tty.o fc.o\ncc -o tty tty.o fc.o\n\ntty.o: tty.c fc.h\ncc -c tty.c\n\nfc.o: fc.c fc.h\ncc -c fc.c" > input.txt
echo -e "" > intraRslt.txt
./303make input.txt tty > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 84" >> intraRslt.txt
Test "dependency exec" "myRslt.txt" "intraRslt.txt"

echo -e "tty: tty.o fc.o\ncc -o tty tty.o fc.o\n\ntty.o: tty.c fc.h\ncc -c tty.c\n\nfc.o: fc.c fc.h\ncc -c fc.c" > input.txt
echo -e "[0 0 1 0 0 0]\n[0 0 1 0 0 1]\n[0 0 0 1 0 0]\n[0 0 0 0 0 0]\n[0 0 0 0 0 1]\n[0 0 0 1 0 0]\nfc.c -> fc.o -> tty\nfc.h -> fc.o -> tty\nfc.h -> tty.o -> tty\nfc.o -> tty\ntty.c -> tty.o -> tty\ntty.o -> tty" > intraRslt.txt
./303make input.txt > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 0" >> intraRslt.txt
Test "dependency graph - 01" "myRslt.txt" "intraRslt.txt"

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