let save_cpo = &cpo
set cpo&vim

function! cheat#providers#loclist#GetError()
    return cheat#providers#GetErrorFromList(getloclist(0))
endfunction

let cpo=save_cpo
" vim:set et sw=4:
