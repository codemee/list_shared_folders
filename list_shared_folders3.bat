@echo off
Setlocal EnableDelayedExpansion

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
        call :uni_add %%g
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
                call :uni_add %%q
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
echo 總用量：%tot_s%
goto:eof

:uni_add
set num=%~1
@rem 取得位數
for /l %%d in (0, 1, 98) do (
  if not "!num:~%%d,1!" == "" (
    set /a digits=%%d + 1
  )
)
@rem 每三位數一個單位會剩下幾位數
set /a remain_digits=digits%%3
@rem 三位數一個單位共佔幾位數
set /a r_digit=digits - remain_digits
@rem 進位數值
set /a carry=0
@rem 依序取得每三位的數字
for /l %%d in (-3, -3, -!r_digit!) do (
  set sub_sum[%%d]=!num:~%%d,3!
)
set /a r_digit+=3
set /a r_digit=-r_digit
@rem 取得不足三位的最左邊剩餘數字
for %%d in (!remain_digits!) do (
  @REM echo !num:~0,%%d!
  set sub_sum[!r_digit!]=!num:~0,%%d!
)

@rem 循序三位一組將小計與目前總計相加
for /l %%d in (-3, -3, !r_digit!) do (
  if "!totals[%%d]!"=="" (
    set totals[%%d]=!sub_sum[%%d]!
    set /a carry=0
  ) else (
    set /a temp=1000!sub_sum[%%d]!%%1000+1000!totals[%%d]!%%1000+carry
    set /a carry=temp/1000
    set /a temp=temp%%1000
    set totals[%%d]=!temp!
  )
)
@rem 處理進位
if !carry! gtr 0 (
  set /a r_digit-=3
  for /l %%d in (!r_digit!, -3, !max_digit!) do (
    @rem 由於 0 開頭的數字會被當成 8 進位
    @rem 這裡採取加 1000000 再取除以 1000 的餘數來避免
    set /a temp=1000!totals[%%d]!%%1000+carry
    set /a carry=temp/1000
    set /a temp=temp%%1000
    set totals[%%d]=!temp!
  )
)
@rem 更新目前最高位數
if !max_digit! gtr !r_digit! set /a max_digit=r_digit
@rem 進位到新的一組三位數
if !carry! gtr 0 (
  set /a max_digit-=3
  for %%d in (!max_digit!) do (
    set totals[%%d]=carry
  )
)
@rem 用三位一組的格式顯示總計
set tot_s=
for /l %%d in (!max_digit!, 3, -3) do (
  set temp_s=1000!totals[%%d]!
  @rem 由於計算結果可能不到三位數
  @rem 這裡用特別的技巧補上開頭的 0
  set tot_s=!tot_s!,!temp_s:~-3,3!
)
set tot_s=!tot_s:~1!
exit /b