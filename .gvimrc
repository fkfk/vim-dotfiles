"非フルスクリーン時のウィンドウサイズ設定
"set lines=54
"set columns=180

colorscheme desert

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
