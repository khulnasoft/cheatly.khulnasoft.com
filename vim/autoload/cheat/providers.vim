let save_cpo = &cpo
set cpo&vim

" Providers
if(!exists("g:CheatSheetProviders"))
    let g:CheatSheetProviders=['quickfix', 'syntastic']
endif

" Returns the first error on the current buffer
function! cheat#providers#GetErrorFromList(errors)
    if(empty(a:errors))
        return ''
    endif
    let line=getpos('.')[1]
    let firstErr=""
    let error=""
    for err in a:errors
        if(error == "" && (err.type ==? "E" || 
                    \ err.type=='' && match(err.text, 'ERROR\c')!=-1))
            " Save first error
            let error = err.text
        endif
        if(err.lnum == line)
            " Found something on currentline
            let error=err.text
            break
        endif
    endfor
    if(error == "")
        " Default to first line of errors
        let error=a:errors[0].text
    endif
    return error
endfunction

function! s:PrepareQuery(text)
    " Remove ending [blabla], replace space by plus, sanitize, trim +
    return substitute(substitute(substitute(substitute(a:text,
                        \'\[[^\]]*\]$\|([^)]*)', '', 'g'),
                        \'\s\s*', '+', 'g'),
                        \ "‘\\|’\\|\\[\\|\\]\\|\"\\|'\\|(\\|)", '', 'g'),
                        \'^+*\|+*$', '', 'g')
endfunction

function! cheat#providers#GetError()
    for provider in g:CheatSheetProviders
        let query=function('cheat#providers#'.provider.'#GetError')()
        if(query != "")
            return s:PrepareQuery(query)
        endif
    endfor
    return ""
endfunction

function! cheat#providers#TestPrepareQuery()
    let text="'bla' bli (remove) b‘lo’ [blu] \"plop\" (remove) [also to remove]"
    echo text
    echo s:PrepareQuery(text)
endfunction

let cpo=save_cpo
" vim:set et sw=4:
