1. $_ 的切割
讀入有’\n’換行符分割的一條記錄，然後將記錄按指定的域分隔符劃分域，填充域，
  $0則表示所有域
  $1表示第一個域
  $n表示第n個域。
預設域分隔符是”空白鍵” 或 “[tab]鍵”,所以$1表示登入使用者，$3表示登入使用者ip,以此類推。

2. 列出資料夾中是檔案的名稱
  ls -l -F | grep \/ | awk {'gsub("/","",$9); print $9'}
  
3. 利用system執行shell 指令
  ls -l -F | grep \/ | awk {'gsub("/","",$9); system("tar cfz "$9".tgz "$9)'}
  指令部份用字串圈起來，字串不用'+'

4. grep 正則 + awk gsub
echo nickel,sam, | grep -oE "\w*," | awk 'gsub(",","") {system("sudo usermod -aG docker "$0)}'
