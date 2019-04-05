@echo off

echo Working directory set to %TEMP%
cd %TEMP%

echo Purging working directory
rd /s /q Anyconnect-install-dir

if %errorlevel% neq 0 (
call :FailError "Purging working directory"
pause
goto :EOF
)

echo Installing Cisco Anyconnect ISE Postur
if not exist Anyconnect-install-dir md Anyconnect-install-dir

if %errorlevel% neq 0 (
call :FailError "Installing Cisco Anyconnect ISE Posture"
pause
goto :EOF
)

echo working directory set to %TEMP%\Anyconnect-install-dir
cd Anyconnect-install-dir

echo Copying locally \\<REMOTE_HOST>\<REMOTE_DIRECTORY>
xcopy \\<REMOTE_HOST>\<REMOTE_DIRECTORY>  . /Y /E

if %errorlevel% neq 0 (
call :FailError "Copy installting files locally"
pause
goto :EOF
)

echo Starting local installation
"0-EXECUTE-AS-ADMIN-LOCAL.bat"

if %errorlevel% neq 0 (
call :FailError "Execution of 0-EXECUTE AS ADMIN LOCAL.bat locally"
pause
goto :EOF
)

goto :EOF

REM Failed execution. Exit
:FailError
echo Failed with error #%errorlevel% on step %1
msg * "Failed with error #%errorlevel% on step %1"
exit /b %errorlevel%
goto :eof
