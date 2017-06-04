if !exists('g:googledocstrings_author')
    let g:googledocstrings_author = ''
endif

if !exists('g:googledocstrings_authorshort')
    let g:googledocstrings_authorshort = ''
endif

if !exists('g:googledocstrings_email')
    let g:googledocstrings_email = ''
endif

if !exists('g:googledocstrings_todo')
    let g:googledocstrings_todo = 'TODO'
    if len(g:googledocstrings_authorshort) > 0
        let g:googledocstrings_todo = g:googledocstrings_todo . '(' . g:googledocstrings_authorshort . ')'
    endif
endif
