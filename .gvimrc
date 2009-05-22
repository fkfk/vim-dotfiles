"非フルスクリーン時のウィンドウサイズ設定
"set lines=54
"set columns=180

"カラースキーム設定
colorscheme Black

"ツールバー、スクロールバー非表示
set go=egmtc 

if has("gui_macvim")
  "フルスクリーン時にウィンドウサイズをMAXに指定
  set fuoptions=maxvert,maxhorz
end
