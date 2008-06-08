"=============================================================================
" File:        occur.vim
" Author:      FURUSAWA, Noriyoshi (noriyosi xxx gmail dot com) xxx=@,dot=.
" Last Change: 2008/6/8
" Version:     0.01
"=============================================================================

if exists('loaded_occur') || &cp
    finish
endif
let loaded_occur=1

if v:version < 700
    echo "Sorry, occur ONLY runs with Vim 7.0 and greater."
    finish
endif

" Key bind
nmap <silent> <unique> <Leader>oc :Occur<CR>
nmap <silent> <unique> <Leader>mo :Moccur<CR>

" Create commands
command! Occur silent call s:SetupAndGo('s:Occur')
command! Moccur silent call s:SetupAndGo('s:Moccur')

function! s:Occur()
    let expr = 'caddexpr expand("%") . ":" . line(".") .  ":" . getline(".")'
    exec 'silent keepjumps g/' . @/ . '/' . expr
endfunction

function! s:Moccur()
    " Create the buffer list
    redir => command_out
    ls
    redir END

    let buffers = []
    for line in split(command_out, '\n')
        call add(buffers, split(line, ' ')[0])
    endfor

    " Search the pattern in all buffers
    for buf_number in buffers
        exec 'keepjumps buffer ' . buf_number
        call s:Occur()
    endfor
endfunction

function! s:SetupAndGo(func)
    " Clear the results window
    cexpr "================= occur result ================="
    cclose

    " Log the current point
    +1

    call function(a:func)()

    " Open the results window
    keepjumps cfirst 2
    cwindow
endfunction

