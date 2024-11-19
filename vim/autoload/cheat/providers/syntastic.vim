let g:save_cpo = &cpo
set cpo&vim

let s:errors=[]

function! cheat#providers#syntastic#GetError()
    return cheat#providers#GetErrorFromList(s:errors)
endfunction

function! cheat#providers#syntastic#Hook(errors)
    let s:errors=a:errors
endfunction

" vim:set et sw=4:
