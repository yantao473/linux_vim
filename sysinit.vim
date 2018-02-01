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
        exec "!gcc % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
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
au! bufwritepost sysinit.vim source /usr/share/nvim/sysinit.vim


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


"**************************start nerd commener*************************************
let NERDSpaceDelims = 1
let NERDCompactSexyComs = 1
"**************************end nerd commener****************************************

"****************************start nerd tree***********************************
map <silent> <leader>ne :NERDTree<cr>
map <silent> <leader>nc :NERDTreeClose<cr>
"****************************end nerd tree*************************************

"***************************start js syntax highlight******************************"
let javascript_enable_domhtmlcss = 1
"***************************end js syntax highlight******************************"

"***************************tmux start******************************"
let g:tmux_navigator_no_mappings = 1
let g:tmux_navigator_save_on_switch = 2

nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>
"***************************tmux end******************************"

"***************************start tagbar******************************"
let tagbar_ctags_bin='/usr/bin/ctags'
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
" abbr pyhd #!/usr/bin/env python<CR># -*- coding: utf-8 -*-<CR><CR><CR><esc>0
" au FileType python iabbr main def main():<CR>pass<CR><CR><CR>if __name__ == '__main__':<CR>main()
au BufNewFile *.py iabbr main def main():<CR>pass<CR><CR><CR>if __name__ == '__main__':<CR>main()

function! HeaderPython()
    call setline(1, "#!/usr/bin/env python")
    call append(1, "# -*- coding: utf-8 -*-")
    normal G
    normal 3o
endfunction
au BufNewFile *.py call HeaderPython()

"***************************end python******************************"

"***************************start indentLine************************"
let g:indentLine_color_term = 239
let g:indentLine_char='┆'
let g:indentLine_enabled = 1
"***************************end indentLine************************"

"***************************start fzf ************************"
nnoremap <silent><leader>lk :Files<CR>
"***************************end fzf************************"

" "***************************start YCM******************************"
" "让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)

" "离开插入模式后自动关闭预览窗口
" au InsertLeave * if pumvisible() == 0|pclose|endif

" "按回车键即选中当前项
" " inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" let g:ycm_global_ycm_extra_conf = '/usr/share/nvim/runtime/plug/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

" " 不显示开启vim时检查ycm_extra_conf文件的信息
" let g:ycm_confirm_extra_conf = 0

" " 开启基于tag的补全，可以在这之后添加需要的标签路径
" let g:ycm_collect_identifiers_from_tags_files = 1

" " 开启语义补全
" let g:ycm_seed_identifiers_with_syntax = 1

" "注释和字符串中的文字也会被收入补全
" let g:ycm_collect_identifiers_from_comments_and_strings = 1

" " 禁止缓存匹配项，每次都重新生成匹配项
" " let g:ycm_cache_omnifunc = 0

" " 输入第 2 个字符开始补全
" let g:ycm_min_num_of_chars_for_completion= 2

" "在注释输入中也能补全
" let g:ycm_complete_in_comments = 1

" "在字符串输入中也能补全
" let g:ycm_complete_in_strings = 1

" "定义快捷健补全
" let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']
" let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']

" let g:ycm_autoclose_preview_window_after_completion=1

" " 设置在下面几种格式的文件上屏蔽ycm
" let g:ycm_filetype_blacklist = {
            " \ 'tagbar' : 1,
            " \ 'nerdtree' : 1
            " \}

" "设置关健字触发补全
" let g:ycm_semantic_triggers =  {
            " \   'c' : ['->', '.', ' ', '(', '[', '&'],
            " \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
            " \             're!\[.*\]\s'],
            " \   'ocaml' : ['.', '#'],
            " \   'cpp,objcpp' : ['->', '.', '::'],
            " \   'perl' : ['->'],
            " \   'php' : ['->', '::'],
            " \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
            " \   'ruby' : ['.', '::'],
            " \   'lua' : ['.', ':'],
            " \   'erlang' : [':'],
            " \ }

" " 定义函数跟踪快捷健
" nnoremap <silent> <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
" "***************************end YCM******************************"

"***************************start vim-go******************************"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_fmt_autosave = 0
let g:go_play_open_browser = 0
let g:go_bin_path = expand("/bin")
let g:go_bin_path = "/bin"      "or give absolute path
let g:go_get_update = 0

au BufRead,BufNewFile *.go set filetype=go
au BufWritePre *.go :GoFmt
nnoremap <silent> <leader>gr :GoRun<cr>
"***************************end vim-go******************************"

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

let g:formatdef_phpstyle = '"astyle -A14 -xg -j -c -s4"'
let g:formatters_php = ['phpstyle']

" range format python
let g:formatdef_autopep8 = "'autopep8 - --range '.a:firstline.' '.a:lastline. ' --max-line-length=119'"
let g:formatters_python = ['autopep8']
noremap <F2> :Autoformat<CR>:w<CR>
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

"***************************compile and debug end******************************"
map <silent> <leader>rc :call C_Compile()<cr>
map <silent> <leader>rr :call C_Run()<cr>
"***************************compile and debug end******************************"


"***************************plug start**********************************
let base_path = "/usr/share/nvim/runtime/plug/"
let g:plug_path = base_path . "vim-plug"
let g:mvpath = g:plug_path .'/autoload/'


" Note: install vim-plug if not present
if empty(glob(base_path))
    " install git clone https://github.com/junegunn/vim-plug.git
    silent exe "!mkdir -p ". base_path
    silent exe "!git clone https://github.com/junegunn/vim-plug.git " . g:plug_path
    silent exe "!mkdir -p ". g:mvpath
    silent exe "!/bin/cp " . g:plug_path ."/plug.vim " . g:mvpath. '/plug.vim'
    au VimEnter * PlugInstall
endif

function! DoPlug()
    silent exe "!cp " . g:plug_path ."/plug.vim " . g:mvpath. '/plug.vim'
endfunction

se rtp+=g:plug_path

call plug#begin(base_path)

" base
Plug 'https://github.com/junegunn/vim-plug.git', {'do': function('DoPlug')}
Plug 'tpope/vim-pathogen'
Plug 'https://github.com/vim-scripts/genutils.git'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}

" git
Plug 'tpope/vim-fugitive'

" statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" syntax
Plug 'w0rp/ale'
Plug 'Yggdroot/indentLine'

" golang
" Plug 'fatih/vim-go'
" Plug 'dgryski/vim-godef'
" Plug 'nsf/gocode', {'rtp': 'vim/'}

" auto complete  html/xml
Plug 'alvan/vim-closetag', {'for': ['html', 'xml']}
" html
Plug 'mattn/emmet-vim', {'for': ['html', 'xml'] }
Plug 'https://github.com/vim-scripts/matchit.zip.git', {'for': ['html', 'xml'] }


" tmux
Plug 'christoomey/vim-tmux-navigator'

Plug 'majutsushi/tagbar'

" Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer --gocode-com'}
Plug 'roxma/ncm-phpactor'
Plug 'roxma/LanguageServer-php-neovim',  {'do': 'composer install && composer run-script parse-stubs'}
Plug 'roxma/ncm-clang'
Plug 'roxma/nvim-completion-manager'
Plug 'phpactor/phpactor' ,  {'do': 'composer install'}

" brackets
Plug 'jiangmiao/auto-pairs'

" 括号显示增强
Plug 'kien/rainbow_parentheses.vim'

" 文件搜索
Plug 'junegunn/fzf', {'dir': base_path.'fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'

" formater
Plug 'Chiel92/vim-autoformat'
call plug#end()
"***************************plug end**********************************
""""""""""""""""""""""""""""""""""""""end config by yanqing4""""""""""""""""""""""""""
" vim: et ts=4 sw=4
