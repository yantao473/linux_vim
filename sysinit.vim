" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  autocmd!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif

augroup END

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis
                 \ | wincmd p | diffthis
endif


if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

syntax on

set ruler		" show the cursor position all the time
set showcmd            " display incomplete commands

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

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"


""""""""""""""""""""""""""""""""""""""start config by yanqing4""""""""""""""""""""""""""
"set guifont
" set guifont=Consolas:h15:cANSI
" set guifont=DejaVu\ Sans\ Mono\ Book:h13:cANSI

" delete utf-8 BOM 
set nobomb
" charset settings
set encoding=utf-8
set langmenu=zh_CN.UTF-8
language message zh_CN.UTF-8
set fileencodings=ucs-bom,utf-8,gbk,gb18030,cp936,big5,euc-jp,euc-kr,euc-cn,latin1

"Enable filetype plugin
filetype plugin indent on

"Set mapleader
let mapleader=","
let g:mapleader=","

set mouse=c

" Auto change directory
" set autochdir

"Fast edit sysinit.vim
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
map <silent> <leader>ee :call SwitchToBuf("/usr/local/share/nvim/sysinit.vim")<cr>

"When _vimrc is edited, reload it
autocmd! bufwritepost vimrc source /usr/local/share/nvim/sysinit.vim

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

"Show line number
set nu

"Do not redraw, when running macros.. lazyredraw
set lz

"set whichwrap+=<,>,h,l
set ww+=<,>

"Set magic on
set magic

"No sound on errors.
set noeb
set novb

"show matching bracets
set sm

"How many tenths of a second to blink
set mat=2

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
set shiftwidth=4
set et
set tabstop=4
set smarttab

" au FileType html,python,php,perl,c,c++,javascript,txt,vim setl shiftwidth=4
" au FileType html,python,php,perl,c,c++,javascript,txt,vim setl tabstop=4
au FileType html,python,php,perl,c,c++,javascript,txt,vim setl lbr
au FileType c,cpp :set cindent

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""
" Vim section
"""""""""""""""""""""""""""""""
" autocmd FileType vim set nofen
" autocmd FileType vim map <buffer> <leader><space> :w!<cr>:source %<cr>

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
let g:syntastic_html_tidy_ignore_errors = ['proprietary attribute "myhotcompany-']
autocmd BufReadPre *.js let b:javascript_lib_use_jquery = 1
autocmd BufReadPre *.js let b:javascript_lib_use_angularjs = 1
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

"***************************start tagbar******************************"
let tagbar_ctags_bin='/usr/bin/ctags'
let g:tagbar_autofocus = 1
nnoremap <silent><leader>tb :Tagbar<CR>
nnoremap <silent><leader>tc :TagbarClose<CR>
"***************************end tagbar******************************"

"***************************start airline******************************"
set laststatus=2
" let g:airline_theme="luna" 
let g:airline_theme="powerlineish" 

"这个是安装字体后 必须设置此项" 
let g:airline_powerline_fonts = 1   

"打开tabline功能,方便查看Buffer和切换，这个功能比较不错"
"我还省去了minibufexpl插件，因为我习惯在1个Tab下用多个buffer"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
" let g:airline#extensions#tabline#show_close_button = 1
" let g:airline#extensions#tabline#close_symbol = 'X'

" let g:airline#extensions#branch#enabled = 1
" let g:airline#extensions#branch#empty_message = ''


"设置切换Buffer快捷键"
nnoremap <C-N> :bn<CR>
nnoremap <C-P> :bp<CR>

" 关闭状态显示空白符号计数,这个对我用处不大"
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#symbol = '!'

"***************************end airline******************************"

"***************************start python******************************"
let python_highlight_all=1
let g:ycm_python_binary_path = '/usr/bin/python'
abbr pyhd #!/usr/bin/env python<CR># -*- coding: UTF-8 -*-<CR><CR><CR><esc>0
"***************************end python******************************"

"***************************start indentLine************************"
let g:indentLine_color_term = 239
let g:indentLine_char='┆'
let g:indentLine_enabled = 1
"***************************end indentLine************************"

"***************************start syntastic******************************"
let g:systastic_python_checkers=['pep8']
let g:syntastic_check_on_open = 1
let g:syntastic_enable_balloons = 1
"***************************end syntastic******************************"


"***************************start YCM******************************"
"让vim的补全菜单行为与一般ide一致(参考vimtip1228)
set completeopt=longest,menu

"离开插入模式后自动关闭预览窗口
autocmd insertleave * if pumvisible() == 0|pclose|endif

"按回车键即选中当前项
inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<cr>"  

let g:ycm_global_ycm_extra_conf = '/usr/share/vim/vimfiles/vundle/youcompleteme/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

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
let g:ycm_key_list_previous_completion = ['<c-p>', '<up>']
let g:ycm_key_list_select_completion = ['<c-n>', '<down>']

let g:ycm_autoclose_preview_window_after_completion=1

" 设置在下面几种格式的文件上屏蔽ycm
let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'nerdtree' : 1
      \}

"设置关健字触发补全
let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.', ' ', '(', '[', '&'],
  \   'objc' : ['->', '.', 're!\[[_a-za-z]+\w*\s', 're!^\s*[^\w\d]\w*\s',
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
let g:go_bin_path = expand("/usr/local/gopath/bin")
let g:go_bin_path = "/usr/local/go/bin"      "or give absolute path
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
let g:formatdef_harttle = '"astyle --style=attach --indent=spaces=4 --pad-oper --pad-comma --add-brackets --convert-tabs"'
let g:formatters_cpp = ['harttle']
let g:formatters_c = ['harttle']
let g:formatters_php = ['harttle']
let g:formatter_yapf_style = 'pep8'
noremap <F2> :Autoformat<CR>
"***************************autoformater end******************************"

"***************************vundle start**********************************"
" install  git clone https://github.com/gmarik/Vundle.vim.git
set rtp+=/usr/share/vim/vimfiles/vundle/Vundle.vim
let path='/usr/share/vim/vimfiles/vundle'
call vundle#begin(path)
Plugin 'gmarik/Vundle.vim'
" base
Plugin 'genutils'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'pathogen.vim'
Plugin 'lookupfile'

"git 
Plugin 'fugitive.vim'

" statusline
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" syntax
Plugin 'scrooloose/syntastic'
Plugin 'Yggdroot/indentLine'

" golang
Plugin 'fatih/vim-go'
Plugin 'dgryski/vim-godef'
Plugin 'nsf/gocode', {'rtp': 'vim/'}

" html
Plugin 'mattn/emmet-vim'
Plugin 'matchit.zip' 

" javascript
Plugin 'pangloss/vim-javascript'
Plugin 'othree/javascript-libraries-syntax.vim' 
Plugin 'burnettk/vim-angular'
Plugin 'jslint.vim'

" tmux
Plugin 'christoomey/vim-tmux-navigator'

Plugin 'majutsushi/tagbar'
Plugin 'Valloric/YouCompleteMe'

" brackets
Plugin 'Raimondi/delimitMate'

" formater
Plugin 'Chiel92/vim-autoformat'

call vundle#end()
"***************************vundle end**********************************
""""""""""""""""""""""""""""""""""""""end config by yanqing4""""""""""""""""""""""""""
