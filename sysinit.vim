augroup Fedora
au!
" RPM spec file template
au BufNewFile *.spec silent! 0read /usr/share/nvim/template.spec
augroup END

""""""""""""""""""""""""""""""""""""""start config by yanqing4""""""""""""""""""""""""""
colorscheme desert

"Enable filetype plugin
filetype plugin on
filetype indent on

se title
se number
se lazyredraw
se showmatch
se nowritebackup
se nowrap
se foldenable
se expandtab
se mouse-=a
se completeopt=menu
se complete-=u
se complete-=i
se tabstop=4
se shiftwidth=4
se matchtime=2
se scrolloff=7
se cmdheight=2
se whichwrap+=<,>
se fileformats=unix,dos
se backspace=eol,start,indent
se completeopt=longest,menu

" charset settings
language message zh_CN.UTF-8
se encoding=utf-8
se langmenu=zh_CN.UTF-8
se fileencodings=ucs-bom,utf-8,gbk,gb18030,cp936,big5,euc-jp,euc-kr,euc-cn,latin1

"Paste toggle - when pasting something in, don't indent.
se pastetoggle=<F3>

" Auto change directory
" set autochdir

"set folding method
" set fdm=marker

" set mapleader
let g:mapleader=","

nmap <silent> <leader>fd :se ff=dos<cr>
nmap <silent> <leader>fu :se ff=unix<cr>

" smart way to move btw. windows
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l

" remove the Windows ^M
noremap <silent> <leader>dm mmHmn:%s/<C-V><cr>//ge<cr>'nzt'm

" switch to current dir
map <silent> <leader>cd :cd %:p:h<cr>

" one key to run
nmap <F9> :call CompileRunGcc()<CR>

function! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!gcc -Wall % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ -Wall % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!time java %<"
    elseif &filetype == 'sh'
        :!time bash %
    elseif &filetype == 'python'
        exec "!time python2.7 %"
    elseif &filetype == 'php'
        exec "!/usr/bin/php %"
    elseif &filetype == 'html'
        exec "!firefox % &"
    elseif &filetype == 'go'
        " exec "!go build %<"
        exec "!time go run %"
    elseif &filetype == 'mkd'
        exec "!~/.vim/markdown.pl % > %.html &"
        exec "!firefox %.html &"
    endif
endfunc


"Fast edit vimrc
function! SwitchToBuf(filename)
    "let fullfn = substitute(a:filename, "^\\~/", $HOME . "/", "")
    let bufwinnr = bufwinnr(a:filename)
    if bufwinnr != -1
        exec bufwinnr . "wincmd w"
        return
    else
        " find in each tab
        tabfirst
        let tab = 1
        while tab <= tabpagenr("$")
            let bufwinnr = bufwinnr(a:filename)
            if bufwinnr != -1
                exec "normal " . tab . "gt"
                exec bufwinnr . "wincmd w"
                return
            endif
            tabnext
            let tab = tab + 1
        endwhile
        " not exist, new tab
        exec "tabnew " . a:filename
    endif
endfunction
map <silent> <leader>ee :call SwitchToBuf("/usr/share/nvim/sysinit.vim")<cr>
"when _vimrc is edited, reload it
au! BufWritePost sysinit.vim source /usr/share/nvim/sysinit.vim


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au FileType html,python,php,perl,c,c++,javascript,txt,vim setl lbr
au FileType text setl textwidth=78
au FileType c,cpp :set cindent

" au FileType vim set nofen
au FileType vim map <buffer> <leader><space> :w!<cr>:source %<cr>
au FileType vim,c,cpp,python,ruby,java,sh,html,javascript,php au BufWritePre <buffer> :%s/\s\+$//e

"**************************start nerd commener*************************************
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
"**************************end nerd commener****************************************

"****************************start nerd tree***********************************
map <silent> <leader>ne :NERDTree<cr>
map <silent> <leader>nc :NERDTreeClose<cr>
"****************************end nerd tree*************************************

"***************************start lightline******************************"
let g:lightline = {
            \   'active': {
            \     'left':[ [ 'mode', 'paste' ],
            \              [ 'gitbranch', 'cocstatus', 'readonly', 'filename', 'modified' ]
            \     ]
            \   },
            \   'component': {
            \     'lineinfo': ' %3l:%-2v',
            \   },
            \   'component_function': {
            \     'gitbranch': 'fugitive#head',
            \     'cocstatus': 'coc#status',
            \   }
            \ }

"***************************end lightline******************************"

"***************************start python******************************"
au BufNewFile *.py iabbr main def main():<CR>pass<CR><CR><CR>if __name__ == '__main__':<CR>main()

function! HeaderPython()
    call setline(1, "#!/usr/bin/env python")
    call append(1, "# -*- coding: utf-8 -*-")
    normal G
    normal 3o
endfunction
au BufNewFile *.py call HeaderPython()

"***************************end python******************************"

"***************************start fzf ************************"
nnoremap <silent><leader>lf :Files<CR>
nnoremap <silent><leader>lb :Buffers<CR>
nnoremap <silent><leader>lt :BTags<CR>
nnoremap <silent><Leader>rg :Rg <C-R><C-W><CR>
"***************************end fzf************************

"***************************autoformater start******************************"
" http://astyle.sourceforge.net/astyle.html
let g:formatdef_cfamily = '"astyle --mode=c -A10 -S -f -p -k3 -W3 -j -c"'
let g:formatters_cpp = ['cfamily']
let g:formatters_c = ['cfamily']

let g:formatdef_phpstyle = '"astyle --mode=c -A14 -xl  -C  -Y  -f -xg  -U -j -c -s4"'
let g:formatters_php = ['phpstyle']

" range format python
let g:formatdef_autopep8 = "'autopep8 - --range '.a:firstline.' '.a:lastline. ' --max-line-length=119'"
let g:formatters_python = ['autopep8']
noremap <F2> :Autoformat<CR>:w<CR>

" python保存时自动格式化
au BufWritePre *.py silent! Autoformat

" php
function! HeaderPHP()
    call setline(1, "<?php")
    normal G
    normal o
endfunction
au BufNewFile *.php call HeaderPHP()
"***************************autoformater end******************************"

"***************************compile and debug start******************************"
map <silent> <leader>rc :call C_Compile()<cr>
map <silent> <leader>rr :call C_Run()<cr>
"***************************compile and debug end******************************"

"***************************vim-isort start******************************"
let g:vim_isort_map = '<C-i>'

" 保存前时自动调用Isort
au BufWritePre *.py silent! Isort
"***************************vim-isort end******************************"

"***************************coc.nvim start**********************************
set hidden
set updatetime=300
" set shortmess +=c

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" Remap keys for goto
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
" nmap <silent> gy <plug>(coc-type-definition)
" nmap <silent> gi <plug>(coc-implementation)

" Use gh for show documentation in preview window
" nnoremap <silent> gh :call <SID>show_documentation()<CR>

" function! s:show_documentation()
"     if &filetype == 'vim'
"         execute 'h '.expand('<cword>')
"     else
"         call CocAction('doHover')
"     endif
" endfunction

nmap <leader>rn <Plug>(coc-rename)
nnoremap <silent> <leader>tb  :<C-u>CocList outline<cr>
nnoremap <silent> <leader>s  :<C-u>CocList -I symbols<cr>

 " default action for next item.
nnoremap <silent> <leader>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <leader>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <leader>p  :<C-u>CocListResume<CR>

" fix coc-phpls bugs
autocmd FileType php setl iskeyword+=$

"***************************coc.nvim end**********************************

"***************************plug start**********************************
let root_path = "/usr/share/nvim/runtime/"
let base_path = root_path. "custom_plugin/"
let g:plug_path = base_path . "vim-plug/"
let g:mvpath = root_path .'/autoload/'


" Note: install vim-plug if not present
if empty(glob(base_path))
    " install git clone https://github.com/junegunn/vim-plug.git
    silent exe "!mkdir -p ". base_path
    silent exe "!git clone https://github.com/junegunn/vim-plug.git " . g:plug_path
    silent exe "!/bin/cp " . g:plug_path ."plug.vim " . g:mvpath. '/plug.vim'
    au VimEnter * PlugInstall
endif

function! DoPlug()
    silent exe "!cp " . g:plug_path ."/plug.vim " . g:mvpath. '/plug.vim'
endfunction

se rtp+=g:plug_path

call plug#begin(base_path)

" utils
Plug 'https://github.com/junegunn/vim-plug.git', {'do': function('DoPlug')}
Plug 'tpope/vim-pathogen'

Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}

Plug 'scrooloose/nerdcommenter' "comment for code

" navigation
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}

" statusline
Plug 'itchyny/lightline.vim'

" snippets
Plug 'honza/vim-snippets'

" file search
" Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
Plug 'junegunn/fzf.vim'

" formater
Plug 'Chiel92/vim-autoformat'

" version control
Plug 'tpope/vim-fugitive'

call plug#end()
"***************************plug end**********************************
""""""""""""""""""""""""""""""""""""""end config by yanqing4""""""""""""""""""""""""""
"le
"vim: et ts=4 sw=4
