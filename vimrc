if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

set nocompatible	" Use Vim defaults (much better!)
set bs=indent,eol,start		" allow backspacing over everything in insert mode
"set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup fedora
  autocmd!
  " In text files, always limit the width of text to 78 characters
  " autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add $PWD/cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin on

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"

""""""""""""""""""""""""""""""""""""""start config by yanqing4""""""""""""""""""""""""""
"set guifont
" set guifont=Consolas:h15:cANSI
" set guifont=DejaVu\ Sans\ Mono\ Book:h13:cANSI

"Get out of VI's compatible mode.
set nocp

"set folding method
" set fdm=marker 

"set how many lines of history VIM to remember
set history=400

" delete utf-8 BOM 
set nobomb
" charset settings
set encoding=utf-8
set langmenu=zh_CN.UTF-8
language message zh_CN.UTF-8
set fileencodings=ucs-bom,utf-8,gbk,gb18030,cp936,big5,euc-jp,euc-kr,euc-cn,latin1

"Enable filetype plugin
filetype plugin on
filetype indent on

"Set mapleader
let mapleader=","
let g:mapleader=","

" Set the mouse enabled all the time
" set mouse = a
 
" disabled mouse
set mouse-=a

" change terminal title
set title

 

" Auto change directory
" set autochdir

"Set auto read when a file is changed from the outside
set ar

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
map <silent> <leader>ee :call SwitchToBuf("/etc/vimrc")<cr>

"When _vimrc is edited, reload it
autocmd! bufwritepost vimrc source /etc/vimrc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERD_commener
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let NERDSpaceDelims = 1
let NERDCompactSexyComs=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"NERD tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <silent> <leader>ne :NERDTree<cr>
map <silent> <leader>nc :NERDTreeClose<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fileformats
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Favorite filetypes
set ffs=unix,dos

nmap <silent> <leader>fd :se ff=dos<cr>
nmap <silent> <leader>fu :se ff=unix<cr>

"Smart way to move btw. windows
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l

"Remove the Windows ^M
noremap <silent> <leader>dm mmHmn:%s/<C-V><cr>//ge<cr>'nzt'm

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM userinterface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Set 7 lines to the curors - when moving vertical..
set so=7

"The commandbar is 2 high
set ch=2

"Always show current position
set ru

"Show line number
set nu

"Do not redraw, when running macros.. lazyredraw
set lz

"set whichwrap+=<,>,h,l
set ww+=<,>

"Increach search
set is

"Set magic on
set magic

"Highlight search things
set hls

"No sound on errors.
set noeb
set novb
set t_vb=

"show matching bracets
set sm

"How many tenths of a second to blink
set mat=2

"Turn on WiLd menu
set wmnu

"Set backspace
set backspace=eol,start,indent

" 防止tmux下vim的背景色显示异常
" Refer: http://sunaku.github.io/vim-256color-bce.html
if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Moving around and tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Switch to current dir
map <silent> <leader>cd :cd %:p:h<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Files and backups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Turn backup off
set nobk
set nowb
"set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Enable folding, I find it very useful
set foldenable
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set sw=4
set et
set tabstop=4
set smarttab

" au FileType html,python,php,perl,c,c++,javascript,txt,vim setl shiftwidth=4
" au FileType html,python,php,perl,c,c++,javascript,txt,vim setl tabstop=4
au FileType html,python,php,perl,c,c++,javascript,txt,vim setl lbr
au FileType text setl textwidth=78
autocmd FileType c,cpp :set cindent

" Wrap lines
set nowrap

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Complete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" options
set completeopt=menu
set complete-=u
set complete-=i

" Enable syntax
if has("autocmd") && exists("+omnifunc")
    autocmd Filetype *
                \ if &omnifunc == ""  |
                \ setlocal omnifunc=syntaxcomplete#Complete |
                \ endif
endif

" 高亮行
" set cursorline
" highlight CursorLine   cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE

"""""""""""""""""""""""""""""""
" Vim section
"""""""""""""""""""""""""""""""
autocmd FileType vim set nofen
autocmd FileType vim map <buffer> <leader><space> :w!<cr>:source %<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fast grep
nmap <silent> <leader>lv :lv /<c-r>=expand("<cword>")<cr>/ %<cr>:lw<cr>
vmap <silent> <leader>lv :lv /<c-r>=<sid>GetVisualSelection()<cr>/ %<cr>:lw<cr>

" Fast diff
cmap @vd vertical diffsplit 
set diffopt+=vertical

"Paste toggle - when pasting something in, don't indent.
set pastetoggle=<F3>

" run php
nmap <F9> :!/usr/bin/php %<CR>

"************************ for neocomplcache  **********************"
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_auto_select = 1
let g:neocomplcache_enable_quick_match = 1
let g:neocomplcache_min_syntax_length = 2
"************************ for neocomplcache  **********************"

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
set laststatus=2
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
abbr pyhd #!/usr/bin/env python<CR># -*- coding: utf-8 -*-<CR><CR><CR><esc>0
"***************************end python******************************"

"***************************start indentLine************************"
let g:indentLine_color_term = 239
let g:indentLine_char='┆'
let g:indentLine_enabled = 1
"***************************end indentLine************************"

"***************************start fzf ************************"
nnoremap <silent><leader>lk :Files<CR>
"***************************end fzf************************"

"***************************start YCM******************************"
"让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
set completeopt=longest,menu

"离开插入模式后自动关闭预览窗口
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

"按回车键即选中当前项
" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"  

let g:ycm_global_ycm_extra_conf = '/usr/share/vim/vimfiles/plug/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

" 不显示开启vim时检查ycm_extra_conf文件的信息
let g:ycm_confirm_extra_conf = 0

" 开启基于tag的补全，可以在这之后添加需要的标签路径
let g:ycm_collect_identifiers_from_tags_files = 1

" 开启语义补全
let g:ycm_seed_identifiers_with_syntax = 1

"注释和字符串中的文字也会被收入补全
let g:ycm_collect_identifiers_from_comments_and_strings = 1

" 禁止缓存匹配项，每次都重新生成匹配项
" let g:ycm_cache_omnifunc = 0

" 输入第 2 个字符开始补全
let g:ycm_min_num_of_chars_for_completion= 2

"在注释输入中也能补全
let g:ycm_complete_in_comments = 1

"在字符串输入中也能补全
let g:ycm_complete_in_strings = 1



"定义快捷健补全
let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']
let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']

let g:ycm_autoclose_preview_window_after_completion=1

" 设置在下面几种格式的文件上屏蔽ycm
let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'nerdtree' : 1
      \}

"设置关健字触发补全
let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.', ' ', '(', '[', '&'],
  \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
  \             're!\[.*\]\s'],
  \   'ocaml' : ['.', '#'],
  \   'cpp,objcpp' : ['->', '.', '::'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
  \   'ruby' : ['.', '::'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \ }

" 定义函数跟踪快捷健
nnoremap <silent> <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
"***************************end YCM******************************"

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
"au FileType mail let b:delimitMate_autoclose = 0
"***************************delimitMate end******************************"

"***************************autoformater start******************************"
" http://astyle.sourceforge.net/astyle.html
let g:formatdef_harttle = '"astyle --mode=c -A10 -S -f -p -k3 -W3 -j -c"'
let g:formatters_cpp = ['harttle']
let g:formatters_c = ['harttle']
let g:formatters_php = ['harttle']
let g:formatter_yapf_style = 'pep8'
noremap <F2> :Autoformat<CR>
"***************************autoformater end******************************"

"***************************compile and debug end******************************"
map <silent> <leader>rc :call C_Compile()<cr>
map <silent> <leader>rr :call C_Run()<cr>
"***************************compile and debug end******************************"

"***************************plug start**********************************
let g:plug_path='/usr/share/vim/vimfiles/plug/vim-plug'
function! DoPlug()
    if !isdirectory(g:plug_path . "/autoload")
        call mkdir(g:plug_path ."/autoload", "p")
        execute "!cp " .g:plug_path ."/plug.vim " . g:plug_path . "/autoload/plug.vim"  
    endif
endfunction

" install git clone https://github.com/junegunn/vim-plug.git 
set rtp+=/usr/share/vim/vimfiles/plug/vim-plug

call plug#begin('/usr/share/vim/vimfiles/plug')
Plug 'https://github.com/junegunn/vim-plug.git', { 'do': function('DoPlug') }
" base
Plug 'https://github.com/vim-scripts/genutils.git'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle'}
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-pathogen'

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
Plug 'docunext/closetag.vim', { 'for': ['html', 'xml'] }
" html
Plug 'mattn/emmet-vim', {'for': ['html', 'xml'] }
Plug 'https://github.com/vim-scripts/matchit.zip.git', {'for': ['html', 'xml'] }

" javascript
" Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
" Plug 'ternjs/tern_for_vim', { 'for': 'javascript', 'do': 'npm install' }

" tmux
Plug 'christoomey/vim-tmux-navigator'

Plug 'majutsushi/tagbar'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --gocode-com' }

" brackets
Plug 'Raimondi/delimitMate'

" 括号显示增强
Plug 'kien/rainbow_parentheses.vim'

" 文件搜索
Plug 'junegunn/fzf', { 'dir': '/usr/share/vim/vimfiles/plug/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" formater
Plug 'Chiel92/vim-autoformat'
call plug#end()
"***************************plug end**********************************


""""""""""""""""""""""""""""""""""""""end config by yanqing4""""""""""""""""""""""""""
