#!/bin/bash

# set -x

function display_help {
    printf "Usage:\n"
    printf "\t./get_my_marvin [project_name ...]\n"
    echo -e "\e[3mex:\n\t./get_my_marvin (inside repository)\n\t./get_my_marvin 307multigrains\n\t./get_my_marvin 307multigrains 306radiator\e[0m"
    exit 0
}

function get_user_name {
    home_dirs=$(ls /home/)
    user=$(who)

    for it_home_dirs in $home_dirs; do
        if [[ $user == *"$it_home_dirs "* ]]; then
            echo "$it_home_dirs"
            return 0
        fi
    done
    echo "user not found !"
    exit 84
}

function get_project_name_occurences {
    project_name=$1
    find / -type d -wholename "*B*$project_name*" 2>/dev/null
}

function get_project_path {
    project_name=$1
    # user_name=$(get_user_name)

    project_name_occurences=$(get_project_name_occurences "307")
    IFS=' ' read -ra directorys <<<"$project_name_occurences"
    echo "${directorys[0]}"
}

function have_marvin_test {
    project_check=$1
    marvin_tests=$(ls /tmp/MyMarvin/)

    for project_name in $marvin_tests; do
        if grep -q "$project_name" <<<"$project_check"; then
            echo "$project_name"
            return
        fi
    done
    echo ""
}

function get_current_project {
    have_marvin_test "$(pwd)"
}

function my_marvin {
    project_path=$1
    project_name=$2
    if [ -n "$(have_marvin_test "$project_name")" ]; then
        cd "$project_path" || exit 84
        cp -rf /tmp/MyMarvin/"$project_name"/* . && ./myMarvin.sh | column -t -s $'\t'
    fi
}

function check_args {
    if [ -n "$1" ]; then
        if [ "$1" = "--help" ]; then
            display_help
        else
            return 0
        fi
    fi
}

function get_my_marvin {
    args=$*
    current_project=$(get_current_project)

    if [ -n "$current_project" ]; then
        project_path=$(get_project_path "$current_project")
        my_marvin "$project_path" "$current_project"
    fi

    for project_name in $args; do
        project_path=$(get_project_path "$project_name")
        my_marvin "$project_path" "$project_name"
    done
}

check_args "$@"
get_my_marvin "$@"
