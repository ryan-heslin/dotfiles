
" FUNCTIONS------------------------------------------------------------------

" Delete next {count} occurrences of a string, then return to cursor position
function! functions#JumpDelete(...)
    let count = v:count1
    let string = input("Enter pattern: ")
    if len(string) == 0
        return
    endif
    let start = getpos(".")
    let flags = "wz" . join(a:000, "")
    " Search forward or backward
    let step= (stridx(flags, "b") == -1) ? "n" : "N"

    " Set return mark
    let @/=string
    let matches = searchcount()["total"]
    let stop = min([matches, count])

    " Search for next match {count} times
    for i in range(0, stop - 1)
        execute "normal " . step
        execute "normal " . "gnx"
    endfor
    call setpos(".", start)
    call setreg("/", [])
    echo "\nRemoved " . stop . " match(es)"
endfunction

function! functions#Repeat(cmd, ...)
    let count = get(a:, 1, v:count1)
    execute count . a:cmd
endfunction

function! functions#SwapWords(...)
    let sep = get(a:, 1, " ")
    let start = getpos(".")
endfunction
" Scroll a terminal window from another window
" Based partly on last comment on
" TODO handle multiple up presses
" https://www.reddit.com/r/neovim/comments/753ztk/how_to_run_current_line_in_terminal_inside_neovim/
function! functions#TermDo(cmd)
    let count = v:count1
    for buffer_id in tabpagebuflist()
    :   " For each buffer, check if terminal - if yes, get window id
       " and send scroll command
       if getbufvar(buffer_id, "&buftype") == "terminal"
          let win_id = bufwinid(buffer_id)
          call win_execute(win_id, "normal " . count . a:cmd)
      endif
      endfor
endfunction

"TODO make actually good
function! functions#CharVec()
    execute normal "F(vf)"
   '<,'>s/\w\zs\(\s\|)\)/\"\1/g
"'<,'>s/\(\s\|(\)\ze\w/\1"/g
   "s/"\zs\ze\s/,/g
endfunction

function! functions#Sections(range_start, ...)
    let start = getpos(".")
    let range_end = get(a:, 1, v:count1)
    " If start specified but end is not, assume this is an ASCII byte shift
    let end_pos = [start[0] - range_end +2, start[1]]
    if  type(a:range_start) == 1 && type(range_end) == 0
        "redir => start_byte
        "execute "normal ascii '" . a:range_start ."'"
        "redir end
        let start_byte = char2nr(a:range_start)
        let range_end += start_byte - 1
        let range_end = nr2char(range_end)
    endif
    let depth = get(a:, 2, 3)
    execute "r! sect " . depth . " {" . a:range_start . ".." . range_end . "}"
    " Start below header 1
    call setpos(".", end_pos)
endfunction

" Knit .Rmd and open in pdf viewer on success
function! functions#Knit()
  let filename = expand("%:p")
  write
        execute  "!R -e 'rmarkdown::render(\"" . filename  . "\")'"
    " Bail out on knit error
    echom v:shell_error
    if v:shell_error != 0

        echo "Error knitting " . filename
        return
    endif
    let output_dir = expand("%:p:h")
    "Get full path of output, modifying https://stackoverflow.com/questions/3915040/how-to-obtain-the-absolute-path-of-a-file-via-shell-bash-zsh-sh
    let new = system("find " . output_dir . ' -type f \( -name "*.pdf" \) | xargs ls -1t | head -n 1')
    execute "!zathura " . new

endfunction

function! functions#PasteLines(filename)
  "execute "r !''"
endfunction

function! functions#InlineSend()
  normal F`2w"zyt`
  let text = getreg("z")
  execute "RSend " . text
endfunction
" From https://stackoverflow.com/questions/1642611/how-to-save-and-restore-multiple-different-sessions-in-vim,
" with heavy modification
function! functions#MakeSession()
  let b:sessiondir = expand("$HOME") . "/.vim/sessions" . getcwd()
  if (filewritable(b:sessiondir) != 2)
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif
  let b:filename = b:sessiondir . '/session.vim'
  exe "mksession! " . b:filename
endfunction

function! functions#SaveSession()
  let session_dir = $VIM_SESSION_DIR
  let this_session = get(g:,'CurrentSession', "")
  " If no current session name found, prompt user for one, warning if already
  " in use
  if (this_session == "")
      let CurrentSession = input("Enter session name (enter to skip): ")
      if CurrentSession == ""
          return
      endif
  else
      let CurrentSession = this_session
  endif
  let path = session_dir . "/" . CurrentSession . ".vim"
  if (filereadable(path) != 0 && this_session == "")
      let choice = input("Session '" . CurrentSession . "' already exists. Overwrite (y to overwrite, any other key to abort)? ")
      if choice != "y"
          return
      endif
  endif
  let g:CurrentSession = CurrentSession
  execute "mksession! " . path
endfunction

function! functions#LoadSession()
    let session_dir = $VIM_SESSION_DIR
    let latest_session = system("lastn " . session_dir . " 1 echo")
    echom filereadable(latest_session)
    try
        execute "source " . latest_session
    catch
        echo "Session file does not exist or cannot be read"
        return
    endtry
    echo "Loading session " . latest_session
endfunction

" From https://vi.stackexchange.com/questions/3177/use-single-ftplugin-for-more-than-one-filetype
function! functions#CheckLoaded(var)
    if exists(a:var)
        finish
    endif
endfunction
