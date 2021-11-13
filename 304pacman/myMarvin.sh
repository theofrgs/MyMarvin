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

./304pacman > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "No args" "myRslt.txt" "intraRslt.txt"

./304pacman dzdz zdze > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Not enough arg" "myRslt.txt" "intraRslt.txt"

./304pacman loremp > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Bad file" "myRslt.txt" "intraRslt.txt"

./304pacman loremp erg rgt tg > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Too many args" "myRslt.txt" "intraRslt.txt"

echo -e "1111111111\n0000000000\n0000000000\n0000000000\n00000F0000\n0000000000\n0000000000\n0000000000\n0000000000\n1111111111" > input.txt
./304pacman input.txt '+' ' ' > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "no pacman" "myRslt.txt" "intraRslt.txt"

echo -e "1111111111\n0000000000\n0000000000\n0000000000\n0000000000\n0000000000\n00P0000000\n0000000000\n0000000000\n1111111111" > input.txt
./304pacman input.txt '+' ' ' > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "no ghost" "myRslt.txt" "intraRslt.txt"

echo -e "1111111111\n0F00000000\n0000000000\n0000F00000\n0000000000\n0000000000\n00P0000000\n0000000000\n0000000000\n1111111111" > input.txt
./304pacman input.txt '+' ' ' > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "severals ghosts" "myRslt.txt" "intraRslt.txt"

echo -e "1111111111\n0P00000000\n0000000000\n0000F00000\n0000000000\n0000000000\n00P0000000\n0000000000\n0000000000\n1111111111" > input.txt
./304pacman input.txt '+' ' ' > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "severals pacman" "myRslt.txt" "intraRslt.txt"

echo -e "1111111111\n0000000000\n0000000000\n000000aa00\n00000F0000\n0000000000\n0000000000\n0000000000\n0000000000\n1111111111" > input.txt
./304pacman input.txt '+' ' ' > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Unknown character -01" "myRslt.txt" "intraRslt.txt"

echo -e "1111111111\n0000000000\n0000000000\n000000--00\n00000F0000\n0000000000\n0000000000\n0000000000\n0000000000\n1111111111" > input.txt
./304pacman input.txt '+' ' ' > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Unknown character -01" "myRslt.txt" "intraRslt.txt"

echo -e "1111111111\n0000000000\n0000000000\n0000000000\n00000F0000\n0000000000\n0000000000\n0000000000\n00000000000000000\n1111111111" > input.txt
./304pacman input.txt '+' ' ' > myRslt.txt
echo -e "exit value: $?" > myRslt.txt
echo -e "exit value: 84" > intraRslt.txt
Test "Map not rectangular" "myRslt.txt" "intraRslt.txt"

echo -e "1111111111\n0000000000\n0000000000\n0000000000\n00000F0000\n0000000000\n00000P0000\n0000000000\n0000000000\n1111111111" > input.txt
echo -e "++++++++++\n          \n     2    \n    212   \n    1F12  \n     12   \n     P    \n          \n          \n++++++++++" > intraRslt.txt
./304pacman input.txt '+' ' ' > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 0" >> intraRslt.txt
Test "basic 1" "myRslt.txt" "intraRslt.txt"

echo -e "111111111111111\n100000010000001\n101011010110101\n100P00010000001\n101010111010101\n101010010000001\n101011010110111\n111010000010111\n100000000010F01\n101010000010111\n111010111110111\n100000110000001\n101110110101101\n100100010001001\n110001110101011\n100100010000001\n101110110111101\n101010000000001\n111111111111111" > input.txt
echo -e "@@@@@@@@@@@@@@@\n@      @109890@\n@ @ @@8@0@@7@9@\n@  P767@987678@\n@ @ @5@@@7@5@7@\n@ @8@43@765456@\n@ @7@@2@8@@3@@@\n@@@6@21090@2@@@\n@765432101@1F1@\n@8@6@43212@2@@@\n@@@7@5@@@@@3@@@\n@  876@@765456@\n@ @@@7@@8@6@@7@\n@  @ 8 @987@98@\n@@   @@@0@8@0@@\n@  @   @109012@\n@ @@@7@@2@@@@3@\n@ @ @654345654@\n@@@@@@@@@@@@@@@" > intraRslt.txt
./304pacman input.txt '@' ' ' > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 0" >> intraRslt.txt
Test "Long 2" "myRslt.txt" "intraRslt.txt"

echo -e "1111111111\n0000000000\n0000000000\n0000000000\n00000F0000\n0000000000\n0000000000\n0000000001\n000000001P\n1111111111" > input.txt
echo -e "++++++++++\n8765434567\n7654323456\n6543212345\n54321F1234\n6543212345\n7654323456\n876543456+\n98765456+P\n++++++++++" > intraRslt.txt
./304pacman input.txt '+' ' ' > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 0" >> intraRslt.txt
Test "noPath 1" "myRslt.txt" "intraRslt.txt"

echo -e "1000000000000010010000100000011110000001010110\n0010001110101010000111010101010101100100110100\n0001000100000011110000000101100010001111010101\n0010001110101010000111010101010101100100110100\n0010000100000000010000100000011010110110110101\n0010010101101110000101100010010010001010100100\n1110000000001101110000000101100000101110001000\n1010110101101010000101100010000101010010011000\n0010001110101010000111010101010101100100110100\n0010000100000000010000100000011010110110110101\n0001000100000011110000000101100010001111010101\n0010001110101010000111010101010101100100110100\n0001000100000011110000000101100010001111010101\n0010001110101010000111010101010101100100110100\n0010000100000000010000100000011010110110110101\n0010010101101110000101100010010010001010100100\n1110000000001101110000000101100000101110001000\n0010001110101010000111010101010101100100110100\n0001000100000011110000000101100010001111010101\n0010001110101010000111010101010101100100110100\n0010000100000000010000100000011010110110110101\n0010010101101110000101100010010010001010100100\n1110000000001101110000000101100000101110001000\n0010000100000000010000100000011010110110110101\n0010010101101110000101100010010010001010100100\n1110000000001101110000000101100000101110001000\n100000000010F000010001110101011010110101110101\n10101000001010000100001000000111P0010000010110\n1010100000000011110000000101100010100111010101\n0010010101101110000101100010010010001010100100\n0010010101101110000101100010010010001010100100\n1110000000001101110000000101100000101110001000\n0001000100000011110000000101100010001111010101\n0010001110101010000111010101010101100100110100\n0010000100000000010000100000011010110110110101\n0010010101101110000101100010010010001010100100\n1110000000001101110000000101100000101110001000\n0001000100000011110000000101100010001111010101\n0010001110101010000111010101010101100100110100\n0010000100000000010000100000011010110110110101\n0010010101101110000101100010010010001010100100\n1110000000001101110000000101100000101110001000\n0001000100000011110000000101100010001111010101\n0010001110101010000111010101010101100100110100\n0010000100000000010000100000011010110110110101\n0010010101101110000101100010010010001010100100\n1110000000001101110000000101100000101110001000" > input.txt
echo -e "+7654321098789+76+4567+101234++++      + + ++ \n98+432+++8+6+8+6543+++7+9+1+5+ + ++  +  ++ +  \n090+212+876567++++2345678+0++   +   ++++ + + +\n10+210+++6+4+6+8901+++7+7+9+1+ + ++  +  ++ +  \n21+1098+654345678+0123+567890++3+5++ ++ ++ + +\n32+09+7+5++2+++8909+1++456+01+12+456+ + +  +  \n+++987654321++ +++8901234+ ++90123+7+++   +   \n+ +8++7+5++0+2+4567+1++434+8789+3+ +  +  ++   \n  +765+++1+9+1+3456+++ +2+4+6+0+4++  +  ++ +  \n  +6545+109890123+5678+012345++ + ++ ++ ++ + +\n   +434+098789++++4567890+2++   +   ++++ + + +\n  +432+++8+6+8+6543+++7+9+1+ + + ++  +  ++ +  \n   +212+876567++++2345678+0++   +   ++++ + + +\n  +210+++6+4+6+8901+++7+7+9+1+ + ++  +  ++ +  \n  +1098+654345678+0123+567890++ + ++ ++ ++ + +\n  +09+7+5++2+++8909+1++456+01+  +   + + +  +  \n+++987654321++ +++8901234+8++     + +++   +   \n  +876+++2+0+2+0987+++1+3+7+ + + ++  +  ++ +  \n   +656+210901++++6789012+6++   +   ++++ + + +\n  +654+++0+8+0+2345+++1+3+5+7+ + ++  +  ++ +  \n  +5432+098789012+6789+123456++ + ++ ++ ++ + +\n  +43+1+9++6+++2345+7++012+67+  +   + + +  +  \n+++321098765++8+++4567890+4++     + +++   +   \n  +2109+765456789+3456+012345++ + ++ ++ ++ + +\n  +10+8+6++3+++9012+6++901+56+  +   + + +  +  \n+++098765432++3+++3456789+5++     + +++   +   \n+321098765+1F1234+456+++0+4+6++ + ++ + +++ + +\n+4+2+09876+2+2345+5678+212345+++P  +     + ++ \n+5+3+987654343++++6789012+4++   + +  +++ + + +\n76+45+9+7++4+++0987+9++234+  +  +   + + +  +  \n87+54+0+8++5+++1098+0++345+  +  +   + + +  +  \n+++432109876++ +++9012345+1++     + +++   +   \n   +432+098789++++8901234+0++   +   ++++ + + +\n  +654+++0+8+0+4567+++3+5+9+1+ + ++  +  ++ +  \n  +7656+210901234+8901+567890++ + ++ ++ ++ + +\n  +87+7+3++0+++4567+1++456+01+  +   + + +  +  \n+++987654321++ +++8901234+2++     + +++   +   \n   +987+543234++++9012345+1++   +   ++++ + + +\n  +109+++5+3+5+9010+++4+6+0+2+ + ++  +  ++ +  \n  +2101+765456789+1234+878901++ + ++ ++ ++ + +\n  +32+2+8++5+++9012+4++989+12+  +   + + +  +  \n+++432109876++ +++3456789+7++     + +++   +   \n   +432+098789++++4567890+6++   +   ++++ + + +\n  +654+++0+8+0+4565+++9+1+5+7+ + ++  +  ++ +  \n  +7656+210901234+6789+323456++ + ++ ++ ++ + +\n  +87+7+3++0+++4567+9++434+67+  +   + + +  +  \n+++987654321++ +++8901234+ ++     + +++   +   " > intraRslt.txt
./304pacman input.txt '+' ' ' > myRslt.txt
echo -e "exit value: $?" >> myRslt.txt
echo -e "exit value: 0" >> intraRslt.txt
Test "noPath 2" "myRslt.txt" "intraRslt.txt"

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