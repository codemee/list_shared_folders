@echo off
Setlocal EnableDelayedExpansion

set /a total=0
@rem net view 可以顯示 UNC 路徑下的所有分享資源
@rem 每一行都是 資源名稱 資源類型 的格式
for /f "tokens=1,2" %%l in ('net view %1') do (
  @rem 資源類型為 Disk 的就是資料夾
  if "%%m"=="Disk" (
    set full_path=%1\%%l
    @rem dir /s 預設為包含隱藏檔, 若沒有 /s 則不會
    for /f "tokens=2,3,4,5" %%f in ('dir /a/-c !full_path!') do (
      @rem --------------------------------------------------
      @rem                1  2(f)            3(g)  4(h)
      @rem               43 個檔案         4938370 位元組
      @rem --------------------------------------------------
      if "%%f"=="個檔案" (
        echo !full_path! 用量：%%g
        set /a total+=%%g
      )
      @rem -------------------------------------------------
      @rem          1  2(f)  3(g)     4(h)              5(i)
      @rem 2022/05/03  下午 01:42    <DIR>          test_ini
      @rem --------------------------------------------------
      if "%%h"=="<DIR>" (
        if not "%%i"=="." (
          if not "%%i"==".." (
            set sub_path=!full_path!\%%i
            @rem dir /s 可以遞迴列出子資料夾與檔案並統計總用量
            set get_total=F
            for /f "tokens=1,3" %%p in ('dir /s /-c !sub_path!') do (
              @rem -------------------------------------------------
              @rem         1(p)
              @REM  檔案數目總計:
              @rem         1(p)     2            3(q)
              @REM         3781 個檔案        71280427 位元組
              @REM         1501 個目錄     30558121984 位元組可用          
              @rem -------------------------------------------------
              @rem 已經到了倒數第二行, 也就是總計用量
              if "!get_total!"=="T" (
                echo !sub_path! 子資料夾用量：%%q
                set /a total+=%%q
                set get_total=F
              )
              @rem dir /s 倒數第三行是『檔案數目總計:』
              if "%%p"=="檔案數目總計:" (
                set get_total=T
              )
            )
          )
        )
      )
    )  
  )
)
echo 總用量：%total%


