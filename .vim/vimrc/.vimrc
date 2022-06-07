"======================================================================

"導入するプラグインが多くなると、今度は管理が大変になってきます。そこでプラグインの管理をするプラグインを使用すると便利です。管理プラグインはいくつかありますが、筆者はdein.vimというプラグインを使用しています。dein.vimはtomlファイルを使ってプラグインを管理する事ができます。tomlファイルに記述してプラグインをインストール、またtomlファイルから削除してプラグインをアンイストールできるので便利です。ただ、インストールもアンイストールも自動でやってくれるわけではないので、少し手を加える必要があります。筆者の場合はvimrcに以下の設定をしています。

" dein.vim settings {{{
" install dir {{{
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
" }}}

" dein installation check {{{
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif
" }}}

" begin settings {{{
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " .toml file
  let s:rc_dir = expand('~/.vim')
  if !isdirectory(s:rc_dir)
    call mkdir(s:rc_dir, 'p')
  endif
  let s:toml = s:rc_dir . '/dein.toml'

  " read toml and cache
  call dein#load_toml(s:toml, {'lazy': 0})

  " end settings
  call dein#end()
  call dein#save_state()
endif
" }}}

" plugin installation check {{{
if dein#check_install()
  call dein#install()
endif
" }}}

" plugin remove check {{{
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif
" }}}


"=================================================-

"config custom=========================

"表示系--------
"番号
set number
"ビープ音出さない
set vb t_vb=
"ハイライト出さない
nnoremap <F3> :noh<CR>
"色
syntax enable
"solarizedというカラースキーム
"let g:solarized_termtrans = 1
set background=dark
colorscheme solarized
let g:solarized_termcolors=256

"molokai
"colorscheme molokai
"文字コードutg-8
set encoding=utf-8
set fileencodings=utf-8

" ◯や◆などの文字が半角の幅で表示されてしまうことを防ぐ
set ambiwidth=double

".vueでのコメントアウト対応
let g:ft = ''
function! NERDCommenter_before()
  if &ft == 'vue'
    let g:ft = 'vue'
    let stack = synstack(line('.'), col('.'))
    if len(stack) > 0
      let syn = synIDattr((stack)[0], 'name')
      if len(syn) > 0
        exe 'setf ' . substitute(tolower(syn), '^vue_', '', '')
      endif
    endif
  endif
endfunction
function! NERDCommenter_after()
  if g:ft == 'vue'
    setf vue
    let g:ft = ''
  endif
endfunction

".vueでハイライトを途中で消えないようにする
autocmd FileType vue syntax sync fromstart
"end 表示系---------

"操作系----------
"<c-f,b,p,n,a,e>での、移動や、<c-d,h>の削除,追加
imap <C-p> <Up>
imap <C-n> <Down>
imap <C-b> <Left>
imap <C-f> <Right>
imap <C-e> <End>
imap <C-d> <Del>
imap <C-h> <BS>
imap <C-a>  <Home>

"クリップボードを使えるようにする(y,pを、cmd+c,vと同じにする)
set clipboard+=unnamed

""swapファイルの作成位置
set directory=~/.vim/tmp

"end 操作系-------

"補完系-------
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap { {}<Left>
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap () ()
inoremap ( ()<ESC>i
inoremap (<Enter> ()<Left><CR><ESC><S-o>
inoremap [ []<ESC>i
inoremap [<Enter> []<Left><CR><ESC><S-o>inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>

inoremap ' ''<LEFT>
inoremap " ""<LEFT>
inoremap '' ''
inoremap ' ''<ESC>i
inoremap "" ""
inoremap " ""<ESC>i
inoremap < <><ESC>i



"自動インデント
set autoindent
"言語ごとにインデント変更
if has("autocmd")
  "ファイルタイプの検索を有効
  filetype plugin on
  "ファイルタイプに合わせたインデントを利用
  filetype indent on
  "sw=shiftwidth, sts=softtabstop, ts=tabstop, et=expandtabの略
  autocmd FileType php           setlocal sw=4 sts=4 ts=4 et
endif

""tabを半角スペース2個に変換
set expandtab
set tabstop=2
set shiftwidth=2

"コマンドを入力しやすくする（tabで、補完できるようにする）
set nocompatible
"上の機能を強化する。補完候補が出現するようになる[]
set wildmenu
" コマンドラインの履歴を5000件保存する
set history=5000

"入力補完
set completeopt=menuone,noinsert

" 補完表示時のEnterで改行をしない
"補完移動を、<C-n>下、<C-p>上でできるようにする
inoremap <expr><C-q> pumvisible() ? "<Down>" : "<C-n>"
inoremap <expr><C-q> pumvisible() ? "<Up>" : "<C-p>"
"end 補完系-----------"


"end custom==========================

""config plugin==================

"nerdtree---------------
autocmd StdinReadPre * let s:std_in=1
nnoremap <leader>n :NERDTreeFocus<CR>
"nerdtreeをトグル開閉できるようにする
nnoremap <C-n> :NERDTreeToggle<CR>
"なんか、よくわからんがよく使うらしい。
nnoremap <C-f> :NERDTreeFind<CR>NERDTree
"end nerdtree-----------

"emmet------
let g:user_emmet_leader_key = '<C-y>,'
"end emmet---------

"htmlタグ補完----
let g:closetag_filenames = '*.html, *.xhtml, *.phtml, *.erb, *.php, *.vue'



"end----------


"end nerdtree-------------
