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

" Auto change directory
" set autochdir

"Set auto read when a file is changed from the outside
set ar

"Set the mose enabled all the time
set mouse=a

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
"BufExplorer
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:bufExplorerDefaultHelp=0 " Do not show default help
" let g:bufExplorerShowRelativePath=1 " Show relative paths. 
" let g:bufExplorerSortBy='mru' " Sort by most recently used. 
" let g:bufExplorerSplitRight=0 " Split left. 
" let g:bufExplorerSplitVertical=1 " Split vertically. 
" let g:bufExplorerSplitVertSize = 30 " Split width 
" let g:bufExplorerUseCurrentWindow=1 " Open in new window. 
" autocmd BufWinEnter \[Buf\ List\] setl nonumber

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Avoid clearing hilight definition in plugins
"if !exists("g:vimrc_loaded")
"    syntax enable
"
"    " color scheme
"    if has("gui_running")
"        set guioptions-=T
"        set guioptions-=m
"        set guioptions-=L
"        set guioptions-=r
"    endif " has
"        colorscheme darkblue_my
"endif " exists(...)

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

"Turn on WiLd menu
set wmnu

"Always show current position
set ru

"The commandbar is 2 high
set ch=2

"Show line number
set nu

"Do not redraw, when running macros.. lazyredraw
set lz

"Set backspace
set backspace=eol,start,indent

"set whichwrap+=<,>,h,l
set ww+=<,>

"Increach search
set is

"Highlight search things
set hls

"Set magic on
set magic

"No sound on errors.
set noeb
set novb
set t_vb=

"show matching bracets
set sm

"How many tenths of a second to blink
set mat=2

""""""""""""""""""""""""""""""
" Statusline
""""""""""""""""""""""""""""""
set laststatus=2
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

""""""""""""""""""""""""""""""
" Indent
""""""""""""""""""""""""""""""
" Auto indent
" set ai

" Smart indet
" set si

" C-style indeting
" set cindent
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

"Remove the Windows ^M
noremap <silent> <leader>dm mmHmn:%s/<C-V><cr>//ge<cr>'nzt'm

"Paste toggle - when pasting something in, don't indent.
set pastetoggle=<F3>

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Check PHP Syntax using makeprg
"""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CheckPHPSyntax()
    if &filetype != 'php'
        echohl WarningMsg | echo 'This is not a PHP file !' | echohl None
        return
    endif
    setlocal makeprg=php\ -l\ -n\ -d\ html_errors=off\ %
    setlocal errorformat=%m\ in\ %f\ on\ line\ %l
    echohl WarningMsg | echo 'Syntax checking output:' | echohl None
    if &modified == 1
        silent write
    endif
    silent make
    clist
endfunction

au filetype php map <F5> :call CheckPHPSyntax()<CR>
au filetype php imap <F5> <ESC>:call CheckPHPSyntax()<CR>

"************************ for neocomplcache  **********************"
" let g:neocomplcache_enable_at_startup = 1
" let g:neocomplcache_enable_smart_case = 1
" let g:neocomplcache_enable_auto_select = 1
" let g:neocomplcache_enable_quick_match = 1
" let g:neocomplcache_min_syntax_length = 2

" " Enable omni completion. 
" autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS 
" autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags 
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS 
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete 
"************************ for neocomplcache  **********************"
"
"***************************lookupfile******************************"
let g:LookupFile_MinPatLength = 2               "最少输入2个字符才开始查找
let g:LookupFile_PreserveLastPattern = 0        "不保存上次查找的字符串
let g:LookupFile_PreservePatternHistory = 1     "保存查找历史
let g:LookupFile_AlwaysAcceptFirst = 1          "回车打开第一个匹配项目
let g:LookupFile_AllowNewFiles = 0              "不允许创建不存在的文件

if filereadable("./.filenametags")                "设置tag文件的名字
    let g:LookupFile_TagExpr = '"./.filenametags"'
endif

" lookup file with ignore case
function! LookupFile_IgnoreCaseFunc(pattern)
    let _tags = &tags
    try
        let &tags = eval(g:LookupFile_TagExpr)
        let newpattern = '\c' . a:pattern
        let tags = taglist(newpattern)
    catch
        echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
        return ""
    finally
        let &tags = _tags
    endtry

    " Show the matches for what is typed so far.
    let files = map(tags, 'v:val["filename"]')
    return files
endfunction
let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc' 

"映射LookupFile为,lk
nmap <silent> <leader>lk :LUTags<cr>
"映射LUBufs为,ll
nmap <silent> <leader>ll :LUBufs<cr>
"映射LUWalk为,lw
nmap <silent> <leader>lw :LUWalk<cr>
"***************************lookupfile******************************"

"***************************start taglist******************************"
set tags+=tags;
let Tlist_Show_One_File=1
let Tlist_WinWidth=20
let Tlist_Exit_OnlyWindow=1
let Tlist_Use_Right_Window=1
nnoremap <silent><leader>tl :TlistToggle<CR>
"***************************end taglist******************************"

"***************************start airline******************************"
" let g:airline_theme="luna" 
let g:airline_theme="powerlineish" 

"这个是安装字体后 必须设置此项" 
let g:airline_powerline_fonts = 1   

" 打开tabline功能,方便查看Buffer和切换,省去了minibufexpl插件"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
" let g:airline#extensions#tabline#show_close_button = 1
" let g:airline#extensions#tabline#close_symbol = 'X'

" let g:airline#extensions#branch#enabled = 1
" let g:airline#extensions#branch#empty_message = ''

"设置切换Buffer快捷键"
nnoremap <C-N> :bn<CR>
nnoremap <C-P> :bp<CR>

" 关闭状态显示空白符号计数"
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#symbol = '!'

"***************************end airline******************************"

"***************************start python******************************"
let python_highlight_all=1
let g:ycm_python_binary_path = '/usr/bin/python'
"***************************end python******************************"

"***************************start syntastic******************************"
let g:systastic_python_checker="flake8,pep8,pylint"
let g:systastic_python_checkers=["pyflakes"]
let g:syntastic_check_on_open = 1
let g:syntastic_cpp_include_dirs = ['/usr/include/']
let g:syntastic_cpp_remove_include_errors = 1
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = '-std=c++11 -stdlib=libstdc++'
"set error or warning signs
"let g:syntastic_error_symbol = '✗'
"let g:syntastic_warning_symbol = '⚠'
""whether to show balloons
let g:syntastic_enable_balloons = 1
"***************************end syntastic******************************"

"***************************start YCM******************************"
"让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
set completeopt=longest,menu

let g:clang_auto_select=2

"离开插入模式后自动关闭预览窗口
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

"按回车键即选中当前项
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"  

let g:ycm_global_ycm_extra_conf = '/usr/share/vim/vimfiles/vundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

" 不显示开启vim时检查ycm_extra_conf文件的信息
let g:ycm_confirm_extra_conf = 0

" 开启基于tag的补全，可以在这之后添加需要的标签路径
let g:ycm_collect_identifiers_from_tags_files = 1

" 开启语义补全
let g:ycm_seed_identifiers_with_syntax = 1

"注释和字符串中的文字也会被收入补全
let g:ycm_collect_identifiers_from_comments_and_strings = 0

" 输入第 2 个字符开始补全
let g:ycm_min_num_of_chars_for_completion= 2

" 禁止缓存匹配项,每次都重新生成匹配项
let g:ycm_cache_omnifunc=0

"在注释输入中也能补全
let g:ycm_complete_in_comments = 1

"在字符串输入中也能补全
let g:ycm_complete_in_strings = 1

"定义快捷健补全
let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']
let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']

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
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
"***************************end YCM******************************"

" 标示多余的空白
" au ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
" au bufread,bufnewfile *.py,*.pyw,*.c,*.cpp,*.js,*.css,*.vim,*.h,*.php match ExtraWhitespace /\s\+$/

" install  git clone https://github.com/gmarik/Vundle.vim.git
set rtp+=/usr/share/vim/vimfiles/vundle/Vundle.vim
let path='/usr/share/vim/vimfiles/vundle'
call vundle#begin(path)

Plugin 'gmarik/Vundle.vim'
Plugin 'L9'
Plugin 'genutils'
Plugin 'fugitive.vim'
Plugin 'Emmet.vim'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'vim-scripts/matchit.zip'
Plugin 'lookupfile'
Plugin 'pathogen.vim'
Plugin 'taglist.vim' 
Plugin 'Valloric/YouCompleteMe'
Plugin 'davidhalter/jedi-vim'
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'
" Plugin 'jlanzarotta/bufexplorer'
" Plugin 'Shougo/neocomplcache'
call vundle#end()
""""""""""""""""""""""""""""""""""""""end config by yanqing4""""""""""""""""""""""""""
