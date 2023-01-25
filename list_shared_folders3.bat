@echo off
Setlocal EnableDelayedExpansion

@rem net view �i�H��� UNC ���|�U���Ҧ����ɸ귽
@rem �C�@�泣�O �귽�W�� �귽���� ���榡
for /f "tokens=1,2" %%l in ('net view %1') do (
  @rem �귽������ Disk ���N�O��Ƨ�
  if "%%m"=="Disk" (
    set full_path=%1\%%l
    @rem dir /s �w�]���]�t������, �Y�S�� /s �h���|
    for /f "tokens=2,3,4,5" %%f in ('dir /a/-c !full_path!') do (
      @rem --------------------------------------------------
      @rem                1  2(f)            3(g)  4(h)
      @rem               43 ���ɮ�         4938370 �줸��
      @rem --------------------------------------------------
      if "%%f"=="���ɮ�" (
        echo !full_path! �ζq�G%%g
        call :uni_add %%g
      )
      @rem -------------------------------------------------
      @rem          1  2(f)  3(g)     4(h)              5(i)
      @rem 2022/05/03  �U�� 01:42    <DIR>          test_ini
      @rem --------------------------------------------------
      if "%%h"=="<DIR>" (
        if not "%%i"=="." (
          if not "%%i"==".." (
            set sub_path=!full_path!\%%i
            @rem dir /s �i�H���j�C�X�l��Ƨ��P�ɮרòέp�`�ζq
            set get_total=F
            for /f "tokens=1,3" %%p in ('dir /s /-c !sub_path!') do (
              @rem -------------------------------------------------
              @rem         1(p)
              @REM  �ɮ׼ƥ��`�p:
              @rem         1(p)     2            3(q)
              @REM         3781 ���ɮ�        71280427 �줸��
              @REM         1501 �ӥؿ�     30558121984 �줸�եi��          
              @rem -------------------------------------------------
              @rem �w�g��F�˼ƲĤG��, �]�N�O�`�p�ζq
              if "!get_total!"=="T" (
                echo !sub_path! �l��Ƨ��ζq�G%%q
                call :uni_add %%q
                set get_total=F
              )
              @rem dir /s �˼ƲĤT��O�y�ɮ׼ƥ��`�p:�z
              if "%%p"=="�ɮ׼ƥ��`�p:" (
                set get_total=T
              )
            )
          )
        )
      )
    )  
  )
)
echo �`�ζq�G%tot_s%
goto:eof

:uni_add
set num=%~1
@rem ���o���
for /l %%d in (0, 1, 98) do (
  if not "!num:~%%d,1!" == "" (
    set /a digits=%%d + 1
  )
)
@rem �C�T��Ƥ@�ӳ��|�ѤU�X���
set /a remain_digits=digits%%3
@rem �T��Ƥ@�ӳ��@���X���
set /a r_digit=digits - remain_digits
@rem �i��ƭ�
set /a carry=0
@rem �̧Ǩ��o�C�T�쪺�Ʀr
for /l %%d in (-3, -3, -!r_digit!) do (
  set sub_sum[%%d]=!num:~%%d,3!
)
set /a r_digit+=3
set /a r_digit=-r_digit
@rem ���o�����T�쪺�̥���Ѿl�Ʀr
for %%d in (!remain_digits!) do (
  @REM echo !num:~0,%%d!
  set sub_sum[!r_digit!]=!num:~0,%%d!
)

@rem �`�ǤT��@�ձN�p�p�P�ثe�`�p�ۥ[
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
@rem �B�z�i��
if !carry! gtr 0 (
  set /a r_digit-=3
  for /l %%d in (!r_digit!, -3, !max_digit!) do (
    @rem �ѩ� 0 �}�Y���Ʀr�|�Q�� 8 �i��
    @rem �o�̱Ĩ��[ 1000000 �A�����H 1000 ���l�ƨ��קK
    set /a temp=1000!totals[%%d]!%%1000+carry
    set /a carry=temp/1000
    set /a temp=temp%%1000
    set totals[%%d]=!temp!
  )
)
@rem ��s�ثe�̰����
if !max_digit! gtr !r_digit! set /a max_digit=r_digit
@rem �i���s���@�դT���
if !carry! gtr 0 (
  set /a max_digit-=3
  for %%d in (!max_digit!) do (
    set totals[%%d]=carry
  )
)
@rem �ΤT��@�ժ��榡����`�p
set tot_s=
for /l %%d in (!max_digit!, 3, -3) do (
  set temp_s=1000!totals[%%d]!
  @rem �ѩ�p�⵲�G�i�ण��T���
  @rem �o�̥ίS�O���ޥ��ɤW�}�Y�� 0
  set tot_s=!tot_s!,!temp_s:~-3,3!
)
set tot_s=!tot_s:~1!
exit /b