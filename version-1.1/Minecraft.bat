@echo off

if not exist %appdata%\minecraft_portable_config.txt (
	echo make by chenghao>>%appdata%\minecraft_portable_config.txt
	echo %date% %time%>>%appdata%\minecraft_portable_config.txt
	echo.>>%appdata%\minecraft_portable_config.txt
	echo autoUpdata=true>>%appdata%\minecraft_portable_config.txt
	echo root=%cd%\Minecraft>>%appdata%\minecraft_portable_config.txt
	echo serverHost=github.com>>%appdata%\minecraft_portable_config.txt
	echo serverUrl=https://raw.githubusercontent.com/chenghao0415/Minecraft_portable/main>>%appdata%\minecraft_portable_config.txt
	echo download=https://launcher.mojang.com/download/Minecraft.exe>>%appdata%\minecraft_portable_config.txt
	echo downloadHost=launcher.mojang.com>>%appdata%\minecraft_portable_config.txt
)

FOR /F "skip=1 tokens=1,2 delims==" %%i in (%appdata%\minecraft_portable_config.txt) do if "root"=="%%i" (
	set root="%%j"
) else (
	if "serverHost"=="%%i" (
		set server_host=%%j
	) else (
		if "serverUrl"=="%%i" (
			set server_url=%%j
		) else (
			if "download"=="%%i" (
				set download=%%j
			) else (
				if "downloadHost"=="%%i" (
					set download_host=%%j
				) else (
					if "autoUpdata"=="%%i" (
						set auto_updata=%%j
					)
				)
			)
		)
	)
)

if "%auto_updata%"=="false" goto main

set version=version-1.1
set file_name=Minecraft.bat

title check updata
mode con lines=5 cols=25

::link

del /f /q %cd%\updata.bat
cls

ping -n 2 %server_host%>nul

if %errorlevel%==0 (
	goto updata
) else (
	goto main
)

:updata

echo check version

bitsadmin.exe /transfer "download" %server_url%/version.txt %cd%\version.txt>nul

for /f %%i in (%cd%/version.txt) do set new_version=%%i

if %new_version%==%version% (
	echo This version is the latest!
	del /q %cd%\version.txt
	goto main
) else (
	echo Download new version!
	del /q %cd%\version.txt
	echo @echo off>>%cd%\updata.bat
	echo title updata>>%cd%\updata.bat
	echo mode con cols=70 lines=15>>%cd%\updata.bat
	echo echo Download new version!>>%cd%\updata.bat
	echo del /q %cd%\%file_name%>>%cd%\updata.bat
	echo bitsadmin.exe /transfer "download" %server_url%/%new_version%/%file_name% %cd%\%file_name%>>%cd%\updata.bat
	echo cls>>%cd%\updata.bat
	echo start /d %cd% %cd%\%file_name%>>%cd%\updata.bat
	echo exit>>%cd%\updata.bat
	start /d %cd% /min /i %cd%\updata.bat
	exit
)

:main
cls

mode con cols=35 lines=7
title Minecraft
color 02

::data

if not exist %appdata%\.minecraft set appdatafile=1
if not exist %root% mkdir %root%
if not exist %root%\app mkdir %root%\app

::log
if not exist %root%\app\log.txt (
	echo [Info:    %date% %time%] First Run!>>%root%\app\log.txt
	echo [Data:    %date% %time%] Root:%root%!>>%root%\app\log.txt
) else (
	echo.>>%root%\app\log.txt
)

:start
cls
mode con cols=35 lines=7
if not exist %root%\app\Minecraft.exe (
	goto nofile
) else (
	echo Start Minecraft
	echo [Info:    %date% %time%] Minecraft start!>>%root%\app\log.txt
	"%root%\app\Minecraft.exe" --workDir %root%\data
)

if %appdatafile%==1 (
	rmdir /q /s  %appdata%\.minecraft
	echo [Info:    %date% %time%] Remove %appdata%\.minecraft Folder!>>%root%\app\log.txt
)

echo [Info:    %date% %time%] Exit!>>%root%\app\log.txt
exit

:nofile
echo [Warning: %date% %time%] %root%\app\Minecraft.exe no find!>>%root%\app\log.txt
echo You don't have Minecraft.exe file!
set /p in="Do you download it?(Y/N):"
if *%in%==*Y (
	goto download
)else (
	rmdir /q /s  %root%
	echo [Info:    %date% %time%] Remove file!>>%root%\app\log.txt
	echo [Info:    %date% %time%] Exit!>>%root%\app\log.txt
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
	echo [Warning:    %date% %time%] Net error!>>%root%\app\log.txt
	ping -w 1000 -n 2 0.0.0.0>nul
	rmdir /q /s  %root%
	echo [Info:    %date% %time%] Remove file!>>%root%\app\log.txt
	echo [Info:    %date% %time%] Exit!>>%root%\app\log.txt
	exit
)

echo [Info:    %date% %time%] Start download!>>%root%\app\log.txt
set /a dt=%date:~0,4%%date:~5,2%%date:~8,2%
bitsadmin.exe /transfer "download" %download% %root%\app\Minecraft.exe
cls
echo Download Finish!
echo [Info:    %date% %time%] Download finish!>>%root%\app\log.txt
ping -w 1000 -n 2 0.0.0.0>nul
goto start

