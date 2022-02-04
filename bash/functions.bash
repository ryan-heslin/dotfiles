#!/usr/bin/bash

get(){

	z -e open -r -f "$1"
}

# Use lock file to copy directories to  Google Drive. Requires rclone setup.
cplock() {

    if [ "$#" -gt 0 ]; then
        local dirs = "($@)"
    else
        local dirs=(dotfiles gradebook misc R sh_utils .venvs Zotero)
    fi

    for dir in "${dirs[@]}"; do
        echo "$dir"
        flock -n /tmp/google_drv_sync.lock /usr/bin/rclone copy -L --transfers 20 --retries 5 "$HOME/$dir" "gdrive:/backup" &> "$HOME/backup.log"
    done
}

# cd to first directory of search result
cdf(){
    cd $(fdfind -type d --color 'never' "$1" | head -n 1)
}

install(){
    local package="$HOME/R/Packages/${1}"
    [ -d "$package" ] && R  --quiet -e "install2('${package}')"
}
# From https://coderwall.com/p/fasnya/add-git-branch-name-to-bash-prompt
parse_git_branch() {
     [ "$PWD" != "$HOME" ] && git branch --list 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
# Go to most recently opened subdirectory in directory, optionally excluding strings
lastdir() {

IFS='|'
local defaults=( ".git" ".Rproj" )
local excludes=( "$@" "${defaults[@]}" )
local pat="${excludes[*]}"
echo "$pat"
cd "$(find . -type d -printf '%T@ %p\n'  | grep -E -v "$pat" | sort -n | tail -1 | cut -f2- -d" ")"

}

# Find empty files; see https://stackoverflow.com/questions/39431747/how-to-list-empty-files-bash
lsempty(){
    find "${1:-.}" -name "${2:-*}" -type f -empty
}
nvimsess(){
local path="$VIM_SESSION_DIR/$1.vim"
[ -f $path ] && nvim "$path" "+source %" || echo "No session named $1"
}
# Test Shiny app. From https://www.r-bloggers.com/2018/09/4-ways-to-be-more-productive-using-rstudios-terminal/
testapp() {
appdir="${1:-$PWD}"
R -e "library(shiny); runApp(port = 9999, launch.browser = FALSE); rstudioapi::viewer('http://127.0.0.1:9999')"
}

# cd into chosen dir
d(){
  cd $(fd --type directory . $HOME | fzf)
}

open2 () {
	touch "$1" && nvim "$1"
}


search() {
	start "https://google.com/search?q=$(echo "$1" | sed -r 's/\s/\+/')"
}

oa() {
	local glob="*$1*"
	open "$1*.$2"
}

msearch() {

	local searches=( "$@" )
	for s in "${searches[@]}"; do
		start "https://google.com/search?q=${s// /+}"
	done

}

apply() {

	local cmd="$1"; shift 1
	local args=( "$@" )
	for arg in "${args[@]}"; do
		"$cmd" "$arg"
	done
}

mvall() {

	mv *$1* "$2"
}

#ranges don't expand vars
updir() {

  local cmd=".."
  for ((i = 1;i < $1;i++)); do
    cmd="${cmd}/.."
  done
  cd $cmd
}

#one-comamnd git add, commit, push
gitf() {
	git add -A
	git commit -m "$1"
	git ls-remote && git push && git reflog
}

#Replace name placeholder in filenames
namesub() {
	local name="ryanheslin"
	local new="${1/yourname/$name}"
	mv "$1" "$new"
	echo "Renamed $1 $new"

}

# cd then list all
cdl() {

cd "$1"
ls -a
}

#open all with substring, or by optional command
pat() {
	local cmd="open"
	if [ $# -eq 2 ]
	then
		cmd="$2"
	fi;
	"$cmd" *$1* || echo "No file in $PWD matches pattern $1"
}

# Rename file referenced by a path
rn () {
	local path="${1%/*}/" || echo "Invalid path"
	mv "$1" "$path$2"
}

#Find all files with given extension and rename with new one.
rename_exten() {
local old=$1
local new=$2

for file in *$old; do
	mv "$file" "${file%.*}.$new" || echo "$file could not be renamed"
	echo "Renamed $file to ${file%.*}.$new"
done

}

# Delete both local and upstream branches
shear(){

PS3="Type the name of branch $1 to confirm local and upstream deletion: "
local opts=("$1")
select opt in "${opts[@]}"
do
	case "$opt" in
		"${opts[1]}")
			echo "Deleting branch $1"
			git branch -d "$1"
			git push origin --delete "$1"
	;;
	*) break;;
	esac
done

}

#Open by range of numeric prefix
nfiles(){

local dir="${3:-.}"
local prefix=( $(seq -w $1 $2) )

for pref in "${prefix[@]}"; do
	open "$dir"/"$pref"*
done
}

#Pull single file from repo
grab (){
	git checkout origin/main "$1"
}

rmd_head (){

local head="---
title: \""$2"\"
author: \"Ryan Heslin\"
date: \"\`r format(Sys.Date(), '%B %m, %Y')\`\"
output: ${3:-pdf_document}
---"

echo -e "$head\n$(cat "$1")" > "$1"
open "$1"
}

#Delete misbegotten file
undo (){
	find "$1" -maxdepth 1 -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" " | xargs rm -i -V

}

# Get most recent files
lastn (){

	local n=${2:-1}
	local cmd="${3:echo}"
	find "$1" -maxdepth 1 -type f -printf '%T@ %p\n' | sort -rn | head -$n | cut -f2- -d" " | xargs $cmd
}

#Output range of lettered or numbered sections
sect(){
local depth=${1:-3}
shift 1
local chars=( "$@" )
# Copied from this hero
local header="$(eval "printf '#%.0s' {1.."$(($depth))"}") "
local chars=("${chars[@]/#/$header}")

printf "%s.\n\n" "${chars[@]}"

}

# "Git record" - show formatted commits
#gr(){
#	git log --pretty=format:"%cn, %cr: %s"

#}
#git switch
gsw (){
 git switch "$1"
}

# Suggested by fzf rEADME
#_fzf_compgen_path() {
  #fd --hidden --follow --exclude ".git" . "$1"
#}
#
## Use fd to generate the list for directory completion
#_fzf_compgen_dir() {
  #fd --type d --hidden --follow --exclude ".git" . "$1"
#}
knit(){
  argexec 'R -e' 'rmarkdown::render' "$1" "${@:2}"
}


# Crete new file, opening with comment
newf(){

 if [ ! -f "$1" ]; then
   touch "$1"
   printf "# %s\n# Ryan Heslin\n# %s\n\n" "$(basename $1)" "$(date +'%m/%d/%Y')" > "$1"
   nvim "+normal G" +startinsert "$1"
 else
   echo "$1 already exists"
  fi
}

draft2(){

  local args=("$@")
  IFS="|"
  #Split filename and arg list by |, then build and execute command
  for arg in "${args[@]}";do
    read -r -a split <<< "${arg}"
    argexec 'R -s -e' draft2 "'${split[0]}'" "'${split[1]}'" "${split[2]}" "open=${split[3]:-TRUE}"
  done
}

# Execute
argexec(){
    local cmd="$1"
    local fun="$2"
    shift 2
    IFS=","
    local cmd="${cmd} \"${fun}($*)\""
    echo "$cmd"
    eval "$cmd"
}

# Copy to xclip
cc(){
    cat "$1" | xclip -i -selection clipboard
}

# xclip paste
cv(){
    xclip -o || echo ""
}

cs(){
echo "$1" | xclip -selection clipboard
}

dbconv(){
    curl -F files[]=@"$1".accdb 'https://www.rebasedata.com/api/v1/convert?outputFormat=sqlite&errorResponse=zip' -o "${2:-output}".zip
}

exists(){
    command -v "$1" &>/dev/null
}
fzn(){
    exists nvim && nvim $(fzf)
}
# Go into parent directory by name
cu(){
  cd "${PWD%/$1/*}" && cd "$1"
}

#Get line or range of lines
li(){
    [ -f "$1" ] && tail -n+"$2" "$1" | head -n"${3:-1}"
}
fromc(){

	cat /dev/clipboard > "$1"
}

toc(){

cat < /dev/clipboard
}

# rename with
rewith(){

for file in *"$1"*; do
	local new="$(echo ${file} | sed  "s/$1/$2/")"
	mv "$file" "$new"
done
}

# Strip carriage returns
decarriage(){
	sed -i 's/\r$//' $1
}

rev(){
    nvim "$1" "+u" "+wq"
}

# Toggle VM pause
vmtoggle(){
        if  VB showvminfo "$VM_NAME" | grep -E 'State\:\s+running'; then
                VBoxManage controlvm "$VM_NAME" pause
        else
                VBoxManage controlvm "$VM_NAME" resume
        fi
}

# From https://github.com/dylanaraps/pure-bash-bible#get-the-current-cursor-position
new_line_ps1() {
  local _ y x _
  local LIGHT_YELLOW="\001\033[1;93m\002"
  local RESET="\001\e[0m\002"

  IFS='[;' read -p $'\e[6n' -d R -rs _ y x _
  if [[ "$x" != 1 ]]; then
    printf "\n${LIGHT_YELLOW}^^ no newline at end of output ^^\n${RESET}"
  fi
}

_sess_complete(){
    local cur=${COMP_WORDS[COMP_CWORD]} #find ~/.vim/sessions/ -maxdepth 1 -type f
    COMPLETE=( $( compgen -W "$( ls ~/.vim/sessions )" -- $cur ) )
    COMREPLY=($(printf "%s\n" "${COMPLETE[@]}"))
}

complete  -F _sess_complete nvimsess

# Remove all broken symlinks in a directory. See https://linuxize.com/post/how-to-remove-symbolic-links-in-linux/
delink() {

    find "${1:-.}" -xtype l -delete
}

testPyPi(){
    python3 -m pip install --force-reinstall --user --index-url https://test.pypi.org/simple/ --upgrade --no-deps "${1}"
}

# Download Advent of Code data. Partly based on https://github.com/ritobanrc/aoc2021/blob/main/get
get_AoC(){

    # Adapted from
    local verbose=false
    local AoC_dir="$HOME/misc/AoC"
    local last_valid_year=$(date +"%-Y")
    while [ "$#" -gt 0 ]; do
        key="$1"
        case $key in
            -d|--day)
                local day="$2"
                #Confirm day is valid
                if ! (  [ "$day" -ge 1 ] && [ "$day" -le 25 ] );  then
                    echo "$day is not a valid Advent of Code day. Valid: 1-25"
                    return 1
                fi
                shift
                shift
                ;;
            -y|--year )
                # Confirm specified year is this year (if the month is December), or last year (otherwise)
                local year="$2"
                if [ $(date +"%-m") -lt 12 ]; then
                    local last_valid_year=$(( last_valid_year - 1 ))
                fi
                #Confirm year is valid
                if ! ( [[ "$year" =~ ^[0-9]{4}$ ]] && [ "$year" -ge 2015 ] && [ "$year" -le $last_valid_year ] );  then
                    echo "$year is not a valid Advent of Code year. Valid: 2015-$last_valid_year"
                    return 1
                fi
                shift
                shift
                ;;
            -c|--cookie)
                local cookie="$2"
                shift
                shift
                ;;
            -v|--verbose)
                local verbose=true
                shift
                ;;
            -f|--aoc_dir)
                local aoc_dir="$2"
                shift
                shift
                ;;
            *)
                echo "Unknown option $key"
                return 1
                ;;
        esac
    done


    #Use environment variable if it exists, otherwise throw error
    if [ -z "${cookie+x}" ]; then
        if [ -n "${AOC_COOKIE+set}" ]; then
            local cookie="$AOC_COOKIE"
        else
            echo 'No cookie parameter provided and no cookie environment variable set'
            return 1
        fi
    fi

    if [ -z "${day+x}" ]; then
        local day=$(date +"%-e")
    fi

    if [ -z "${year+x}" ]; then
        local year=$last_valid_year
    fi

    local file="$AoC_dir/$year/inputs"
    # Make AoC directory if it doesn't already exist
    if ! [ -d  "$file" ]; then
        mkdir -p "$file"
        echo "Making new directory $file"
    fi

    local file="$file/day$day.txt"

    if [ "$verbose" = true ]; then
         echo "Getting input for Day $day of $year"
    fi

    curl -sS -o "$file" -b "$cookie" "https://adventofcode.com/$year/day/$day/input"
}

# Retrieve secret from secret-tool and copy to clipboard
secretget(){
    local st="$(which secret-tool)"
    read -s -p 'Password: ' password
    echo ''
    local secret="$($st lookup $1 $password)"
    [ -n "$secret" ] && cs "$secret" || echo "Secret not found"
}

# Build Python package and upload to test-PyPi
rebuild(){
    local package="$(basename $(realpath .))"
    [ -d ."/dist" ] && rm -r "./dist"
    [ -d ."/src/$package.egg-info" ] && rm -r "./src/$package.egg-info"
    python3 -m build || echo "Error building $package"
    python3 -m twine upload --repository testpypi dist/*
}

ts(){
    date +"%d-%m-%Y"
}

delock(){
    rm -rf "$HOME/$R_USER_LIBRARY0*"
}

# Get Zotero library IDs corresponding to query
zotid(){
    zotcli query "$1" | grep -oP "([A-Z0-9]{8})(?=\])"
}

get627(){
local file="week$1.Rmd"
   [ -f "$file" ] && echo "File already exists" || curl -fLo "week$1.Rmd" "https://emilhvitfeldt.github.io/AU-2022spring-627/templates/labs-$(printf "%02d" "$1").Rmd"
}
