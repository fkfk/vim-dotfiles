"非フルスクリーン時のウィンドウサイズ設定
"set lines=54
"set columns=180

"ツールバー、スクロールバー非表示
set go=gmtc

if has("win32")
  " DirectXで描画できるならばDirectXを用いる
  " NOTE: ropオプションは内部エンコーディングがutf-8のときでVista以降から使用出来る
  if has('directx') && &encoding ==# 'utf-8'
    set guifont=Ricty:h11:cSHIFTJIS,MS_Gothic:h12:cSHIFTJIS
    set rop=type:directx,renmode:5,taamode:1
  endif
elseif has("unix")
  set guifont=Noto\ Mono\ 10,Ricty\ 11,Monospace\ 10
elseif has("gui_macvim")
  "フルスクリーン時にウィンドウサイズをMAXに指定
  set fuoptions=maxvert,maxhorz

  if exists('$LANG') && $LANG ==# 'ja_JP.UTF-8'
    set langmenu=ja_ja.utf-8.macvim
    set encoding=utf-8
    set ambiwidth=double
  endif
endif
