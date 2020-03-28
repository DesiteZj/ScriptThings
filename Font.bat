@echo off
:: ???????
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
:: ????UTF-8??
chcp 65001
cls
:start
echo ????? 
echo     1????????????eudcedit.exe???????????????? 
echo        ????????????? 
echo     2????????"?????"?????????????? 
echo     3?????????????????????? 
echo:
:: ????
SET PATH_WINDOWS_SYSTEM32=%systemroot%/System32
SET PATH_FRONT_BACKUP=%~dp0\BACKUP_DO_NOT_DELETE
SET PATH_FRONT_IMPORT_FILE=%~dp0\Import
SET PATH_EUDC_TTE_FILE=%~dp0\Import\EUDC.TTE
SET PATH_EUDC_EUF_FILE=%~dp0\Import\EUDC.EUF
SET PATH_REGEDIT_EUDC=HKEY_CURRENT_USER\EUDC\936
SET KEY_REGEDIT_EUDC=SystemDefaultEUDCFont
SET FILENAME_TEMP=%PATH_FRONT_BACKUP%\temp.txt

echo ?????????????????1??  
echo 1. ?????? 
echo 2. ??????? 
echo 3. ????????BACKUP_DO_NOT_DELETE 
echo 4. ??????? 
SET choice=
SET /p choice=Type the number to print text.
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto openEudcedit
if '%choice%'=='2' goto openCharmap
if '%choice%'=='3' goto backupFront
if '%choice%'=='4' goto importFront

echo "%choice%" is not valid, try again
echo.
goto start

:openEudcedit
echo OpenEudcedit
%PATH_WINDOWS_SYSTEM32%/eudcedit.exe
goto end

:openCharmap
echo openCharmap
%PATH_WINDOWS_SYSTEM32%/charmap.exe
goto end

:backupFront
echo BackupFront
if not exist %PATH_FRONT_BACKUP% md %PATH_FRONT_BACKUP%

Setlocal enabledelayedexpansion 
for /f "skip=2 delims=: tokens=1,*" %%a in ('REG QUERY %PATH_REGEDIT_EUDC% /v %KEY_REGEDIT_EUDC%') do ( 
   set str_1=%%a
   set str_2=%%b
) 
::set "str_1=!str_1:"=!" 
::if not "!var:~-1!"=="=" set value="!str:~-1%:!var!" 
set Path_Front_Files=%str_1:~-1%:%str_2:~0,-9%

copy /y %Path_Front_Files%\eudc*.* %PATH_FRONT_BACKUP%

REM echo %PATH_EUDC_TTE_FILE%>>%FILENAME_TEMP%
REM echo %PATH_EUDC_EUF_FILE%>>%FILENAME_TEMP%
REM makecab /f %FILENAME_TEMP%

goto end

:importFront
echo ImportFront

Setlocal enabledelayedexpansion 
for /f "skip=2 delims=: tokens=1,*" %%a in ('REG QUERY %PATH_REGEDIT_EUDC% /v %KEY_REGEDIT_EUDC%') do ( 
   set str_1=%%a
   set str_2=%%b
) 
::set "str_1=!str_1:"=!" 
::if not "!var:~-1!"=="=" set value="!str:~-1%:!var!" 
set Path_Front_Files=%str_1:~-1%:%str_2:~0,-9%

ren %Path_Front_Files%\EUDC.TTE EUDC.TTE.bak
ren %Path_Front_Files%\EUDC.EUF EUDC.EUF.bak
copy %PATH_FRONT_IMPORT_FILE% %Path_Front_Files%

goto end

:end
pause
