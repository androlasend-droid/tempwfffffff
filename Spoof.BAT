@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

REM Vérifie la présence des fichiers dans le même dossier que ce script
if not exist "%~dp0CatMapper.exe" (
    color b
    echo Le fichier CatMapper.exe est introuvable.
    pause>nul
    goto end
)

if not exist "%~dp0cat.sys" (
    color b
    echo Le fichier cat.sys est introuvable.
    pause>nul
    goto end
)

goto spoof

:spoof
title Dream_Spoof.
echo spoofing..

"%~dp0CatMapper.exe" --free "%~dp0cat.sys"

echo done!
goto endsuccess

:endsuccess
taskkill /im wmiprv* /f /t 2>nul>nul
taskkill /im wmiprv* /f /t 2>nul>nul
pause>nul
pause>nul
pause>nul
pause>nul
goto end

:end
