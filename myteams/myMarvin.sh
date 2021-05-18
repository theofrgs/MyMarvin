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

if [ "$#" -ne 2 ]; then
    echo "USAGE: $0 host port"
    exit 0
fi

USERNAME="Anonymous"
PASS=""
HOST=$1
PORT=$2
MKFIFO=`which mkfifo`
PIPE=fifo
OUT=outfile
TAIL=`which tail`
NC="`which nc` -C"
TIMEOUT=0.02
OK=0
KO=0
NB_TEST=0

Launch_client()
{
    local host=$1
    local port=$2

    $MKFIFO $PIPE 2>/dev/null
    ($TAIL -f $PIPE 2>/dev/null | $NC $host $port &> $OUT &) >/dev/null 2>/dev/null
    sleep $TIMEOUT
    getcode 220
    if [[ ! $? -eq 1 ]]; then
        echo "Could Launch client or code client false"
        kill_client
        exit 1
    fi
}

Percent()
{
    echo -ne "${neutre}["
    echo -ne "${bleufonce}===="
    echo -ne "${neutre}] Synthesis: Tested: "
    echo -e "${bleufonce}$NB_TEST${neutre} | Passing: ${vertfonce}$OK${neutre} | Failing: ${rougefonce}$KO${neutre}"
    echo -ne "${neutre}["
    echo -ne "${bleufonce}===="
    echo -ne "${neutre}] Tot: "
    echo -ne "${vertfonce}"
    echo -ne 'print("%0.2f" % ('$OK/$NB_TEST*100'), end="")' | python3
    echo "%"
    echo -ne "${neutre}"
}

getcode()
{
    sleep $TIMEOUT
    local code=$1
    local data=`$TAIL -n 1 $OUT |cat -e | grep "^$code.*[$]$" | wc -l`
    return $data
}

print_failed()
{
    echo -e "\t${rougefonce}FALSE  ✗${neutre}"
    echo "Expected code: $2"
    echo "Received : ["`$TAIL -n 1 $OUT| cat -e`"]"
    KO=$((KO+1))
}

print_success()
{
    echo -e "\t${vertclair}OK 🗸"
    rm trace.txt 2>/dev/null
    OK=$((OK+1))
}

send_Cmd()
{
    local cmd=$2
    echo "$cmd" >$PIPE
    sleep $TIMEOUT
}

Launch_test()
{
    local test_name=$1
    local cmd=$2
    local code=$3

    echo -ne "${jaune}Test $test_name:"
    echo "$cmd" >$PIPE
    getcode $code

    if [[ ! $? -eq 1 ]]; then
        print_failed "$test_name" "$code"
    else
        print_success
    fi
    NB_TEST=$((NB_TEST+1))
}

kill_client()
{
    local nc=`which nc`

    if [ `pidof $TAIL | wc -l` -ne 0 ]
    then
        killall $TAIL &>/dev/null
    fi
    if [ `pidof $nc | wc -l` -ne 0 ]
    then
        killall $nc &>/dev/null
    fi
    rm -f $PIPE $OUT &> /dev/null
}

clean()
{
    rm -f $PIPE $OUT log &>/dev/null
}

Test_Connect()
{
    Launch_client $HOST $PORT
    clean
    kill_client
}

Test_Only_space_command()
{
    Launch_client $HOST $PORT
    Launch_test "Only space command" " " 500
    clean
    kill_client
}

Test_Quit()
{
    Launch_client $HOST $PORT
    Launch_test "QUIT" "QUIT" 221
    clean
    kill_client
}

Launch_server()
{
    local port=$1

    echo "Server launch"
    ./myteams_server $port &
    PID=$!
}

Close_server()
{
    local pid=$1

    echo "Server close"
    kill $PID 2>/dev/null
}

clear

Test_Connect
Test_Quit
Test_Only_space_command
Percent

rm expected.txt 2>/dev/null
rm output.txt 2>/dev/null
