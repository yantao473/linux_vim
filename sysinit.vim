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


nmap <silent> <leader>lv :lv /<c-r>=expand("<cword>")<cr>/ %<cr>:lw<cr>

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
" au FileType html,python,php,perl,c,c++,javascript,txt,vim setl shiftwidth=4
" au FileType html,python,php,perl,c,c++,javascript,txt,vim setl tabstop=4
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

"***************************start js syntax highlight******************************"
let javascript_enable_domhtmlcss = 1
"***************************end js syntax highlight******************************"

"***************************start tagbar******************************"
let tagbar_ctags_bin='/bin/ctags'
let g:tagbar_autofocus = 1
nnoremap <silent><leader>tb :Tagbar<CR>
nnoremap <silent><leader>tc :TagbarClose<CR>
"***************************end tagbar******************************"

"***************************start airline******************************"
let g:airline_theme="luna"
" let g:airline_theme="powerlineish"

"这个是安装字体后 必须设置此项"
let g:airline_powerline_fonts = 1

" 打开tabline功能,方便查看Buffer和切换,省去了minibufexpl插件"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#empty_message = ''

"设置切换Buffer快捷键"
nnoremap <C-N> :bn<CR>
nnoremap <C-P> :bp<CR>

" 关闭状态显示空白符号计数"
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#symbol = '!'

"***************************end airline******************************"

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
nnoremap <silent><leader>lk :Files<CR>
" ag for fzf
let g:ackprg = 'ag --nogroup --nocolor --column'
"let g:ackprg = 'ag --vimgrep'
"***************************end fzf************************"

""***************************start nvim-completion-manager******************************"
se shortmess+=c
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
au User CmSetup call cm#register_source({'name' : 'cm-css',
        \ 'priority': 9,
        \ 'scoping': 1,
        \ 'scopes': ['css','scss'],
        \ 'abbreviation': 'css',
        \ 'word_pattern': '[\w\-]+',
        \ 'cm_refresh_patterns':['[\w\-]+\s*:\s+'],
        \ 'cm_refresh': {'omnifunc': 'csscomplete#CompleteCSS'},
        \ })
""***************************end nvim-completion-manager******************************"

"***************************delimitMate start******************************"
" for python docstring ", 特别有用
au FileType python let b:delimitMate_nesting_quotes = ['"']
" 关闭某些类型文件的自动补全
au FileType mail let b:delimitMate_autoclose = 0
"***************************delimitMate end******************************"

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

"***************************ale start******************************"
let g:ale_python_flake8_args = '--max-line-length=120'
let g:ale_linters = {
\ 'javascript': ['eslint'],
\}

" Do not lint or fix minified files.
let g:ale_pattern_options = {
\ '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
\ '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
\}
" If you configure g:ale_pattern_options outside of vimrc, you need this.
let g:ale_pattern_options_enabled = 1

" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1
"***************************ale end******************************"

"***************************compile and debug start******************************"
map <silent> <leader>rc :call C_Compile()<cr>
map <silent> <leader>rr :call C_Run()<cr>
"***************************compile and debug end******************************"

"***************************vim-isort start******************************"
 let g:vim_isort_map = '<C-i>'

 " 保存前时自动调用Isort
 au BufWritePre *.py silent! Isort
"***************************vim-isort end******************************"

"***************************deopletelete start******************************"
let g:deoplete#enable_at_startup = 1

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-b>"

inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<C-p>" : "\<tab>"

" python
let g:deoplete#sources#jedi#server_timeout = 2
"***************************deopletelete  end******************************"

"***************************gutentags start******************************"
let g:gutentags_ctags_exclude = ['*.css', '*.html', '*.js', '*.txt', '*.log']
let g:gutentags_cache_dir = '~/.cache/share/nvim/gutentags'
"***************************gutentag end******************************"

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
Plug 'https://github.com/vim-scripts/genutils.git'

" comletion/coding
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neoinclude.vim' " include complete
Plug 'Shougo/neco-syntax' " for syntax complete e.g. function const etc

Plug 'padawan-php/deoplete-padawan', {'do': 'composer install', 'for': 'php' }
" Plug 'zchee/deoplete-jedi', {'for': 'python'}
" Plug 'fisadev/vim-isort', {'for': 'python'} " for python sort imports
Plug 'scrooloose/nerdcommenter' "comment for code
Plug 'jiangmiao/auto-pairs' " brackets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" navigation
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'majutsushi/tagbar'

" looking
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" async syntax
Plug 'w0rp/ale'

" auto complete  html/xml
Plug 'alvan/vim-closetag', {'for': ['html', 'xml']}
" Plug 'mattn/emmet-vim', {'for': ['html', 'xml'] }

" file search
Plug 'junegunn/fzf.vim'

" formater
Plug 'Chiel92/vim-autoformat'

" tags
Plug 'ludovicchabant/vim-gutentags'

" version control
Plug 'tpope/vim-fugitive'

" other
" Plug 'junegunn/vim-easy-align'
" Plug 'tpope/vim-surround'
" Plug 'terryma/vim-multiple-cursors'

call plug#end()
"***************************plug end**********************************
""""""""""""""""""""""""""""""""""""""end config by yanqing4""""""""""""""""""""""""""
" vim: et ts=4 sw=4
