@echo off
setlocal

:: Check for patches and delete them
del /s /q "%~dp0..\dinput8.dll"
del /s /q "%~dp0..\ModManager.Core.dll"
del /s /q "%~dp0..\ModManager.NativeInterop.dll"
del /s /q "%~dp0..\NLog.dll"
del /s /q "%~dp0..\ScriptHookRDR2.dll"

:: Check for Lenny Mod Loader and delete it
rmdir /s /q "%~dp0..\lml"

:: Check for ASI and INI files placed in game directory and delete them
del /s /q "%~dp0..\lml.ini"
del /s /q "%~dp0..\BarBrawls.asi"
del /s /q "%~dp0..\NoBulletTrail.asi"
del /s /q "%~dp0..\RDR2NoBlackBars.asi"
del /s /q "%~dp0..\vfs.asi"

timeout /t 1 /nobreak >nul

exit
