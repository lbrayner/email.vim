" File Information:
" Email Completion 1.02 for Vim >= 6.0
" Todd Boland <itodd@itodd.org> http://www.itodd.org/
"
" Thanks to: Luc Hermitte <hermitte@free.fr>
"
" Install Details:
" Note: This script depends on the following basic unix tools: grep, sort,
" uniq, wc and xargs. Feel free to hack it up for other OSs
"
" First create a ~/.addresses file. In this file put a list of addresses
" separated by new lines. Duplicates will be automatically ignored.
"
" Load the script:
" :source /path/to/email.vim

" If you'd like the script to automatically load when editing a mutt email,
" add the following line to your ~/vimrc:
" au BufRead /tmp/mutt* source ~/email.vim
"
" Then on a new line type:
" To: start_of_emai<tab>
"
" where "start_of_emai" is the begining of an email address listed in
" ~/.addresses

" Where to look for addresses
let s:addresses = '~/.addresses'

" Function to snag the current string under the cursor
function! s:SnagString( line )

    " Set column number
    let column =    col('.')-1

    " Split up line     line    start   end
    let begining = strpart( a:line, 0,  column)

    " Setup string      source      regex
    let string = matchstr(  begining,   '\S*$')

    return string
endfunction

" Function to match a string to an email address
function! s:MatchAddress(string)

    return systemlist('cat '.s:addresses.' | grep -i "'.escape(a:string,'\\').'"'
                \.' | sort')
endfunction

function! email#EmailComplete(findstart, base)
    if a:findstart
        " locate the start of the word
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] !~ '\s'
            let start -= 1
        endwhile
        return start
    endif

    " Fetch current line
    let line = getline(line('.'))

    " Is it a special line?
    if line =~ '^\(To\|Cc\|Bcc\|From\|Reply-To\):'

        " Fetch current string under cursor
        let string = a:base
        let string_length = strlen(string)
        if string_length > 0
            let completionlist = s:MatchAddress( string )
            return completionlist
        endif
    endif
    return []
endfunction
