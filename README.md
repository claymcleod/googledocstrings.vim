This is a VIM plugin I wrote to satisfy my personal needs during Python documentation. There are many things I didn't bother to test, such as tabs instead of spaces. If there are things you'd like to see, submit a pull request!

TODO
----

* Assumes you use spaces instead of tabs.

Usage
-----

I've added this to my .vimrc

```
let g:googledocstrings_author = 'clay'
let g:googledocstrings_todo = 'TODO_DOC(clay)'
nnoremap <leader>d :GoogleDocstringsGen<CR>
nnoremap <leader>t /TODO_DOC(clay)<CR>:noh<CR>dE<Esc>a
```

When you are ready to write documentation for you module
you can use `<leader>d`, then `<leader>t` repeatedly filling
in information until it is complete.
