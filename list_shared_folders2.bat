@echo off
Setlocal EnableDelayedExpansion

set /a total=0
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
        set /a total+=%%g
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
                set /a total+=%%q
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
echo �`�ζq�G%total%


