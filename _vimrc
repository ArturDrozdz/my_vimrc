" -----------------------------------------------------------------------------
"  < �жϲ���ϵͳ�Ƿ��� Windows ���� Linux >
" -----------------------------------------------------------------------------
let g:iswindows = 0
let g:islinux = 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:islinux = 1
endif
" -----------------------------------------------------------------------------
"  < �ж����ն˻��� Gvim >
" -----------------------------------------------------------------------------
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif
" -----------------------------------------------------------------------------

" Basic options {{{

    set nocompatible              " be iMproved, required
    filetype off                  " required

if g:iswindows
    set rtp+=$VIMRUNTIME/../vimfiles/bundle/Vundle.vim/
    call vundle#begin('$VIMRUNTIME/../vimfiles/bundle')
endif

if g:islinux
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
endif

    " Python��ݼ�
    nnoremap <F5> :!python %<CR>
    nnoremap <F4> :!start python<CR>

    let mapleader = ","
    
    " <F7>����ctags
    nnoremap <F7> :!ctags -R<CR>

    set shiftwidth=4
    set expandtab
    "set t_Co=256
    syntax enable
    set ts=4
    set nu!
    syntax on

if g:isGUI
    set guioptions-=m " ���ز˵��� 
    set guioptions-=T " ���ع����� 
    "set guioptions-=L " ������������ 
    "set guioptions-=r " �����Ҳ������ 
    "set guioptions-=b " ���صײ������� 
    "set showtabline=0 " ����Tab��
endif

if g:iswindows 
    set linespace=5    "�����м��
    set guifont=Consolas:h11
    au GUIEnter * simalt ~x " ��������ʱ�Զ���� 
endif


if g:islinux
    set linespace=3
    set guifont=DejaVu\ Sans\ mono\ 11     "���������С����б�ߺ����и��ո�
    set lines=999   "columns=118  �������
    
    " sudo apt-get install wmctrl
    function! ToggleFullScreen()
        call system("wmctrl -r :ACTIVE: -b toggle,fullscreen")
    endfunction

    map <silent> <F11> :call ToggleFullScreen()<CR>
endif


    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin
    set nobackup

    set fileencoding=chinese
    set fileencodings=utf-8,chinese,latin-1
    set termencoding=utf-8
    set encoding=utf-8

if (g:iswindows && g:isGUI)
    source $VIMRUNTIME/delmenu.vim    "����˵�����
    source $VIMRUNTIME/menu.vim
    language messages zh_CN.utf-8    "���consle�������
endif

    " Complete options (disable preview scratch window)
    set completeopt-=preview
    " Limit popup menu height
    set pumheight=17

" }}} Basic options end


" Plugin settings {{{
    " Vundle {{{

        " let Vundle manage Vundle, required
        Plugin 'VundleVim/Vundle.vim'
        Plugin 'Yggdroot/indentLine'
        Plugin 'scrooloose/nerdtree'
        Plugin 'Valloric/MatchTagAlways'
        "Plugin 'mattn/emmet-vim'
        Plugin 'jiangmiao/auto-pairs'
        Plugin 'fholgado/minibufexpl.vim'
        Plugin 'bling/vim-airline'
        Plugin 'Dachow/visualmark'
        "Plugin 'scrooloose/nerdcommenter'
        "Plugin 'sjas/csExplorer'
        Plugin 'vim-scripts/xterm16.vim'
        Plugin 'majutsushi/tagbar'
        Plugin 'klen/python-mode'
        "Plugin 'altercation/vim-colors-solarized'
        "Plugin 'tomasr/molokai'
        Plugin 'tyru/open-browser.vim'
        Plugin 'davidhalter/jedi-vim'
        Plugin 'ervandew/supertab'
        Plugin 'Shougo/neocomplete.vim'
        "Plugin 'Valloric/YouCompleteMe'
        "Plugin 'scrooloose/syntastic'

" All of your Plugins must be added before the following line
call vundle#end()            " required

    " }}} Vundle end
    

    " indentLine {{{   
        "let g:indentLine_char = '|'
    " }}}

    " tagbar & nerdtree {{{
        if g:iswindows
            let g:tagbar_width = 37
        endif
        if g:islinux
            let g:NERDTreeWinSize = 23
            let g:tagbar_width = 28
        endif

        function! ToggleNERDTreeAndTagbar()
        let w:jumpbacktohere = 1

        Detect which plugins are open
        if exists('t:NERDTreeBufName')
            let nerdtree_open = bufwinnr(t:NERDTreeBufName) != -1
        else
            let nerdtree_open = 0
        endif
        let tagbar_open = bufwinnr('__Tagbar__') != -1

        " Perform the appropriate action
        if nerdtree_open && tagbar_open
            NERDTreeClose
            TagbarClose
        elseif nerdtree_open
            TagbarOpen
        elseif tagbar_open
            NERDTree
        else
            NERDTree
            TagbarOpen
        endif

        " Jump back to the original window
        for window in range(1, winnr('$'))
            execute window . 'wincmd w'
            if exists('w:jumpbacktohere')
                unlet w:jumpbacktohere
                break
            endif
        endfor
        endfunction 

        nnoremap <F8> :call ToggleNERDTreeAndTagbar()<CR>
    " }}}


    " xterm16 {{{
        colo xterm16   
        hi MatchParen ctermbg=DarkCyan ctermfg=white
        hi MatchParen guibg=DarkCyan guifg=white
        hi Comment ctermbg=Black ctermfg=DarkGreen 
        hi Comment guibg=Black guifg=SeaGreen 
        hi Comment cterm=italic gui=italic
    " }}}

    " pymode {{{
        let g:pymode_rope_completion = 0
        let g:pymode_lint_cwindow = 0
    " }}}
    
    " supertab {{{
        let g:SuperTabDefaultCompletionType = "context"
    " }}}

    " neocomplete & jedi & eclim {{{
        let g:neocomplete#enable_at_startup = 1

        autocmd FileType python setlocal omnifunc=jedi#completions
        let g:jedi#completions_enabled = 0
        let g:jedi#auto_vim_configuration = 0
        let g:jedi#smart_auto_mappings = 0

        if !exists('g:neocomplete#force_omni_input_patterns')
          let g:neocomplete#force_omni_input_patterns = {}
        endif

        let g:neocomplete#force_omni_input_patterns.python =
        \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
        " Alternative pattern: \ '\h\w*\|[^. \t]\.\w*'
    " }}}


"if g:islinux
    " YouCompleteMe {{{
    "    let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
    " }}}
"endif


" Plugin settings end }}}
    

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" Put your non-Plugin stuff after this line

"�½�.c,.h,.sh,.java�ļ����Զ������ļ�ͷ 
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java exec ":call SetTitle()" 
""���庯��SetTitle���Զ������ļ�ͷ 
func SetTitle() 
    "����ļ�����Ϊ.sh�ļ� 
    if &filetype == 'sh' 
        call setline(1,"\#########################################################################") 
        call append(line("."), "\# File Name: ".expand("%")) 
        call append(line(".")+1, "\# Author: xiaoFen") 
        call append(line(".")+2, "\# Mail: hellowd93@163.com") 
        call append(line(".")+3, "\# Created Time: ".strftime("%c")) 
        call append(line(".")+4, "\# Last modified: ".strftime("%Y-%m-%d %X"))
        call append(line(".")+5, "\#########################################################################") 
        call append(line(".")+6, "\#!/bin/bash") 
        call append(line(".")+7, "") 
    else 
        call setline(1, "/*************************************************************************") 
        call append(line("."), "    > File Name: ".expand("%")) 
        call append(line(".")+1, "    > Author: xiaoFen") 
        call append(line(".")+2, "    > Mail: hellowd93@163.com ") 
        call append(line(".")+3, "    > Created Time: ".strftime("%c")) 
        call append(line(".")+4, "    > Last modified: ".strftime("%Y-%m-%d %X"))
        call append(line(".")+5, " ************************************************************************/") 
        call append(line(".")+6, "")
    endif
    if &filetype == 'cpp'
        call append(line(".")+7, "#include<iostream>")
        call append(line(".")+8, "using namespace std;")
        call append(line(".")+9, "")
    endif
    if &filetype == 'c'
        call append(line(".")+7, "#include<stdio.h>")
        call append(line(".")+8, "")
    endif
endfunc

" python �ļ�ͷ
autocmd BufNewFile *.py exec ":call SetPyTitle()" 
func SetPyTitle() 
        call setline(1, "# !usr/bin/env python") 
        call append(line("."), "# -*-coding=utf-8-*-") 
        call append(line(".")+1, "# -------------------------------------------------------------------------") 
        call append(line(".")+2, "#    > File Name: ".expand("%")) 
        call append(line(".")+3, "#    > Author: xiaoFen") 
        call append(line(".")+4, "#    > Mail: hellowd93@163.com") 
        call append(line(".")+5, "#    > Created Time: ".strftime("%c")) 
        call append(line(".")+6, "#    > Last modified: ".strftime("%Y-%m-%d %X"))
        call append(line(".")+7, "# -------------------------------------------------------------------------") 
        call append(line(".")+8, "")
endfunc

""ʵ�����溯���еģ�Last modified����
"""""""""""""""""""""""""""""""""""""""""
autocmd BufWrite,BufWritePre,FileWritePre *.cpp,*.[ch],*.sh,*.java,*.py    ks|call LastModified()|'s  
func LastModified()
	if line("$") > 20
		let l = 20
	else 
		let l = line("$")
	endif
	exe "1,".l."g/Last modified: /s/Last modified: .*/Last modified:".
			\strftime(" %Y-%m-%d %X" ) . "/e"
endfunc

"�½��ļ����Զ���λ���ļ�ĩβ
autocmd BufNewFile * normal G

if g:iswindows
function MyDiff()
   let opt = '-a --binary '
   if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
   if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
   let arg1 = v:fname_in
   if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
   let arg2 = v:fname_new
   if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
   let arg3 = v:fname_out
   if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
   if $VIMRUNTIME =~ ' '
     if &sh =~ '\<cmd'
       if empty(&shellxquote)
         let l:shxq_sav = ''
         set shellxquote&
       endif
       let cmd = '"' . $VIMRUNTIME . '\diff"'
     else
       let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
     endif
   else
     let cmd = $VIMRUNTIME . '\diff'
   endif
   silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
   if exists('l:shxq_sav')
     let &shellxquote=l:shxq_sav
   endif
endfunction
endif
