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
    echo -n "${cyanclair}"
    printf "Usage:\n"
    echo -n "\e[3m\t(at your root)\e[0m"
    echo -n "${cyanclair}"
    printf "./myMarvin.sh | column -t -s $'\\\t' \n"
    exit 0
fi

Test()
{
    testTitle="$1"
    myRslt="$2"
    expectedRslt="$3"
    diff $myRslt $expectedRslt > trace.txt

    echo -n "${jaune}$testTitle:"
    if [ -s trace.txt ]
    then
        echo "\t${rougefonce}FALSE  ✗"
        echo -n "${neutre}"
        # read -p "Display it ?(y/n): " display
        false=$((false+1))
        display="y"
        if [ "$display" = "y" ]
        then
            cat trace.txt | cat -e
        fi
    else
        echo "\t${vertclair}OK 🗸"
        rm trace.txt 2>/dev/null
        ok=$((ok+1))
    fi
    nbrTest=$((nbrTest+1))
}

clear

./209poll > myRslt.txt
echo "exit: $?" >> myRslt.txt
echo "exit: 84" > intraRslt.txt
Test "No args" "myRslt.txt" "intraRslt.txt"

./209poll 1 2 > myRslt.txt
echo "exit: $?" >> myRslt.txt
echo "exit: 84" > intraRslt.txt
Test "Not enough" "myRslt.txt" "intraRslt.txt"

./209poll 1 b 3 > myRslt.txt
echo "exit: $?" >> myRslt.txt
echo "exit: 84" > intraRslt.txt
Test "Bad args" "myRslt.txt" "intraRslt.txt"

./209poll 10000 500 142.24 > myRslt.txt
echo "exit: $?" >> myRslt.txt
echo "exit: 84" > intraRslt.txt
Test "Voting intention bad superior 100" "myRslt.txt" "intraRslt.txt"

./209poll -10000 500 42.24 > myRslt.txt
echo "exit: $?" >> myRslt.txt
echo "exit: 84" > intraRslt.txt
Test "Population size negative" "myRslt.txt" "intraRslt.txt"

./209poll 10000 -500 42.24 > myRslt.txt
echo "exit: $?" >> myRslt.txt
echo "exit: 84" > intraRslt.txt
Test "Sample size negative" "myRslt.txt" "intraRslt.txt"

./209poll 10000 500 -42.24 > myRslt.txt
echo "exit: $?" >> myRslt.txt
echo "exit: 84" > intraRslt.txt
Test "Voting intention negative" "myRslt.txt" "intraRslt.txt"

./209poll 10000 11500 42.24 > myRslt.txt
echo "exit: $?" >> myRslt.txt
echo "exit: 84" > intraRslt.txt
Test "Sample size > Populatio size" "myRslt.txt" "intraRslt.txt"

./209poll 10000 0 42.24 > myRslt.txt
echo "exit: $?" >> myRslt.txt
echo "exit: 84" > intraRslt.txt
Test "Sample size = 0" "myRslt.txt" "intraRslt.txt"

./209poll 1 1 42.24 > myRslt.txt
echo "exit: $?" >> myRslt.txt
echo "exit: 84" > intraRslt.txt
Test "Population size <= 1" "myRslt.txt" "intraRslt.txt"

./209poll 10000 500 42.24 > myRslt.txt
echo "Population size:         10000\nSample size:             500\nVoting intentions:       42.24%\nVariance:                0.000464\n95% confidence interval: [38.02%; 46.46%]\n99% confidence interval: [36.68%; 47.80%]" > intraRslt.txt
echo "exit: $?" >> myRslt.txt
echo "exit: 0" >> intraRslt.txt
Test "Intra 01" "myRslt.txt" "intraRslt.txt"

./209poll 10000 100 45 > myRslt.txt
echo "Population size:         10000\nSample size:             100\nVoting intentions:       45.00%\nVariance:                0.002450\n95% confidence interval: [35.30%; 54.70%]\n99% confidence interval: [32.23%; 57.77%]" > intraRslt.txt
echo "exit: $?" >> myRslt.txt
echo "exit: 0" >> intraRslt.txt
Test "Intra 02" "myRslt.txt" "intraRslt.txt"

echo -n "${neutre}["
echo -n "${bleufonce}===="
echo -n "${neutre}] Synthesis: Tested: "
echo "${bleufonce}$nbrTest${neutre} | Passing: ${vertfonce}$ok${neutre} | Failing: ${rougefonce}$false${neutre}"
echo -n "${neutre}["
echo -n "${bleufonce}===="
echo -n "${neutre}] Tot: "
echo -n "${vertfonce}"
echo -n 'print("%0.2f" % ('$ok/$nbrTest*100'), end="")' | python3
echo "%"

rm intraRslt.txt
rm myRslt.txt
rm data