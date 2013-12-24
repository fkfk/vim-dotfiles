"非フルスクリーン時のウィンドウサイズ設定
"set lines=54
"set columns=180

colorscheme desert
"colorscheme hybrid

"ツールバー、スクロールバー非表示
set go=egmtc 

if has("gui_macvim")
  "フルスクリーン時にウィンドウサイズをMAXに指定
  set fuoptions=maxvert,maxhorz

  if exists('$LANG') && $LANG ==# 'ja_JP.UTF-8'
    set langmenu=ja_ja.utf-8.macvim
    set encoding=utf-8
    set ambiwidth=double
  endif
endif

if has("win32")
  " Windowsバージョン取得
  let s:win_osver = substitute(vimproc#system("cmd /c ver"), "[^.0-9]", "", "g")
  let s:win_osver_list = split(s:win_osver, '\.')

  " DirectXで描画できるならばDirectXを用いる
  " NOTE: ropオプションは内部エンコーディングがutf-8のときでVista以降から使用出来る
  if s:win_osver_list[0] > 5 && has('directx') && &encoding ==# 'utf-8'
    set guifont=Ricty:h11:cSHIFTJIS,MS_Gothic:h12:cSHIFTJIS
    set rop=type:directx,renmode:5,taamode:1
  endif
endif
