#!/usr/bin/env bash

Test() {
    title="$1"
    actual="$2"
    expected="$3"
    if [ "$actual" == "$expected" ]; then
        echo -e "\e[32mtest \e[34m${title}\e[32m passed :)\e[39m"
        return 1
    fi
    echo -e "\e[31mtest \e[34m${title}\e[31m failed :(\e[39m"
    echo -ne "\t\e[31mexpected:\e[39m "
    echo -e "\e[34m<\e[39m${expected}\e[34m>\e[39m"
    echo -ne "\t\e[31mactual:\e[39m "
    echo -e "\e[34m<\e[39m${actual}\e[34m>\e[39m"
    return 0
}

Test "error no args" "$(./201yams 2>&1)" "Error: bad number of arguments (try ./201yams -h)"
Test "error too much args" "$(./201yams 0 0 0 0 0 yams_1 toomuch 2>&1)" "Error: bad number of arguments (try ./201yams -h)"
Test "error dice not an int" "$(./201yams aze 0 0 0 0 yams_1 2>&1)" "Error: dice value is a string"
Test "error dice outside range" "$(./201yams 7 0 0 0 0 yams_1 2>&1)" "Error: dice value out of range 0-6"
Test "error not a pattern" "$(./201yams 0 0 0 0 0 quinte_5 2>&1)" "Error: unknown pattern: quinte_5"
Test "error bad pattern" "$(./201yams 0 0 0 0 0 yams_0 2>&1)" "Error: unknown pattern: yams_0"
Test "error bad straight" "$(./201yams 0 0 0 0 0 straight_4 2>&1)" "Error: unknown pattern: straight_4"
Test "error bad full" "$(./201yams 0 0 0 0 0 full_1_1 2>&1)" "Error: bad full"
Test "kallax is cool" "bah non en fait" "true"

Test "pair_2 without dices" "$(./201yams 0 0 0 0 0 pair_2)" "Chances to get a 2 pair: 19.62%"
Test "pair_2 with one valid dice" "$(./201yams 1 4 3 2 5 pair_2)" "Chances to get a 2 pair: 51.77%"
Test "pair_2 with two valid dices" "$(./201yams 1 2 3 2 5 pair_2)" "Chances to get a 2 pair: 100.00%"
Test "pair_2 with three valid dices" "$(./201yams 2 2 3 2 5 pair_2)" "Chances to get a 2 pair: 100.00%"
Test "pair_2 with four valid dices" "$(./201yams 2 2 3 2 2 pair_2)" "Chances to get a 2 pair: 100.00%"
Test "pair_2 with five valid dices" "$(./201yams 2 2 2 2 2 pair_2)" "Chances to get a 2 pair: 100.00%"

Test "three_2 without dices" "$(./201yams 0 0 0 0 0 three_2)" "Chances to get a 2 three-of-a-kind: 3.55%"
Test "three_2 with one valid dice" "$(./201yams 1 4 3 2 5 three_2)" "Chances to get a 2 three-of-a-kind: 13.19%"
Test "three_2 with two valid dices" "$(./201yams 1 2 3 2 5 three_2)" "Chances to get a 2 three-of-a-kind: 42.13%"
Test "three_2 with three valid dices" "$(./201yams 1 2 2 2 5 three_2)" "Chances to get a 2 three-of-a-kind: 100.00%"
Test "three_2 with four valid dices" "$(./201yams 2 2 3 2 2 three_2)" "Chances to get a 2 three-of-a-kind: 100.00%"
Test "three_2 with five valid dices" "$(./201yams 2 2 2 2 2 three_2)" "Chances to get a 2 three-of-a-kind: 100.00%"

Test "four_2 without dices" "$(./201yams 0 0 0 0 0 four_2)" "Chances to get a 2 four-of-a-kind: 0.33%"
Test "four_2 with one valid dice" "$(./201yams 1 4 3 2 5 four_2)" "Chances to get a 2 four-of-a-kind: 1.62%"
Test "four_2 with two valid dices" "$(./201yams 1 2 3 2 5 four_2)" "Chances to get a 2 four-of-a-kind: 7.41%"
Test "four_2 with three valid dices" "$(./201yams 1 2 2 2 5 four_2)" "Chances to get a 2 four-of-a-kind: 30.56%"
Test "four_2 with four valid dices" "$(./201yams 2 2 3 2 2 four_2)" "Chances to get a 2 four-of-a-kind: 100.00%"
Test "four_2 with five valid dices" "$(./201yams 2 2 2 2 2 four_2)" "Chances to get a 2 four-of-a-kind: 100.00%"

Test "yams_2 without dices" "$(./201yams 0 0 0 0 0 yams_2)" "Chances to get a 2 yams: 0.01%"
Test "yams_2 with one valid dice" "$(./201yams 1 4 3 2 5 yams_2)" "Chances to get a 2 yams: 0.08%"
Test "yams_2 with two valid dices" "$(./201yams 1 2 3 2 5 yams_2)" "Chances to get a 2 yams: 0.46%"
Test "yams_2 with three valid dices" "$(./201yams 1 2 2 2 5 yams_2)" "Chances to get a 2 yams: 2.78%"
Test "yams_2 with four valid dices" "$(./201yams 2 2 3 2 2 yams_2)" "Chances to get a 2 yams: 16.67%"
Test "yams_2 with five valid dices" "$(./201yams 2 2 2 2 2 yams_2)" "Chances to get a 2 yams: 100.00%"

Test "full_2_3 without dices" "$(./201yams 0 0 0 0 0 full_2_3)" "Chances to get a 2 full of 3: 0.13%"
Test "full_2_3 with one valid dice" "$(./201yams 1 4 3 1 5 full_2_3)" "Chances to get a 2 full of 3: 0.31%"
Test "full_2_3 with two valid dices" "$(./201yams 1 2 3 1 5 full_2_3)" "Chances to get a 2 full of 3: 1.39%"
Test "full_2_3 with three valid dices" "$(./201yams 1 3 2 2 5 full_2_3)" "Chances to get a 2 full of 3: 5.56%"
Test "full_2_3 with four valid dices" "$(./201yams 2 2 3 2 2 full_2_3)" "Chances to get a 2 full of 3: 16.67%"
Test "full_2_3 with five valid dices" "$(./201yams 3 2 3 2 2 full_2_3)" "Chances to get a 2 full of 3: 100.00%"

Test "straight_5 without dices" "$(./201yams 0 0 0 0 0 straight_5)" "Chances to get a 5 straight: 1.54%"
Test "straight_5 with one valid dice" "$(./201yams 1 1 1 1 1 straight_5)" "Chances to get a 5 straight: 1.85%"
Test "straight_5 with two valid dices" "$(./201yams 1 2 1 1 1 straight_5)" "Chances to get a 5 straight: 2.78%"
Test "straight_5 with three valid dices" "$(./201yams 1 3 1 2 1 straight_5)" "Chances to get a 5 straight: 5.56%"
Test "straight_5 with four valid dices" "$(./201yams 4 1 3 2 2 straight_5)" "Chances to get a 5 straight: 16.67%"
Test "straight_5 with five valid dices" "$(./201yams 1 2 5 4 3 straight_5)" "Chances to get a 5 straight: 100.00%"