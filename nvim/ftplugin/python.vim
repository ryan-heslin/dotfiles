   setlocal cinwords=if,else,for,while,try,except,finally,def,class,with
   nnoremap <leader>sh ggO#!/usr/bin/python3<Esc><C-o>
   nnoremap \s :SlimeSend1 ipython<CR>
   nnoremap \e :w <bar> IPythonCellExecuteCell<CR>
   nnoremap \r :w <bar> IPythonCellRun<CR>
   nnoremap \p :IPythonCellPrevCommand<CR>
   nnoremap \\ :IPythonCellRestart<CR>
   nnoremap \[c :IPythonCellPrevCell<CR>
   nnoremap \]c :IPythonCellNextCell<CR>
   nnoremap \E :IPythonCellExecuteCellJump<CR>
   nnoremap \x :IPythonCellClose<CR>
   nnoremap \p :IPythonCellClear<CR>
   nnoremap \Q :IPythonCellRestart<CR>
   nnoremap \d :SlimeSend1 %debug<CR>
   nnoremap \q :SlimeSend1 exit<CR>
   " Print object under cursor
   nnoremap \pp yiW:SlimeSend1 print(<C-r><C-w>)<CR>
   xmap \o :SlimeRegionSend<CR>
   nnoremap \b :SlimeParagraphSend<CR>
   nmap \l <Plug> SlimeLineSend<CR>
   nmap \m <Plug>SlimeMotionSend<CR>

   " Set or remove breakpoints
   nnoremap \pdb Obreakpoint()<Esc>j
   nnoremap \ddb :%s/^\s*breakpoint()\s*$//
   nnoremap <leader>pd ^yWoIprint(f'<C-o>P = {<C-o>P}')<Esc>

" Special Python highlighting
augroup pycolors
  autocmd!
  autocmd ColorScheme * highlight pythonImportedObject ctermfg=127 guifg=127
   \ | highlight pythonImportedFuncDef ctermfg=127 guifg=127
   \ | highlight pythonImportedClassDef ctermfg=127 guifg=127
 \ | syntax match Type /\v\.[a-zA-Z0-9_]+\ze(\[|\s|$|,|\]|\)|\.|:)/hs=s+1
 \ | syntax match self "\(\W\|^\)\@<=self\(\.\)\@="
 \ | syntax match pythonFunction /\v[[:alnum:]_]+\ze(\s?\()/
 \ | highlight def link pythonFunction Function
 \ | highlight self ctermfg=239 guifg=239
augroup end
