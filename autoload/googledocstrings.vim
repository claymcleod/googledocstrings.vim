if !exists('g:googledocstrings_author')
    let g:googledocstrings_author = ''
endif

if !exists('g:googledocstrings_todo')
    let g:googledocstrings_todo = 'TODO'
    if len(g:googledocstrings_author) > 0
        let g:googledocstrings_todo = g:googledocstrings_todo . '(' . g:googledocstrings_author . ')'
    endif
endif
