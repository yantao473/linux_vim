" Prevent duplicate loading:
if exists("g:C_Version") || &cp
    finish
endif
let g:C_Version= "5.17"                             " version number of this script; do not change

let s:installation                  = 'system'
let s:plugin_dir                        = $VIM.'/vimfiles'
let s:C_FilenameEscChar             = ' \%#[]'

let s:C_CCompiler           = 'gcc'      " the C   compiler
let s:C_CplusCompiler       = 'g++'      " the C++ compiler
let s:C_ExeExtension        = ''         " file extension for executables (leading point required)
let s:C_ObjExtension        = '.o'       " file extension for objects (leading point required)

let s:C_VimCompilerName             = 'gcc'      " the compiler name used by :compiler

let s:C_CExtension                  = 'c'                    " C file extension; everything else is C++
let s:C_CFlags                      = '-Wall -g -O0 -c'      " compiler flags: compile, don't optimize
let s:C_CodeCheckExeName      = 'check'
let s:C_LFlags                      = '-Wall -g -O0'         " compiler flags: link   , don't optimize
let s:C_Libs                        = '-lm'                  " libraries to use
let s:C_OutputGvim            = 'vim'
let s:C_Printheader           = "%<%f%h%m%<  %=%{strftime('%x %X')}     Page %N"
let s:C_TypeOfH               = 'cpp'
let s:C_XtermDefaults         = '-fa courier -fs 12 -geometry 80x24'

let s:C_SourceCodeExtensions  = 'c cc cp cxx cpp CPP c++ C i ii'
let s:C_MakeExecutableToRun = ''

if match( s:C_XtermDefaults, "-geometry\\s\\+\\d\\+x\\d\\+" ) < 0
    let s:C_XtermDefaults   = s:C_XtermDefaults." -geometry 80x24"
endif


let s:C_Printheader  = escape( s:C_Printheader, ' %' )
"
let s:C_HlMessage    = ""

let s:C_SplintIsExecutable  = 0
if executable( "splint" )
    let s:C_SplintIsExecutable  = 1
endif
"
let s:C_CodeCheckIsExecutable   = 0
if executable( s:C_CodeCheckExeName )
    let s:C_CodeCheckIsExecutable   = 1
endif

"------------------------------------------------------------------------------
"  C_Compile : C_Compile       {{{1
"------------------------------------------------------------------------------
"  The standard make program 'make' called by vim is set to the C or C++ compiler
"  and reset after the compilation  (setlocal makeprg=... ).
"  The errorfile created by the compiler will now be read by gvim and
"  the commands cl, cp, cn, ... can be used.
"------------------------------------------------------------------------------
let s:LastShellReturnCode   = 0         " for compile / link / run only

function! C_Compile ()

    let s:C_HlMessage = ""
    exe ":cclose"
    let Sou     = expand("%:p")                                         " name of the file in the current buffer
    let Obj     = expand("%:p:r").s:C_ObjExtension  " name of the object
    let SouEsc= escape( Sou, s:C_FilenameEscChar )
    let ObjEsc= escape( Obj, s:C_FilenameEscChar )

    " update : write source file if necessary
    exe ":update"

    " compilation if object does not exist or object exists and is older then the source
    if !filereadable(Obj) || (filereadable(Obj) && (getftime(Obj) < getftime(Sou)))
        " &makeprg can be a string containing blanks
        let makeprg_saved   = '"'.&makeprg.'"'
        if expand("%:e") == s:C_CExtension
            exe     "setlocal makeprg=".s:C_CCompiler
        else
            exe     "setlocal makeprg=".s:C_CplusCompiler
        endif
        "
        " COMPILATION
        "
        exe ":compiler ".s:C_VimCompilerName
        let v:statusmsg = ''
        let s:LastShellReturnCode   = 0
        exe     "make ".s:C_CFlags." ".SouEsc." -o ".ObjEsc
        exe "setlocal makeprg=".makeprg_saved
        if empty(v:statusmsg)
            let s:C_HlMessage = "'".Obj."' : compilation successful"
        endif
        if v:shell_error != 0
            let s:LastShellReturnCode   = v:shell_error
        endif
        "
        " open error window if necessary
        :redraw!
        exe ":botright cwindow"
    else
        let s:C_HlMessage = " '".Obj."' is up to date "
    endif

endfunction    " ----------  end of function C_Compile ----------

"------------------------------------------------------------------------------
"  C_Link : C_Link       {{{1
"------------------------------------------------------------------------------
"  The standard make program which is used by gvim is set to the compiler
"  (for linking) and reset after linking.
"
"  calls: C_Compile
"------------------------------------------------------------------------------
function! C_Link ()
    call    C_Compile()
    :redraw!
    if s:LastShellReturnCode != 0
        let s:LastShellReturnCode   =  0
        return
    endif

    let s:C_HlMessage = ""
    let Sou     = expand("%:p")                                 " name of the file (full path)
    let Obj     = expand("%:p:r").s:C_ObjExtension  " name of the object file
    let Exe     = expand("%:p:r").s:C_ExeExtension  " name of the executable
    let ObjEsc= escape( Obj, s:C_FilenameEscChar )
    let ExeEsc= escape( Exe, s:C_FilenameEscChar )

    if C_CheckForMain() == 0
        let s:C_HlMessage = "no main function in '".Sou."'"
        return
    endif

    " no linkage if:
    "   executable exists
    "   object exists
    "   source exists
    "   executable newer then object
    "   object newer then source

    if    filereadable(Exe)                &&
                \ filereadable(Obj)                &&
                \ filereadable(Sou)                &&
                \ (getftime(Exe) >= getftime(Obj)) &&
                \ (getftime(Obj) >= getftime(Sou))
        let s:C_HlMessage = " '".Exe."' is up to date "
        return
    endif

    " linkage if:
    "   object exists
    "   source exists
    "   object newer then source

    if filereadable(Obj) && (getftime(Obj) >= getftime(Sou))
        let makeprg_saved='"'.&makeprg.'"'
        if expand("%:e") == s:C_CExtension
            exe     "setlocal makeprg=".s:C_CCompiler
        else
            exe     "setlocal makeprg=".s:C_CplusCompiler
        endif
        exe ":compiler ".s:C_VimCompilerName
        let s:LastShellReturnCode   = 0
        let v:statusmsg = ''
        silent exe "make ".s:C_LFlags." -o ".ExeEsc." ".ObjEsc." ".s:C_Libs
        if v:shell_error != 0
            let s:LastShellReturnCode   = v:shell_error
        endif
        exe "setlocal makeprg=".makeprg_saved
        "
        if empty(v:statusmsg)
            let s:C_HlMessage = "'".Exe."' : linking successful"
            " open error window if necessary
            :redraw!
            exe ":botright cwindow"
        else
            exe ":botright copen"
        endif
    endif
endfunction    " ----------  end of function C_Link ----------

"------------------------------------------------------------------------------
"  C_Run :  C_Run       {{{1
"  calls: C_Link
"------------------------------------------------------------------------------
"
let s:C_OutputBufferName   = "C-Output"
let s:C_OutputBufferNumber = -1
let s:C_RunMsg1                      ="' does not exist or is not executable or object/source older then executable"
let s:C_RunMsg2                      ="' does not exist or is not executable"
"
function! C_Run ()
    "
    let s:C_HlMessage = ""
    let Sou                     = expand("%:p")                                             " name of the source file
    let Obj                     = expand("%:p:r").s:C_ObjExtension      " name of the object file
    let Exe                     = expand("%:p:r").s:C_ExeExtension      " name of the executable
    let ExeEsc              = escape( Exe, s:C_FilenameEscChar )    " name of the executable, escaped
    let Quote                   = ''
    
    let l:arguments     = exists("b:C_CmdLineArgs") ? b:C_CmdLineArgs : ''
    "
    let l:currentbuffer = bufname("%")
    "
    "==============================================================================
    "  run : run from the vim command line
    "==============================================================================
    if s:C_OutputGvim == "vim"
        "
        if s:C_MakeExecutableToRun !~ "^\s*$"
            call C_HlMessage( "executable : '".s:C_MakeExecutableToRun."'" )
            exe     '!'.Quote.s:C_MakeExecutableToRun.Quote.' '.l:arguments
        else

            silent call C_Link()
            if s:LastShellReturnCode == 0
                " clear the last linking message if any"
                let s:C_HlMessage = ""
                call C_HlMessage()
            endif
            "
            if  executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
                exe     "!".Quote.ExeEsc.Quote." ".l:arguments
            else
                echomsg "file '".Exe.s:C_RunMsg1
            endif
        endif

    endif
    "
    "==============================================================================
    "  run : redirect output to an output buffer
    "==============================================================================
    if s:C_OutputGvim == "buffer"
        let l:currentbuffernr   = bufnr("%")
        "
        if s:C_MakeExecutableToRun =~ "^\s*$"
            call C_Link()
        endif
        if l:currentbuffer ==  bufname("%")
            "
            "
            if bufloaded(s:C_OutputBufferName) != 0 && bufwinnr(s:C_OutputBufferNumber)!=-1
                exe bufwinnr(s:C_OutputBufferNumber) . "wincmd w"
                " buffer number may have changed, e.g. after a 'save as'
                if bufnr("%") != s:C_OutputBufferNumber
                    let s:C_OutputBufferNumber  = bufnr(s:C_OutputBufferName)
                    exe ":bn ".s:C_OutputBufferNumber
                endif
            else
                silent exe ":new ".s:C_OutputBufferName
                let s:C_OutputBufferNumber=bufnr("%")
                setlocal buftype=nofile
                setlocal noswapfile
                setlocal syntax=none
                setlocal bufhidden=delete
                setlocal tabstop=8
            endif
            "
            " run programm
            "
            setlocal    modifiable
            if s:C_MakeExecutableToRun !~ "^\s*$"
                call C_HlMessage( "executable : '".s:C_MakeExecutableToRun."'" )
                exe     '%!'.Quote.s:C_MakeExecutableToRun.Quote.' '.l:arguments
                setlocal    nomodifiable
                "
                if winheight(winnr()) >= line("$")
                    exe bufwinnr(l:currentbuffernr) . "wincmd w"
                endif
            else
                "
                if  executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
                    exe     "%!".Quote.ExeEsc.Quote." ".l:arguments
                    setlocal    nomodifiable
                    "
                    if winheight(winnr()) >= line("$")
                        exe bufwinnr(l:currentbuffernr) . "wincmd w"
                    endif
                else
                    setlocal    nomodifiable
                    :close
                    echomsg "file '".Exe.s:C_RunMsg1
                endif
            endif
            "
        endif
    endif
    "
    "==============================================================================
    "  run : run in a detached xterm  (not available for MS Windows)
    "==============================================================================
    if s:C_OutputGvim == "xterm"
        "
        if s:C_MakeExecutableToRun !~ "^\s*$"
            silent exe '!xterm -title '.s:C_MakeExecutableToRun.' '.s:C_XtermDefaults.' -e '.s:C_Wrapper.' '.s:C_MakeExecutableToRun.' '.l:arguments.' &'
            :redraw!
            call C_HlMessage( "executable : '".s:C_MakeExecutableToRun."'" )
        else

            silent call C_Link()
            
            if  executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
                silent exe '!xterm -title '.ExeEsc.' '.s:C_XtermDefaults.' -e '.s:C_Wrapper.' '.ExeEsc.' '.l:arguments.' &'
                :redraw!
            else
                echomsg "file '".Exe.s:C_RunMsg1
            endif
        endif
    endif

endfunction    " ----------  end of function C_Run ----------

let s:C_SourceCodeExtensionsList    = split( s:C_SourceCodeExtensions, '\s\+' )

function! C_CheckForMain ()
    return  search( '^\(\s*int\s\+\)\=\s*main', "cnw" )
endfunction    " ----------  end of function C_CheckForMain  ----------

function! C_HlMessage ( ... )
    redraw!
    echohl Search
    if a:0 == 0
        echo s:C_HlMessage
    else
        echo a:1
    endif
    echohl None
endfunction    " ----------  end of function C_HlMessage ----------

if has("autocmd")
    "  *.h has filetype 'cpp' by default; this can be changed to 'c' :
    if s:C_TypeOfH=='c'
        autocmd BufNewFile,BufEnter  *.h  :set filetype=c
    endif

    " C/C++ source code files which should not be preprocessed.
    autocmd BufNewFile,BufRead  *.i  :set filetype=c
    autocmd BufNewFile,BufRead  *.ii :set filetype=cpp
    
    autocmd BufReadPost quickfix  setlocal wrap | setlocal linebreak
endif " has("autocmd")
"
"=====================================================================================
" vim: tabstop=2 shiftwidth=2 foldmethod=marker
