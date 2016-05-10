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
""""""""""""""""""""""""""""""""""""""""""""""
"General
""""""""""""""""""""""""""""""""""""""""""""""
"set guifont
" set guifont=Consolas:h15:cANSI
set guifont=DejaVu\ Sans\ Mono\ Book:h13:cANSI

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
"BufExplorer
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0 " Do not show default help
let g:bufExplorerShowRelativePath=1 " Show relative paths. 
let g:bufExplorerSortBy='mru' " Sort by most recently used. 
let g:bufExplorerSplitRight=0 " Split left. 
let g:bufExplorerSplitVertical=1 " Split vertically. 
let g:bufExplorerSplitVertSize = 30 " Split width 
let g:bufExplorerUseCurrentWindow=1 " Open in new window. 
autocmd BufWinEnter \[Buf\ List\] setl nonumber

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
set et
set sw=4

au FileType html,python,vim,javascript,c,php setl shiftwidth=4
au FileType html,python,vim,java,c,javascript,php setl tabstop=4
au FileType txt setl lbr
au FileType txt setl tw=78
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
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_auto_select = 1
let g:neocomplcache_enable_quick_match = 1
let g:neocomplcache_min_syntax_length = 2

" Enable omni completion. 
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS 
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags 
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS 
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete 
"************************ for neocomplcache  **********************"
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
let Tlist_Show_One_File=1
let Tlist_WinWidth=20
let Tlist_Exit_OnlyWindow=1
let Tlist_Use_Right_Window=1
nnoremap <silent><leader>tl :TlistToggle<CR>
"***************************end taglist******************************"

"***************************start airline******************************"
let g:airline_theme="luna" 

"这个是安装字体后 必须设置此项" 
let g:airline_powerline_fonts = 1   

"打开tabline功能,方便查看Buffer和切换，这个功能比较不错"
"我还省去了minibufexpl插件，因为我习惯在1个Tab下用多个buffer"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

"设置切换Buffer快捷键"
nnoremap <C-N> :bn<CR>
nnoremap <C-P> :bp<CR>

" 关闭状态显示空白符号计数,这个对我用处不大"
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#symbol = '!'

"***************************end airline******************************"

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
Plugin 'jlanzarotta/bufexplorer'
Plugin 'vim-scripts/matchit.zip'
Plugin 'lookupfile'
Plugin 'pathogen.vim'
Plugin 'taglist.vim'
Plugin 'Shougo/neocomplcache'
call vundle#end()
""""""""""""""""""""""""""""""""""""""end config by yanqing4""""""""""""""""""""""""""
