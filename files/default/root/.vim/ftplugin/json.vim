set autoindent
set formatoptions=tcq2l
set textwidth=78 shiftwidth=2
set softtabstop=2 tabstop=8
set expandtab
syntax sync fromstart
setlocal foldmethod=syntax

map <F5> :!python -m json.tool % >/dev/null && echo OK<CR>

