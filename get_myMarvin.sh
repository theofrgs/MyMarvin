#!/bin/bash

# set -x

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

function display_help
{
    printf "Usage:\n"
    printf "\t./get_myMarvin [project_name ...]\n"
    echo -e "\e[3mex: ./get_myMarvin 307multigrains\n    ./get_myMarvin 307multigrains 306radiator\e[0m"
    exit 0
}

function get_user_name
{
    home_dirs=$(ls /home/)
    user=$(who)

    for it_home_dirs in $home_dirs
    do
        if [[ $user == *"$it_home_dirs "* ]]
        then
            echo $it_home_dirs
            return 0
        fi
    done
    echo "user not found !"
    exit 84
}

function get_project_name_occurences
{
    project_name=$1
    echo $(find / -type d -wholename "*B*$project_name*" 2>/dev/null)
}

function get_project_path
{
    project_name=$1
    user_name=$(get_user_name)
    project_name_occurences=$(get_project_name_occurences $project_name)
    directorys=(`echo $project_name_occurences | sed 's/,/\n/g'`)
    echo $directorys
}

function MyMarvin
{
    project_path=$1
    project_name=$2
    cd $project_path
    cp -rf /tmp/MyMarvin/$project_name/* . && ./myMarvin.sh | column -t -s $'\t'
}

function check_args
{
    if [ -n "$1" ]
    then
        if  [ "$1" = "--help" ]
        then
            display_help
        else
            return 0
        fi
    else
        display_help
    fi
}

function get_myMarvin
{
    args=$@
    for project_name in $@
    do
        project_path=$(get_project_path $project_name)
        MyMarvin $project_path $project_name
    done
}

check_args $@
get_myMarvin $@