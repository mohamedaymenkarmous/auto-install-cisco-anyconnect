@echo off
cd %~dp0

echo Installing Cisco Anyconnect Core
call msiexec /package 1-anyconnect-win-4.5.02036-core-vpn-predeploy-k9.msi /norestart /passive /quiet /lvx* "tmp\1-anyconnect-win-4.5.02036-core-vpn-predeploy-k9.log"

if %errorlevel% neq 0 (
call :FailError "Installing Cisco Anyconnect Core"
pause
goto :EOF
)

echo Installing Cisco Anyconnect NAM
call msiexec /package 2-anyconnect-win-4.5.02036-nam-predeploy-k9.msi /norestart /passive /quiet /lvx* "tmp\2-anyconnect-win-4.5.02036-nam-predeploy-k9.log"

REM This is how we check if NAM installation is successfull. Never check %errorlevel% because it will always give a wrong result as long as we stopped temporarly system rebooting
if not exist "C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\Network Access Manager\newConfigFiles" (
call :FailError "Installing Cisco Anyconnect NAM"
pause
goto :EOF
)

echo Installing Cisco Anyconnect ISE Posture
call msiexec /package 3-anyconnect-win-4.5.02036-iseposture-predeploy-k9.msi /norestart /passive /quiet /lvx* "tmp\3-anyconnect-win-4.5.02036-iseposture-predeploy-k9.log"

if %errorlevel% neq 0 (
call :FailError "Installing Cisco Anyconnect ISE Posture"
pause
goto :EOF
)

echo Installing Cisco Anyconnect DART
call msiexec /package 4-anyconnect-win-4.5.02036-dart-predeploy-k9.msi /norestart /passive /quiet /lvx* "tmp\4-anyconnect-win-4.5.02036-dart-predeploy-k9.log"

if %errorlevel% neq 0 (
call :FailError "Installing Cisco Anyconnect DART"
pause
goto :EOF
)

echo Creating directory if not exist: C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\Network Access Manager\newConfigFiles
if not exist "C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\Network Access Manager\newConfigFiles\" md "C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\Network Access Manager\newConfigFiles\"

if %errorlevel% neq 0 (
call :FailError "Creating directory if not exist: C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\Network Access Manager\newConfigFiles"
pause
goto :EOF
)

echo Copying configuration.xml file
COPY "Profiles\nam\configuration.xml" "C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\Network Access Manager\newConfigFiles\"

if %errorlevel% neq 0 (
call :FailError "Copying configuration.xml file"
pause
goto :EOF
)

echo Creating directory if not exist: C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\l10n\
if not exist "C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\l10n\" md "C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\l10n"

if %errorlevel% neq 0 (
call :FailError "Creating directory if not exist: C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\l10n\"
pause
goto :EOF
)

echo Copying fr-fr language directory
XCOPY "Profiles\custom\fr-fr" "C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\l10n\" /Y /E

if %errorlevel% neq 0 (
call :FailError "Copying fr-fr language directory"
pause
goto :EOF
)

echo Copying company_logo.png
COPY "Profiles\custom\company_logo.png" "%PROGRAMFILES(X86)%\Cisco\Cisco AnyConnect Secure Mobility Client\res\"

if %errorlevel% neq 0 (
call :FailError "Copying company_logo.png"
pause
goto :EOF
)

echo Disabling EnforceSingleLogon registry key
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{B12744B8-5BB7-463a-B85E-BB7627E73002}" /v EnforceSingleLogon /t REG_DWORD /d 0 /f

if %errorlevel% neq 0 (
call :FailError "Disabling EnforceSingleLogon registry key"
pause
goto :EOF
)

for /f "delims=" %%a in ('wmic os get Caption ^| findstr "Microsoft"') do call :Win10WA "%%a"

call :Reboot

pause
goto :EOF

REM Windows 10 Workaround
:Win10WA
set OSVersion=%1
echo Disabling LsaAllowReturningUnencryptedSecrets registry key if Windows 10 is used
echo %OSVersion% | findstr "10" && reg add HKLM\System\CurrentControlSet\Control\Lsa /v LsaAllowReturningUnencryptedSecrets /t REG_DWORD /d 1 /f && echo Windows 10 is really used
goto :eof

REM Failed execution. Exit
:FailError
echo Failed with error #%errorlevel% on step %1
msg * "Failed with error #%errorlevel% on step %1"
exit /b %errorlevel%
goto :eof

REM Reboot the computer
:Reboot
echo ""
echo "Please reboot your computer to finish the installation"
echo ""
msg * "Please reboot your computer to finish the installation"
goto :eof
