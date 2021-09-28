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

./301dannon > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "No args" "myRslt.txt" "intraRslt.txt"

./301dannon xxx > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad file" "myRslt.txt" "intraRslt.txt"

./301dannon . > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad dir" "myRslt.txt" "intraRslt.txt"

echo -e "" > input.txt
./301dannon input.txt > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Empty file" "myRslt.txt" "intraRslt.txt"

echo -e "arzteh" > input.txt
./301dannon input.txt > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "file without numbers" "myRslt.txt" "intraRslt.txt"

echo -e "1aez124zre2" > input.txt
echo -e "3 elements\nSelection sort: 3 comparisons\nInsertion sort: 3 comparisons\nBubble sort: 3 comparisons\nQuicksort: 3 comparisons\nMerge sort: 2 comparisons" > intraRslt.txt
./301dannon input.txt > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 0" >> intraRslt.txt
Test "Parsing with alpha" "myRslt.txt" "intraRslt.txt"

echo -e "1aez124zre2\n13424;3254\";'\"()" > input.txt
echo -e "5 elements\nSelection sort: 10 comparisons\nInsertion sort: 10 comparisons\nBubble sort: 10 comparisons\nQuicksort: 8 comparisons\nMerge sort: 6 comparisons" > intraRslt.txt
./301dannon input.txt > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 0" >> intraRslt.txt
Test "Parsing with alpha advanced" "myRslt.txt" "intraRslt.txt"

echo -e "1" > input.txt
echo -e "1 element\nSelection sort: 0 comparisons\nInsertion sort: 0 comparisons\nBubble sort: 0 comparisons\nQuicksort: 0 comparisons\nMerge sort: 0 comparisons" > intraRslt.txt
./301dannon input.txt > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 0" >> intraRslt.txt
Test "1 integer" "myRslt.txt" "intraRslt.txt"

echo -e "3.3 5 9.89 -6" > input.txt
echo -e "4 elements\nSelection sort: 6 comparisons\nInsertion sort: 4 comparisons\nBubble sort: 6 comparisons\nQuicksort: 4 comparisons\nMerge sort: 5 comparisons" > intraRslt.txt
./301dannon input.txt > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 0" >> intraRslt.txt
Test "Basic short" "myRslt.txt" "intraRslt.txt"

echo -e "-564 1340 42 129 858 1491 1508 246 -1281 655 1506 306 290 -768 116 765 -48 -512 2598 42 2339" > input.txt
echo -e "21 elements\nSelection sort: 210 comparisons\nInsertion sort: 125 comparisons\nBubble sort: 210 comparisons\nQuicksort: 80 comparisons\nMerge sort: 67 comparisons" > intraRslt.txt
./301dannon input.txt > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 0" >> intraRslt.txt
Test "Long 21" "myRslt.txt" "intraRslt.txt"

echo -e "3 4 5 342 3465 434 75 -25 -253 -778 25 7" > input.txt
echo -e "12 elements\nSelection sort: 66 comparisons\nInsertion sort: 36 comparisons\nBubble sort: 66 comparisons\nQuicksort: 36 comparisons\nMerge sort: 26 comparisons" > intraRslt.txt
./301dannon input.txt > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 0" >> intraRslt.txt
Test "Basic" "myRslt.txt" "intraRslt.txt"

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