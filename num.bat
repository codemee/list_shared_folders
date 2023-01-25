@echo off
@rem 手工打造無限位數的整數加法
Setlocal EnableDelayedExpansion

set /a min_digit=0
for %%n in (30560915456, 1234, 2147483647, 21474836472147483647) do (
  set num=%%n
  echo !num!
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
  
  @rem 用三位一組的格式顯示小計
  set sub_s=
  for /l %%d in (!r_digit!, 3, -3) do (
    set sub_s=!sub_s! !sub_sum[%%d]!
  )
  echo !sub_s!

  @rem 循序三位一組將小計與目前總計相加
  for /l %%d in (-3, -3, !r_digit!) do (
    if "!totals[%%d]!"=="" (
      set totals[%%d]=!sub_sum[%%d]!
      set /a carry=0
    ) else (
      set /a temp=!sub_sum[%%d]!+!totals[%%d]!+carry
      set /a carry=temp/1000
      set /a temp=temp%%1000
      set totals[%%d]=!temp!
    )
  )
  @rem 處理進位
  if !carry! gtr 0 (
    set /a r_digit-=3
    for /l %%d in (!r_digit!, -3, !max_digit!) do (
      set /a temp=!totals[%%d]!+carry
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
    set tot_s=!tot_s! !totals[%%d]!
  )
  echo !tot_s!
  echo !digits! digits, max_digit: !max_digit!
)