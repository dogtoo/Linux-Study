-rwxr-xr-x.  1  root goot 1.1k apr 20 filename
1. 檔案屬性 (-rwxr-xr-x. )
    第1欄位：用來表示檔案型態(ex: 「d」為資料夾「l」連結檔案)
    第2~10欄位：用來表示檔案的存取權限模式
    第11欄：表示這個檔案擁有SELinux的案全性本文
2. 連結數量 (1)
    再查看看書上寫的我看不懂
3. 檔案擁有者(root)
4. 檔案擁有群組(goot)
5. 檔案大小(1.1k)
6. 時間戳記(apr 20)
    三個會更動戳記的點異動內容、存取檔案及變更權限
7. 檔案名稱(filename)

1. ls 
    1-1 異動日期用西元年來顯示
        ls -l --time-style long-iso
    1-2 檔案大小用G K M顯示
        ls -lh
    1-3 用檔案大小排序
        ls -lhs
