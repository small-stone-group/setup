@echo off
setlocal enabledelayedexpansion

:: EXIT IF NO PROJECT FOLDER SPECIFIED
if "%~1"=="" (
    echo Error: No project directory specified
    pause
    exit
)

set NEWLINE = ^& echo.
cd /D "C:\xampp\htdocs"

for %%s in (cf-framework, sle-admin, sle-epos) do (
    set %%s=%%s: =%

    :: CLONE REPO
    git clone --recursive https://github.com/small-stone-group/%%s.git
    echo %%s cloned

    :: MAKE DIRECTORY JUNCTION
    mklink /J "%~1\%%s" "%CD%\%%s"
    echo Directory junction made

    :: ADD HOSTS
    echo %NEWLINE%^127.0.0.1 %%s.lan >> %WINDIR%\System32\drivers\etc\hosts
    echo %NEWLINE%^127.0.0.1 dev.%%s.lan >> %WINDIR%\System32\drivers\etc\hosts

    echo Hosts added

    :: ADD VIRTUAL HOST DIRECTIVE
    if exist C:\xampp\htdocs\%%s\httpd-vhosts.conf (
        type C:\xampp\htdocs\%%s\httpd-vhosts.conf >> C:\xampp\apache\conf\extra\httpd-vhosts.conf
        echo Virtual host directive added
    )

    echo %%s completed
)

echo All operations completed

pause
