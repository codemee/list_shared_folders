@echo off
Setlocal EnableDelayedExpansion

set /a total=0
@rem net view �i�H��� UNC ���|�U���Ҧ����ɸ귽
@rem �C�@�泣�O �귽�W�� �귽���� ���榡
for /f "tokens=1,2" %%l in ('net view %1') do (
  @REM -----------------------------------
  @REM    1(l)   2(m)
  @REM �@�ΦW��   ����  �ϥΤ覡  ����
  @REM books     Disk
  @REM CPP       Disk  
  @REM -----------------------------------
  @rem �귽������ Disk ���N�O��Ƨ�
  if "%%m"=="Disk" (
    set full_path=%1\%%l
    set get_total=F
    @rem dir /s �i�H���j�C�X�l��Ƨ��P�ɮרòέp�`�ζq
    for /f "tokens=1,3" %%p in ('dir /s !full_path!') do (
      @rem -------------------------------------------------
      @rem         1(p)
      @REM  �ɮ׼ƥ��`�p:
      @rem         1(p)     2            3(q)
      @REM          291 ���ɮ�      82,151,599 �줸��
      @REM          149 �ӥؿ�  30,767,378,432 �줸�եi��
      @rem -------------------------------------------------
      @rem �w�g��F�˼ƲĤG��, �]�N�O�`�p�ζq
      if "!get_total!"=="T" (
        set subtotal=%%q
        @rem �N��ܥζq���� ',' �h��
        echo %%l �ζq�G!subtotal:,=!
        set /a total+=!subtotal:,=!
        set get_total=F
      )
      @rem dir /s �˼ƲĤT��O�y�ɮ׼ƥ��`�p:�z
      if "%%p"=="�ɮ׼ƥ��`�p:" (
        set get_total=T
      )
    )
  )
)
echo �`�ζq�G%total%


