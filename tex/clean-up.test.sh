#!/bin/bash

# Unit tests for clean-up.sh script

CLEANUP_SCRIPT="${PWD}/clean-up.sh"
TEST_DIR=$(mktemp -d)

# Color output for test results
RED='\033[0;31m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m' # No Color

TESTS_PASSED=0
TESTS_FAILED=0

test_case() {
    local test_name="$TEST_CASE_NAME"
    local input="$1"
    local expected="$2"

    # Create temporary input file
    local input_file="$TEST_DIR/input.tex"
    echo -n "$input" > "$input_file"

    # exercise
    bash "$CLEANUP_SCRIPT" "$input_file" > /dev/null 2>&1
    # verify
    local result=$(cat "$input_file")
    if [ "$result" = "$expected" ]; then
#        echo -e "${GREEN}✓ PASS${NO_COLOR}: $test_name"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ FAIL${NO_COLOR}: $test_name"
        printf "  Input: %s\n" "$input"
        printf "  Expected: %s\n" "$expected"
        printf "  Got: %s\n" "$result"
        ((TESTS_FAILED++))
    fi
    # tear down
    rm -f "${input_file}"
    rm -f "${input_file}.bak"
}

TEST_CASE_NAME="Non-breaking space before short preposition"
test_case "s~naším" "s~naším"
test_case "s naším" "s~naším"
test_case "(s~naším" "(s~naším"
test_case "(s naším" "(s~naším"
test_case " (s~naším" " (s~naším"
test_case " (s naším" " (s~naším"
test_case "s  ~  naším" "s~naším"
test_case "s~  naším" "s~naším"
test_case "s  ~naším" "s~naším"
test_case "s   naším" "s~naším"
test_case "so naším" "so naším"
test_case "so   naším" "so   naším"
test_case "so ~  naším" "so~naším"
for preposition in $(echo "svzoukSVZOUKAI" | grep -o .); do
    test_case "${preposition} word" "${preposition}~word"
done

TEST_CASE_NAME="Name initials and surname"
test_case "J.~Novák" "J.~Novák"
test_case "J. Novák" "J.~Novák"
test_case "xJ. Novák" "xJ. Novák"
test_case "J. M. Novák" "J.~M.~Novák"
test_case "xJ. xM. Novák" "xJ. xM. Novák"
test_case "J.  M.  Novák" "J.  M.  Novák"
test_case "J.  ~  M.  ~  Novák" "J.~M.~Novák"

TEST_CASE_NAME="Dates - non-breaking spaces"
test_case "5.3.2024" "5.~3.~2024"
test_case "5. 3.2024" "5.~3.~2024"
test_case "5.3. 2024" "5.~3.~2024"
test_case "5. 3. 2024" "5.~3.~2024"
test_case "x5.3.2024" "x5.3.2024"
test_case "5.x3.2024" "5.x3.2024"
test_case "5.3.x2024" "5.3.x2024"
test_case "Rok  2024" "Rok~2024"
test_case "uRok 2024" "uRok 2024"
test_case "rok  2024" "rok~2024"
test_case "roku  2024" "roku~2024"
test_case "roka  2024" "roka~2024"
test_case "roky  2024" "roky~2024"
test_case "rokom  2024" "rokom~2024"
test_case "polrok  2024" "polrok~2024"
test_case "polroku  2024" "polroku~2024"
test_case "polroka  2024" "polroka~2024"
test_case "polrokom  2024" "polrokom~2024"
test_case "štvrťrok  2024" "štvrťrok~2024"
test_case "štvrťroku  2024" "štvrťroku~2024"
test_case "štvrťroka  2024" "štvrťroka~2024"
test_case "štvrťrokom  2024" "štvrťrokom~2024"
test_case "rok 20241" "rok 20241"
test_case "brok 2024" "brok 2024"

TEST_CASE_NAME="Dash/en-dash normalization"
test_case "first - second" "first -- second"
test_case "first – second" "first -- second"
test_case "first-second" "first-second"
test_case "first -second" "first -second"
test_case "first- second" "first- second"
test_case "first–second" "first–second"
test_case "first –second" "first –second"
test_case "first– second" "first– second"

TEST_CASE_NAME="Time - non-breaking spaces and dot"
test_case "hod a" "hod. a"
test_case "10   hod." "10~hod."
test_case "10:30 hod." "10.30~hod."
test_case "10,30 hod." "10.30~hod."

TEST_CASE_NAME="Euro currency - non-breaking space and symbol"
test_case "100  eur" "100~€"
test_case "100  euro" "100~€"
test_case "100  EUR" "100~€"
test_case "100  EURO" "100~€"
test_case "100  €" "100~€"
test_case "x100  €" "x100  €"
test_case "1234,56 eur" "1234,56~€"
test_case "x100 eur" "x100 eur"
test_case "100 eurX" "100 eurX"
test_case "100€" "100~€"
test_case "a€" "a€"

TEST_CASE_NAME="Quote pairs converted to opening and closing quotes"
test_case '"""' '„“„'
test_case "'''" "‚‘‚"
test_case "before \"tex\nt1\" middle \"text2\" after" 'before „tex\nt1“ middle „text2“ after'
test_case "before 'tex\nt1' middle 'text2' after" "before ‚tex\nt1‘ middle ‚text2‘ after"

TEST_CASE_NAME="Empty lines before custom TeX macros"
test_case "text\\clanok  {title}
content" "text


\\clanok{title}
content"

test_case "text

\\autor{" "text
\\autor{"
test_case "text\\autor{" "text
\\autor{"

if [ $TESTS_FAILED -eq 0 ]; then
    FINAL_MESSAGE="${GREEN}All tests ($TESTS_PASSED) passed!${NO_COLOR}"
else
    FINAL_MESSAGE="${RED}Some tests (${TESTS_FAILED}) failed!${NO_COLOR}"
fi
echo -e "
$FINAL_MESSAGE"

