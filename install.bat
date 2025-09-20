@echo off
setlocal

:: Create 'temp' directory
if not exist "%~dp0\bin\temp" mkdir "%~dp0\bin\temp"

:: Set current version number
set /p current=<version.txt

:: Get latest version file
echo Comparing versions...
type NUL > "%~dp0\bin\temp\version_new.txt"
powershell -c "(Invoke-WebRequest -URI 'https://raw.githubusercontent.com/Lewwy95/rdr2-mod/main/version.txt').Content | Set-Content -Path '%~dp0\bin\temp\version_new.txt'"
cls

:: Set latest version number
set /p new=<"%~dp0\bin\temp\version_new.txt"

:: Print version information
echo Checking for updates...
echo.
echo Current: v%current%
echo Latest: v%new%
timeout /t 2 /nobreak >nul
cls

:: Clear new version file
del /s /q "%~dp0\bin\temp\version_new.txt"
cls

:: Check for different version files
if %new% neq %current% (
    echo Update required! Downloading...
    timeout /t 2 /nobreak >nul
    cls
    goto download
)

:: Check for install
if exist "%~dp0..\ScriptHookRDR2.dll" goto launch

:: Not installed
echo Not installed! Installing...
timeout /t 2 /nobreak >nul
cls
goto install

:: Downloader
:download
echo Downloading latest revision...
echo.
powershell -c "(New-Object System.Net.WebClient).DownloadFile('https://github.com/Lewwy95/rdr2-mod/archive/refs/heads/main.zip','%~dp0\bin\temp\rdr2-mod-main.zip')"
cls

:: Extract latest revision
echo Extracting latest revision...
powershell -c "Expand-Archive '%~dp0\bin\temp\rdr2-mod-main.zip' -Force '%~dp0\bin\temp'"
cls

:: Deploy latest revision
echo Deploying latest revision...
xcopy /s /y "%~dp0\bin\temp\rdr2-mod-main\*" "%~dp0"
cls

:: Apply new version file
break>version.txt
powershell -c "(Invoke-WebRequest -URI 'https://raw.githubusercontent.com/Lewwy95/rdr2-mod/main/version.txt').Content | Set-Content -Path '%~dp0\version.txt'"
cls

:: Install the modded files
:install
echo Installing mods...
if not exist "%~dp0..\ScriptHookRDR2.dll" (
    :: Extract dll files and move them to the game directory
    powershell -c "Expand-Archive '%~dp0\bin\root\dll.zip' -Force '%~dp0\bin\temp'"
    xcopy /s /y /i "%~dp0\bin\temp\*" "%~dp0..\"
    del /s /q "%~dp0\bin\temp\*"

    :: Extract ASI and INI files and move them to the game directory
    powershell -c "Expand-Archive '%~dp0\bin\root\asi-ini.zip' -Force '%~dp0\bin\temp'"
    xcopy /s /y /i "%~dp0\bin\temp\*" "%~dp0..\"
    del /s /q "%~dp0\bin\temp\*"

    :: Extract LML folder and move it to the game directory
    xcopy /s /y /i "%~dp0\bin\root\*" "%~dp0..\"

    :: Delete left over files (if applicable)
    del /s /q "%~dp0..\dll.zip"
    del /s /q "%~dp0..\asi-ini.zip"
)
cls

:: Clear 'temp' folder
echo Cleaning up...
del /s /q "%~dp0\bin\temp\*"
rmdir /s /q "%~dp0\bin\temp"
mkdir "%~dp0\bin\temp"
cls

:: Launch game
:launch
echo Launching game...
start "" "steam://rungameid/1174180"

exit
