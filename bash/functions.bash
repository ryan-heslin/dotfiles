#!/usr/bin/bash

# Show command help
h() {
    which "$1" && "$1" --help | batcat
}

# Use lock file to copy directories to  Google Drive. Requires rclone setup.
cplock() {

    if [ "$#" -gt 0 ]; then
        local dirs=( "$@" )
    else
        local dirs=("dotfiles" "misc" "R")
    fi

    for dir in "${dirs[@]}"; do
        echo "$HOME/$dir"
        flock -n /tmp/google_drv_sync.lock /usr/bin/rclone copy -L --transfers 20 --retries 5 "$HOME/$dir" "gdrive:/backup" &> "$HOME/backup.log"
    done
}

# cd to first directory of search result
cdf(){
    cd "$(fdfind --type d --color 'never' --ignore-file "$DOTFILES_DIR/misc/.ignore" . "$HOME" |
        grep "$1" |
        head -n 1)" || exit
}

install(){
    local package="$HOME/R/Packages/${1}"
    [ -d "$package" ] && R  --quiet -e "install2('$package')"
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
cd "$(find . -type d -printf '%T@ %p\n'  | grep -E -v "$pat" | sort -n | tail -1 | cut -f2- -d" ")" || exit

}

# Find empty files; see https://stackoverflow.com/questions/39431747/how-to-list-empty-files-bash
lsempty(){
    find "${1:-.}" -name "${2:-*}" -type f -empty
}

nvimsess(){
#TODO parse args, including extra for command
    local session="$1"
    local path="$VIM_SESSION_DIR/$1.vim"

    [ -f "$path" ] && nvim "$path" "+source %" "+let g:current_session='$session'" || echo "No session named $session"
}

fsearch (){
    #TODO generate fdfind commands
    local name="$1"
    local cmd="$2"
    local args=( "$@" )
    shift 1
    #local types=( "${$args[@]/#/--type }" )

}

# Use FZF to search for directories by name
d(){
    cd "$(fdfind --type directory --ignore-file "$DOTFILES_DIR/misc/.ignore" . "$HOME" | fzf)" || exit
}

# Open selected with nvim
nvimd(){
    nvim "$(fdfind --type file --type symlink --ignore-file "$DOTFILES_DIR/misc/.ignore" | fzf)"
}

batd(){
    batcat "$(fdfind --type file --type symlink --ignore-file "$DOTFILES_DIR/misc/.ignore" | fzf)"
}

search() {
	start "https://google.com/search?q=$(echo "$1" | sed -r 's/\s/\+/')"
}

# Open all
oa() {
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
	mv ./*"$1"* "$2"
}

#Go up number of parent directories
updir() {
  local cmd=".."
  for ((i = 1;i < $1;i++)); do
    cmd="$cmd/.."
  done
  cd "$cmd" || exit
}

#one-comamnd git add, commit, push
gitf() {
    if [ $# -eq 0 ]; then
        echo "No commit message provided"
    fi
	git add -A
	git commit -m "$1"
	git ls-remote && git push && git reflog
}

#Replace name placeholder in filenames
# cd then list all
cdl() {
cd "$1" || exit
ls -a
}

#open all with substring, or by optional command
pat() {
	local cmd="open"
	if [ $# -eq 2 ]
	then
		cmd="$2"
	fi;
	"$cmd" ./*"$1"* || echo "No file in $PWD matches pattern $1"
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

for file in *."$old"; do
	mv "$file" "${file%.*}.$new" || echo "$file could not be renamed"
	#echo "Renamed $file to ${file%.*}.$new"
done

}

#Open by range of numeric prefix
nfiles(){
local dir="${3:-.}"
local prefix=( "$(seq -w "$1" "$2")" )

for pref in "${prefix[@]}"; do
	open "$dir"/"$pref"*
done
}

#Pull single file from repo
grab (){
	git checkout origin/main "$1"
}

rmd_head (){

local head='---
title: \""$2"\"
author: \"Ryan Heslin\"
date: \"\`r format(Sys.Date(), '%B %m, %Y')\`\"
output: ${3:-pdf_document}
---'

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
	find "$1" -maxdepth 1 -type f -printf '%T@ %p\n' | sort -rn | head -"$n" | cut -f2- -d" " | xargs "$cmd"
}

#Output range of lettered or numbered sections
sect(){
    local depth=${1:-3}
    shift 1
    local chars=( "$@" )
    # Copied from this hero
    local header
    header="$(eval "printf '#%.0s' {1.."$((depth))"}") "
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
   printf "# %s\n# Ryan Heslin\n# %s\n\n" "$(basename "$1")" "$(date +'%m/%d/%Y')" > "$1"
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
    read -r -a split <<< "$arg"
    argexec 'R -s -e' draft2 "'${split[0]}'" "'${split[1]}'" "${split[2]}" "open=${split[3]:-TRUE}"
  done
}

# Execute
argexec(){
    local cmd="$1"
    local fun="$2"
    shift 2
    IFS=","
    local cmd="$cmd \"$fun($*)\""
    echo "$cmd"
    eval "$cmd"
}

# Copy to xclip
# tc(){
#     cat "$1" | xclip -i -selection clipboard
# }

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
    exists nvim && nvim "$(fzf)"
}
#
# Go into parent directory by name
cu(){
  cd "${PWD%/"$1"/*}" || exit && cd "$1" || exit
}

#Get line or range of lines
li(){
    [ -f "$1" ] && tail -n+"$2" "$1" | head -n"${3:-1}"
}

# rename with
rewith(){
for file in *"$1"*; do
    local new
	new="$(echo "$file" | sed "s/$1/$2/")"
	mv "$file" "$new"
done
}

# Strip carriage returns
decarriage(){
	sed -i 's/\r$//' "$1"
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
    printf "\n$LIGHT_YELLOW^^ no newline at end of output ^^\n$RESET"
  fi
}

_sess_complete(){
    local cur=${COMP_WORDS[COMP_CWORD]} #find ~/.vim/sessions/ -maxdepth 1 -type f
    COMPLETE=( "$( compgen -W "$( ls ~/.vim/sessions )" -- "$cur" )" )
    COMREPLY=("$(printf "%s\n" "${COMPLETE[@]}")")
}

complete  -F _sess_complete nvimsess

# Remove all broken symlinks in a directory. See https://linuxize.com/post/how-to-remove-symbolic-links-in-linux/
delink() {
    find "${1:-.}" -xtype l -delete
}

testPyPi(){
    python3 -m pip install --force-reinstall --user --index-url https://test.pypi.org/simple/ --upgrade --no-deps "${1}"
}

date_before(){
    local target="$1"
    local now
    now="$(date '+%Y-%m-%d')"
    if [ "$now" \< "$target" ]; then
        return 1
    else
        return 0
    fi
}

# Download Advent of Code data. Partly based on https://github.com/ritobanrc/aoc2021/blob/main/get
# Broken for unclear reasons
get_AoC(){
    # () => Most recent valid day, most recent valid year
    # year => Most recent valid day, year
    # day => Most recent valid year
    # day, year => try day and year
    # If no day, default to most recent valid day
    local verbose=false
    local AoC_dir="$HOME/misc/AoC"
    local current_year
    current_year=$(date +"%-Y")
    if [ "$(date +"%-m")" -lt 12 ]; then
        local current_year=$(( current_year - 1 ))
    fi

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
                #Confirm year is between 2015 and last valid year inclusive
                if ! ( [[ "$year" =~ ^[0-9]{4}$ ]] && [ "$year" -ge 2015 ] && [ "$year" -le "$current_year" ] );  then
                    echo "$year is not a valid Advent of Code year. Valid: 2015-$current_year"
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
                local AoC_dir="$2"
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
    if [ "${cookie+x}" = "" ]; then
        if [ "${AOC_COOKIE+set}" != "" ]; then
            local cookie="$AOC_COOKIE"
        else
            echo 'No cookie parameter provided and no cookie environment variable set'
            return 1
        fi
    fi


    current_day=$(date +'%d')
    current_month=$(date +'%m')
    #TODO find latest valid day given year
    if [ "${year+x}" = "" ] || [ "${day+x}" = "" ]; then
        if [ "$current_day" -gt 25 ] && [ "$current_day" -lt 1 ] || [ "$current_month" -ne 12 ]; then
            echo "Automatic selection only works during Advent"
            return 1
        fi
        # Must be Advent, so assured to work
        if [ "${year+x}" = "" ]; then
            year=current_year
        else
            day=current_day
        fi
        if [ "$day" -gt "$current_day" ]; then
            echo "Invalid day; not yet December ${day}"
            return 1
        fi
    fi


    local inputs_dir="$AoC_dir/$year/inputs"
    # Make AoC directory if it doesn't already exist
    if ! [ -d  "$inputs_dir" ]; then
        mkdir -p "$inputs_dir"
        echo "Making new directory $inputs_dir"
    fi

    local path="$inputs_dir/day$day.txt"

    if [ "$verbose" = true ]; then
         echo "Getting input for Day $day of $year"
    fi
    echo "https://adventofcode.com/$year/day/$day/input"

    # Eric Wastl would appreciate it if you identified yourself in the download request
    curl -A 'Ryan Heslin - rwheslin@gmail.com' -fsS -o "$path" -b "$cookie" "https://adventofcode.com/$year/day/$day/input"
    return 0
}

# Retrieve secret from secret-tool and copy to clipboard
secretget(){
    local st
    st="$(which secret-tool)"
    read -s -p -r 'Password: ' password
    echo ''

    local secret
    secret="$("$st" lookup "$1" "$password")"
    [ "$secret" != "" ] && cs "$secret" || echo "Secret not found"
}

# Build Python package and upload to test-PyPi
rebuild(){
    local package
    package="$(basename "$(realpath .)")"
    [ -d ."/dist" ] && rm -r "./dist"
    [ -d ."/src/$package.egg-info" ] && rm -r "./src/$package.egg-info"
    python3 -m build || echo "Error building $package"
    python3 -m twine upload --repository testpypi dist/*
}

ts(){
    date +"%d-%m-%Y"
}

# Get Zotero library IDs corresponding to query
zotid(){
    zotcli query "$1" | grep -oP "([A-Z0-9]{8})(?=\])"
}


# Set window opacity, from https://tipsonubuntu.com/2018/11/12/make-app-window-transparent-ubuntu-18-04-18-10/
opac(){
    #local level="$(echo "${1:80}" | bc -l)"
    local target=${1:0.8}
    local dec=$((1-target))

    transset --click -v "$target"
}

# Rename file in directory by different name in same directory
rn(){
    mv "${1}" "$(dirname "${1}")/${2}"
}

# Quietly run job and disown
qz(){
    nohup zathura "$HOME/R/Resources/${1}" &> /dev/null &
}

# "With bat"
wbat(){
 "$1" | bat
}

# Kill last job(s) by search
kl() {
pgrep "$1" | tail -n "${2:1}" | xargs kill
}


# Git status that excludes output by a regex; useful for filenames
gse(){
    git -c color.status=always status | grep --color=always -vE "$1"
}

show(){
local name="$1"
local file="$2"
local printer
printer="$()"
local extension="${file##*.}"
awk "/^ *$name\(.*?\) *\{ *$/,/^ *} *$/" "$file" | bat -l "$extension"
}

prebuild(){
local cmd="$1"
poetry build
poetry install
poetry run "$cmd"
}

# Get command at specified line of history
hline(){
history | grep "$1" | head -n 1 | sed -E 's/^\s*[0-9]+\s*//g'  | xclip -selection clipboard
}

# Create new quarto file
qdraft(){
    local new_file
    new_file="$(echo "${1}" | grep '\.qmd$' || echo "${1}.qmd")"
    cp "${HOME}/dotfiles/nvim/templates/skeleton.qmd" "${new_file}"
    nvim "${new_file}"
}

validate_AoC(){
    local day="$1"
    local year="$2"
    local current_day="(date +'%d')"
    local current_month="(date +'%m')"
    local candidate
    candidate="$(date -d "$year"-12-"$day")"
    local today
    today="$(date +'%Y-%m-%d')"
    if [ "$day" -lt 26 ] && [ "$day" -gt 0 ] && ([ "$candidate" = "$today" ] || [ "$candidate" \< "$today" ]); then
        return 0
    else
        return 1
    fi
}

# Ready Python files for commit
prec(){
    poetry run task format
    poetry run task sort
    poetry run flake8
}

# Remove annoying Neovim Shada files
dshada(){
    rm "$HOME/.local/state/nvim/shada/*tmp*"
}

# Print list of all installed R packages
rlib(){ 
    R -s -e "installed.packages() |> rownames() |> sort() |> paste(collapse = ',') |> cat('\n')" |
         head -n -2 | 
         tail -n -1
}
