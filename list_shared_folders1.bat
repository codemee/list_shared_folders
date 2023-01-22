@echo off
Setlocal EnableDelayedExpansion

set /a total=0
@rem net view 可以顯示 UNC 路徑下的所有分享資源
@rem 每一行都是 資源名稱 資源類型 的格式
for /f "tokens=1,2" %%l in ('net view %1') do (
  @REM -----------------------------------
  @REM    1(l)   2(m)
  @REM 共用名稱   類型  使用方式  註解
  @REM books     Disk
  @REM CPP       Disk  
  @REM -----------------------------------
  @rem 資源類型為 Disk 的就是資料夾
  if "%%m"=="Disk" (
    set full_path=%1\%%l
    set get_total=F
    @rem dir /s 可以遞迴列出子資料夾與檔案並統計總用量
    for /f "tokens=1,3" %%p in ('dir /s !full_path!') do (
      @rem -------------------------------------------------
      @rem         1(p)
      @REM  檔案數目總計:
      @rem         1(p)     2            3(q)
      @REM          291 個檔案      82,151,599 位元組
      @REM          149 個目錄  30,767,378,432 位元組可用
      @rem -------------------------------------------------
      @rem 已經到了倒數第二行, 也就是總計用量
      if "!get_total!"=="T" (
        set subtotal=%%q
        @rem 將顯示用量中的 ',' 去掉
        echo %%l 用量：!subtotal:,=!
        set /a total+=!subtotal:,=!
        set get_total=F
      )
      @rem dir /s 倒數第三行是『檔案數目總計:』
      if "%%p"=="檔案數目總計:" (
        set get_total=T
      )
    )
  )
)
echo 總用量：%total%


