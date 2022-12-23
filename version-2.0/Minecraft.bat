@echo off

::setting

set auto_updata=true
set server_url=https://raw.githubusercontent.com/chenghao0415/Minecraft_portable/main
set original_name=Minecraft.bat

::end_setting

set version=version-2.0
set file_name=%~nx0
set rand=%random%

title check updata
mode con lines=5 cols=25

if "%1%"=="--del" (
	if exist %cd%\%file_name%_updata.bat del %cd%\%file_name%_updata.bat
	exit
)

if not "%auto_updata%"=="true" goto main

::updata

if exist %cd%\%file_name%_updata.bat del %cd%\%file_name%_updata.bat
echo @echo off>>"%cd%\%file_name%_updata.bat"
echo title check version>>"%cd%\%file_name%_updata.bat"
echo mode con cols=20 lines=3 >>"%cd%\%file_name%_updata.bat"
echo echo check link>>"%cd%\%file_name%_updata.bat"
echo FOR /F "tokens=2 delims=/" %%%%i in ^("%server_url%"^) do set server_host=%%%%i>>"%cd%\%file_name%_updata.bat"
echo ping -n 2 %%server_host%%^>nul>>"%cd%\%file_name%_updata.bat"
echo if %%errorlevel%%==0 (>>"%cd%\%file_name%_updata.bat"
echo cls>>"%cd%\%file_name%_updata.bat"
echo goto updata>>"%cd%\%file_name%_updata.bat"
echo ) else (>>"%cd%\%file_name%_updata.bat"
echo goto end>>"%cd%\%file_name%_updata.bat"
echo )>>"%cd%\%file_name%_updata.bat"
echo :updata>>"%cd%\%file_name%_updata.bat"
echo echo check version>>"%cd%\%file_name%_updata.bat"
echo bitsadmin.exe /transfer "download" %server_url%/version.txt %%cd%%\version.txt^>nul>>"%cd%\%file_name%_updata.bat"
echo for /f %%%%i in (%%cd%%/version.txt) do set new_version=%%%%i>>"%cd%\%file_name%_updata.bat"
echo if "%%new_version%%"=="%version%" (>>"%cd%\%file_name%_updata.bat"
echo cls>>"%cd%\%file_name%_updata.bat"
echo echo This version is the latest!>>"%cd%\%file_name%_updata.bat"
echo del /q %%cd%%\version.txt>>"%cd%\%file_name%_updata.bat"
echo ping -w 500 -n 2 0.0.0.0^>nul>>"%cd%\%file_name%_updata.bat"
echo goto end>>"%cd%\%file_name%_updata.bat"
echo ) else (>>"%cd%\%file_name%_updata.bat"
echo title Download new version!>>"%cd%\%file_name%_updata.bat"
echo echo Download new version!>>"%cd%\%file_name%_updata.bat"
echo mode con cols=70 lines=15>>"%cd%\%file_name%_updata.bat"
echo del /q %%cd%%\version.txt>>"%cd%\%file_name%_updata.bat"
echo bitsadmin.exe /transfer "download" %server_url%/%%new_version%%/%original_name% %%cd%%\%file_name%>>"%cd%\%file_name%_updata.bat"
echo cls>>"%cd%\%file_name%_updata.bat"
echo )>>"%cd%\%file_name%_updata.bat"
echo :end>>"%cd%\%file_name%_updata.bat"
echo cls>>"%cd%\%file_name%_updata.bat"
echo mode con cols=20 lines=3 >>"%cd%\%file_name%_updata.bat"
echo title End!>>"%cd%\%file_name%_updata.bat"
echo echo end>>"%cd%\%file_name%_updata.bat"
echo ping -w 500 -n 2 0.0.0.0^>nul>>"%cd%\%file_name%_updata.bat"
echo start /min /i %cd%\%file_name% --del>>"%cd%\%file_name%_updata.bat"
echo exit>>"%cd%\%file_name%_updata.bat"

start /d "%cd%" /min /i %cd%\%file_name%_updata.bat

:main

set root=%cd%\Minecraft

mode con cols=35 lines=7
title Minecraft
color 02

::data

if not exist "%appdata%\.minecraft" set appdatafile=1
if not exist "%root%" mkdir "%root%"
if not exist "%root%\app" mkdir "%root%\app"

::log
if not exist "%root%\app\log.txt" (
	echo [Info:    %date% %time%] First Run!>>"%root%\app\log.txt"
	echo [Data:    %date% %time%] Root:%root%!>>"%root%\app\log.txt"
) else (
	echo.>>"%root%\app\log.txt"
)

:start
cls
mode con cols=35 lines=7
if not exist "%root%\app\Minecraft.exe" (
	goto nofile
) else (
	echo Start Minecraft
	echo [Info:    %date% %time%] Minecraft start!>>"%root%\app\log.txt"
	echo [Data:    %date% %time%] Computer name:%computername%>>"%root%\app\log.txt"
	echo [Data:    %date% %time%] User name:%username%>>"%root%\app\log.txt"
	"%root%\app\Minecraft.exe" --workDir "%root%\data"
)

if %appdatafile%==1 (
	rmdir /q /s  "%appdata%\.minecraft"
	echo [Info:    %date% %time%] Remove %appdata%\.minecraft Folder!>>"%root%\app\log.txt"
)

echo [Info:    %date% %time%] Exit!>>"%root%\app\log.txt"
exit

:nofile
echo [Warning: %date% %time%] %root%\app\Minecraft.exe no find!>>"%root%\app\log.txt"
echo You don't have Minecraft.exe file!
set /p in="Do you download it?(Y/N):"
if *%in%==*Y (
	goto download
)else (
	rmdir /q /s  %root%
	echo [Info:    %date% %time%] Remove file!>>"%root%\app\log.txt"
	echo [Info:    %date% %time%] Exit!>>"%root%\app\log.txt"
	exit
)
goto start

:download
cls
mode con cols=70 lines=15
echo Download Minecraft.exe
echo.
echo Check network...
ping -n 2 %download_host%>nul
if %errorlevel%==0 (
	echo ok!
	echo.
	echo Start download!
) else (
	echo error!!
	echo [Warning:    %date% %time%] Net error!>>"%root%\app\log.txt"
	ping -w 1000 -n 2 0.0.0.0>nul
	rmdir /q /s  %root%
	echo [Info:    %date% %time%] Remove file!>>"%root%\app\log.txt"
	echo [Info:    %date% %time%] Exit!>>"%root%\app\log.txt"
	exit
)

echo [Info:    %date% %time%] Start download!>>"%root%\app\log.txt"
set /a dt=%date:~0,4%%date:~5,2%%date:~8,2%
bitsadmin.exe /transfer "download" "%download%" "%root%\app\Minecraft.exe"
cls
echo Download Finish!
echo [Info:    %date% %time%] Download finish!>>"%root%\app\log.txt"
ping -w 1000 -n 2 0.0.0.0>nul
goto start