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

echo "./307multigrains" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "No args" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains  4 1 1 1 4 1 1 1 4 1 1 1 4 1 1 1 4 1 1 1 4 1 1 1" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Too much args" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains 4 1 1 1" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Not enough args" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains -10 100 10 0 200 200 200 200 200" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad args -- number of tons of fertilizer F1 -- negatif" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains a 100 10 0 200 200 200 200 200" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad args -- number of tons of fertilizer F1 -- not a number" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains 10 -100 10 0 200 200 200 200 200" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad args -- number of tons of fertilizer F2 -- negatif" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains 10 a 10 0 200 200 200 200 200" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad args -- number of tons of fertilizer F2 -- not a number" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains 10 100 -10 0 200 200 200 200 200" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad args -- number of tons of fertilizer F3 -- negatif" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains 10 1 a 0 200 200 200 200 200" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad args -- number of tons of fertilizer F3 -- not a number" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains 10 100 10 -1 200 200 200 200 200" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad args -- number of tons of fertilizer F4 -- negatif" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains 10 1 10 a 200 200 200 200 200" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad args -- number of tons of fertilizer F4 -- not a number" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains 10 100 10 0 -200 200 200 200 200" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad args -- price of one unit of oat -- negatif" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains 10 100 10 0 a200 200 200 200 200" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad args -- price of one unit of oat -- not a number" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains 10 100 10 0 200 -200 200 200 200" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad args -- price of one unit of wheat -- negatif" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains 10 100 10 0 200 a200 200 200 200" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad args -- price of one unit of wheat -- not a number" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains 10 100 10 0 200 200 -200 200 200" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad args -- price of one unit of corn -- negatif" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains 10 100 10 0 200 200 a200 200 200" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad args -- price of one unit of corn -- not a number" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains 10 100 10 0 200 200 200 -200 200" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad args -- price of one unit of barley -- negatif" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains 10 100 10 0 200 200 200 ad200 200" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad args -- price of one unit of barley -- not a number" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains 10 100 10 0 200 200 200 200 -200" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad args -- price of one unit of soy -- negatif" "myRslt.txt" "intraRslt.txt" cmd.txt

echo "./307multigrains 10 100 10 0 200 200 200 200 azd" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad args -- price of one unit of soy -- not a number" "myRslt.txt" "intraRslt.txt" cmd.txt

echo -e "Resources: 10 F1, 100 F2, 10 F3, 0 F4\n\nOat: 0 units at \$200/unit\nWheat: 10.00 units at \$200/unit\nCorn: 0 units at \$200/unit\nBarley: 0 units at \$200/unit\nSoy: 0 units at \$200/unit\n\nTotal production value: \$2000.00" > intraRslt.txt
echo "./307multigrains 10 100 10 0 200 200 200 200 200" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 0" >> intraRslt.txt
Test "Basic - 01" "myRslt.txt" "intraRslt.txt" cmd.txt

echo -e "Resources: 45 F1, 41 F2, 21 F3, 63 F4\n\nOat: 0 units at \$198/unit\nWheat: 20.00 units at \$259/unit\nCorn: 8.50 units at \$257/unit\nBarley: 1.00 units at \$231/unit\nSoy: 18.25 units at \$312/unit\n\nTotal production value: \$13289.50" > intraRslt.txt
echo "./307multigrains 45 41 21 63 198 259 257 231 312" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 0" >> intraRslt.txt
Test "Basic - 02" "myRslt.txt" "intraRslt.txt" cmd.txt

echo -e "Resources: 56 F1, 34 F2, 21 F3, 63 F4\n\nOat: 0.25 units at \$198/unit\nWheat: 13.25 units at \$259/unit\nCorn: 0 units at \$257/unit\nBarley: 7.25 units at \$231/unit\nSoy: 27.88 units at \$312/unit\n\nTotal production value: \$13853.00" > intraRslt.txt
echo "./307multigrains 56 34 21 63 198 259 257 231 312" > cmd.txt
bash cmd.txt > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 0" >> intraRslt.txt
Test "Basic - 03" "myRslt.txt" "intraRslt.txt" cmd.txt

rm intraRslt.txt 2>/dev/null
rm myRslt.txt 2>/dev/null
rm input.txt 2>/dev/null
rm cmd.txt 2>/dev/null

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