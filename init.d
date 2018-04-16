/etc/init.d 此資料夾存放如下
    1. 開機描述檔 
    2. service描述檔

vim $processName.sh
chmod 755 $processName.sh 將檔案改為可執行檔
預設表頭如下：當然最前面要加上執行script的方式 「#!/bin/sh」
### BEGIN INIT INFO
# Provides: $processName.sh
# Required-Start: <啟動時可以排在那個程序之後執行> 預設：$remote_fs $syslog
# Required-Stop: $remote_fs $syslog
# Default-Start: <啟動階段 {2|3|4|5}>
# Default-Stop: <停止階段 {0|1|6}>
# Short-Description: <程序簡述>
# Description: <程序祥細說明>
### END INIT INFO

{2|3|4|5} 說明 :
都是多使用者模式，要找看看有沒有比較祥細的說明
{0|1|6} 說明 : 像使用int.d 6可以重開機，0就是關機
0 關機模式
1 單機使用
6 重新開機

B.sh 要在 A.sh之後執行
A.sh如下
Provides:A.sh
Required-Start: $remote_fs $syslog
B.sh如下
Provides:B.sh
Required-Start: A.sh

Required預設可用的模式有
$local_fs ： 本地檔案系統被掛載。所有用到 /var 目錄的啟動項目，都要相依此項目。
$network ： 網路介面被啟用。
$named ： 名稱伺服功能被啟用。
$portmap
$remote_fs ： 所有檔案系統被掛載。包含 /usr 目錄節點。
$syslog ： 系統記錄功能被啟用。
$time ： 系統時間被設定。
$all ： 所有項目後。

Script寫完後或有更改都要執行
update-rc.d $processName.sh defaults
網路上有寫到在defaults後面加數字，如果有寫開機說明檔表頭就不用管了


PS:以上的$processName.sh其實不用加.sh也可以
