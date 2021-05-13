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

    echo -ne "${jaune}Test $testTitle:"
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
make fclean
make
clear

cat inputeSubject.txt | head -5  > smallTest.txt
echo -e "\n" >> smallTest.txt
echo -e "84" > smallRslt.txt
./groundhog 10 < smallTest.txt > myRslt.txt
echo -e "$?" > myRslt.txt
Test "Not engouht value" "myRslt.txt" "smallRslt.txt"
rm smallRslt.txt
rm smallTest.txt

cat inputeSubject.txt | head -10  > smallTest.txt
echo -e "\n" >> smallTest.txt
cat rsltSubject.txt | head -10  > smallRslt.txt
./groundhog 7 < smallTest.txt > myRslt.txt

Test "small Intra" "myRslt.txt" "smallRslt.txt"
rm smallRslt.txt
rm smallTest.txt

cat rsltSubject.txt > globalRslt.txt
echo -e "Global tendency switched 5 times" >> globalRslt.txt
./groundhog 7 < inputeSubject.txt > myRslt.txt
sed -i '$d' myRslt.txt

Test "Global Intra" "myRslt.txt" "globalRslt.txt"
rm globalRslt.txt


cat rsltSubject.txt > weirdRslt.txt
echo -e "Global tendency switched 5 times" >> weirdRslt.txt
echo -e "5 weirdest values are [26.7, 24.0, 21.6, 36.5, 42.1]" >> weirdRslt.txt
./groundhog 7 < inputeSubject.txt > myRslt.txt

# Test "Weird Intra" "myRslt.txt" "weirdRslt.txt"
rm weirdRslt.txt

echo -e "Global tendency switched 5 times" >> rsltSubject.txt
./groundhog 7 < inputeSubject.txt > myRslt.txt
sed -i '$d' myRslt.txt
Test "Intra" "myRslt.txt" "rsltSubject.txt"
sed -i '$d' rsltSubject.txt

touch epiRslt.txt
./groundhog > myRslt.txt

Test "Bad Args" "myRslt.txt" "epiRslt.txt"

./groundhog > myRslt.txt
echo -e "$?" > myRslt.txt
echo -e "84" > epiRslt.txt
Test "Bad Args return value" "myRslt.txt" "epiRslt.txt"

cat inputeSubject.txt | head -15  > smallTest.txt
cat rsltSubject.txt | head -15  > epiRslt.txt
./groundhog 7 < smallTest.txt > myRslt.txt
echo -e "return Value: $?" >> myRslt.txt
echo -e "return Value: 84" >> epiRslt.txt
Test "Bad Args no stop" "myRslt.txt" "epiRslt.txt"

cat inputeSubject.txt | head -15  > smallTest.txt
echo -e "a" >> smallTest.txt
cat rsltSubject.txt | head -15  > epiRslt.txt
./groundhog 7 < smallTest.txt > myRslt.txt
echo -e "return Value: $?" >> myRslt.txt
echo -e "return Value: 84" >> epiRslt.txt
Test "Wrong type" "myRslt.txt" "epiRslt.txt"

cat inputeSubject.txt | head -20  > smallTest.txt
echo -e "STOP" >> smallTest.txt
cat rsltSubject.txt | head -20  > epiRslt.txt
echo -e "Global tendency switched 1 times" >> epiRslt.txt
./groundhog 7 < smallTest.txt > myRslt.txt
sed -i '$d' myRslt.txt
echo -e "return Value: $?" >> myRslt.txt
echo -e "return Value: 0" >> epiRslt.txt
Test "final switches: correct number of switches 1" "myRslt.txt" "epiRslt.txt"

echo -e "12\n12" > smallTest.txt
echo -e "g=nan       r=nan%       s=nan" > epiRslt.txt
./groundhog 7 < smallTest.txt > myRslt.txt
echo -e "return Value: $?" >> myRslt.txt
echo -e "return Value: 84" >> epiRslt.txt
Test "final switches: syntax: identical values" "myRslt.txt" "epiRslt.txt"

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

echo -ne "${neutre}"
rm epiRslt.txt
rm myRslt.txt
rm smallTest.txt
make fclean 2>/dev/null
