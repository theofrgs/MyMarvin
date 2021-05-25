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

if [ "$#" -ne 3 ]; then
    echo "USAGE: $0 host port alone[0-1]"
    exit 0
fi

USERNAME="Anonymous"
PASS=""
HOST=$1
PORT=$2
ALONE=$3
MKFIFO=`which mkfifo`
PIPE=fifo
OUT=outfile
TAIL=`which tail`
NC="`which nc` -C"
TIMEOUT=0.01
OK=0
KO=0
NB_TEST=0

function Launch_server()
{
    local port=$1

    ./myteams_server $port &
    PID=$!
}

function Close_server()
{
    local pid=$1

    kill $pid 2>/dev/null
    sleep $TIMEOUT
}

function Launch_client()
{
    local host=$1
    local port=$2
    local alone=$3

    # Launch_server $port
    $MKFIFO $PIPE 2>/dev/null
    ($TAIL -f $PIPE 2>/dev/null | $NC $host $port &> $OUT &) >/dev/null 2>/dev/null
    sleep $TIMEOUT
    getcode 600
    if [[ ! $? -eq 1 ]]; then
        echo "Could Launch client or code client false"
        kill_client
        if [ "$alone" -eq "1" ]
        then
            return 1
        else
            exit 1
        fi
    fi
}

function Percent()
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

function getcode()
{
    sleep $TIMEOUT
    local code=$1
    local data=`$TAIL -n 1 $OUT | cat -e | grep "^$code.*[$]$" | wc -l`
    return $data
}

function print_failed()
{
    echo -e "\t${rougefonce}FALSE  ✗${neutre}"
    echo "Expected code: $2"
    echo "Received : ["`$TAIL -n 1 $OUT| cat -e`"]"
    KO=$((KO+1))
    echo -ne "${neutre}"
}

function print_success()
{
    echo -e "\t${vertclair}OK 🗸"
    echo -ne "${neutre}"
    rm trace.txt 2>/dev/null
    OK=$((OK+1))
}

function send_Cmd()
{
    local cmd=$2
    echo "$cmd" >$PIPE
    sleep $TIMEOUT
}

function Launch_test()
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

function kill_client()
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
    # Close_server $PID
}

function clean()
{
    rm -f $PIPE $OUT log &>/dev/null
}

function Test_Connect()
{
    Launch_client $HOST $PORT $ALONE
    clean
    kill_client
}

function Test_Only_space_command()
{
    Launch_client $HOST $PORT $ALONE
    Launch_test "Only space command" " " "500 Commande not found"
    clean
    kill_client
}

function Test_Login()
{
    Launch_client $HOST $PORT $ALONE
    Launch_test "LOGIN" "login theo" "1 login new name set: theo"
    clean
    kill_client
}

function Test_Unauthorized()
{
    Launch_client $HOST $PORT $ALONE
    Launch_test "Unauthorized call" "print theo" "501 Need account to use this function"
    clean
    kill_client
}

function Test_Print()
{
    Launch_client $HOST $PORT $ALONE
    send_Cmd "LOGIN" "login theo"
    Launch_test "Print" "print hello world" "0 hello world"
    clean
    kill_client
}

function Test_User()
{
    Launch_client $HOST $PORT $ALONE
    send_Cmd "LOGIN" "login theo"
    Launch_test "Bad Args User" "user" "404 Bad args"
    clean
    kill_client
    Launch_client $HOST $PORT $ALONE
    send_Cmd "LOGIN" "login theo"
    Launch_test "Good cmd User" "user 123213" "4 user cmd"
    clean
    kill_client
}

function Test_Users()
{
    Launch_client $HOST $PORT $ALONE
    send_Cmd "LOGIN" "login theo"
    Launch_test "Users" "users" "3 "
    clean
    kill_client
}

function Test_Help()
{
    Launch_client $HOST $PORT $ALONE
    send_Cmd "LOGIN" "login theo"
    Launch_test "Help" "help" "0 "
    clean
    kill_client
}

function Test_Long_line()
{
    Launch_client $HOST $PORT $ALONE
    send_Cmd "LOGIN" "login theo"
    Launch_test "Long line" "print hello world Baptiste Nicolas lol" "0 hello world Baptiste Nicolas lol"
    clean
    kill_client
}

function Test_Multiple_Command()
{
    Launch_client $HOST $PORT $ALONE
    send_Cmd "LOGIN" "login theo"
    Launch_test "Multiple Line Command" "print hello\\nprint world" "0 world"
    clean
    kill_client
}

function Test_Logout()
{
    Launch_client $HOST $PORT $ALONE
    send_Cmd "LOGIN" "login theo"
    Launch_test "Logout with login" "logout" "2 Deconnected . . . "
    clean
    kill_client
    Launch_client $HOST $PORT $ALONE
    Launch_test "Logout only" "logout" "2 Deconnected . . . "
    clean
    kill_client
}

function Init()
{
    make 2> /dev/null
    clear
}

function Find_Port()
{
    Launch_server $PORT
    Launch_client $HOST $PORT $ALONE $ALONE #try to launch a client
    if [ "$?" -eq "1" ] # if he failed then close server and launch on another port
    then
        PORT=$((PORT+1))
        Close_server $PID
        sleep $TIMEOUT

        echo "New launch $PORT"
        Launch_server $PORT
        Find_Port
    fi
}
if [ "$ALONE" -eq "1" ]
then
    echo "Alone"
    Init
    Find_Port
fi

Test_Connect
Test_Logout
Test_Only_space_command
Test_Long_line
Test_Multiple_Command
Test_Unauthorized
Test_Login
Test_Print
Test_User
Test_Users
# Test_Help
Percent


mf 2> /dev/null
rm expected.txt 2>/dev/null
rm output.txt 2>/dev/null

if [ "$ALONE" == "1" ]
then
    Close_server $PID
fi