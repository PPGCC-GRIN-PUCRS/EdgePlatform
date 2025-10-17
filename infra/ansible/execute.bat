@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ===== USER SETTINGS =====
set "PLAYBOOKS_SUBDIR=playbooks"
set "INVENTORY_FILE=inventory\rpis.ini"
set "DEFAULT_PLAYBOOK=monitor/health-check.yml"
set "WSL_DISTRO=Ubuntu"
REM set "DEBUG_EXEC=1"

rem ===================== defaults =====================
set "PLAYBOOK="
set "EXTRA_VARS="
set "TRACE="

rem ===================== arg parsing ==================
:parse
if "%~1"=="" goto :done_parse

if /I "%~1"=="--help"  (call :usage & exit /b 0)
if /I "%~1"=="-h"  (call :usage & exit /b 0)
if /I "%~1"=="--trace" (set "TRACE=1" & shift & goto :parse)

rem -e "key=value"  OR  -e key=value
if /I "%~1"=="-e" (
  if "%~2"=="" (echo [err] -e needs key=value & exit /b 2)
  call :add_kv "%~2"
  shift & shift & goto :parse
)

rem load many vars from a file (KEY=VALUE per line, # for comments)
if /I "%~1"=="--env-file" (
  if "%~2"=="" (echo [err] --env-file needs a path & exit /b 2)
  call :load_env "%~2"
  shift & shift & goto :parse
)

rem first non-flag token is the playbook
if not defined PLAYBOOK (
  set "PLAYBOOK=%~1"
  shift & goto :parse
)

echo [warn] ignoring unknown arg: %~1
shift
goto :parse

:done_parse
if not defined PLAYBOOK (
  echo [err] missing PLAYBOOK
  call :usage & exit /b 2
)

if defined TRACE (
  echo [trace] PLAYBOOK="%PLAYBOOK%"
  echo [trace] EXTRA_VARS=%EXTRA_VARS%
)

REM ===== RESOLVE REPO ROOT (has both playbooks\ and inventory\) =====
set "SCRIPT_DIR=%~dp0"
for %%A in ("%SCRIPT_DIR%") do set "CUR=%%~fA"
set "PROJECT_DIR="
for /l %%N in (0,1,6) do (
  if exist "!CUR!playbooks\" if exist "!CUR!inventory\" (set "PROJECT_DIR=!CUR!" & goto :got_repo_root)
  for %%B in ("!CUR!..\") do set "CUR=%%~fB"
)
:got_repo_root
if not defined PROJECT_DIR set "PROJECT_DIR=%SCRIPT_DIR%"
if not "%PROJECT_DIR:~-1%"=="\" set "PROJECT_DIR=%PROJECT_DIR%\"
pushd "%PROJECT_DIR%" >nul

REM ===== CHECKS =====
where wsl >nul 2>&1 || (echo [execute] ERROR: WSL not found. Install with: wsl --install -d Ubuntu & exit /b 3)

REM Resolve inventory absolute Windows path and verify it exists
for %%I in ("%PROJECT_DIR%%INVENTORY_FILE%") do set "INVENTORY_WIN=%%~fI"
if not exist "%INVENTORY_WIN%" (
  echo [execute] ERROR: Inventory not found: "%INVENTORY_WIN%"
  exit /b 2
)

if defined DEBUG_EXEC (
  echo [debug] SCRIPT_DIR=%SCRIPT_DIR%
  echo [debug] PROJECT_DIR=%PROJECT_DIR%
  echo [debug] CWD=%CD%
  echo [debug] INVENTORY_WIN=%INVENTORY_WIN%
)

REM Prefer .yml, fall back to .yaml
set "PB_ROOT=%PROJECT_DIR%%PLAYBOOKS_SUBDIR%\"
set "ext4=%PLAYBOOK:~-4%"
set "ext5=%PLAYBOOK:~-5%"
if /i "%ext4%"==".yml" (
  set "cand1=%PLAYBOOK%"
  set "cand2=%PLAYBOOK:~0,-4%.yaml"
  ) else if /i "%ext5%"==".yaml" (
  set "cand1=%PLAYBOOK%"
  set "cand2=%PLAYBOOK:~0,-5%.yml"
  ) else (
  set "cand1=%PLAYBOOK%.yml"
  set "cand2=%PLAYBOOK%.yaml"
)
if exist "%PB_ROOT%%cand1%" (
  set "PLAYBOOK=%cand1%"
  ) else if exist "%PB_ROOT%%cand2%" (
  set "PLAYBOOK=%cand2%"
  ) else (
  echo [execute] ERROR: Playbook not found: "%PROJECT_DIR%%PLAYBOOKS_SUBDIR%\%PLAYBOOK%"
  popd >nul
  exit /b 2
)

REM ===== PICK WSL DISTRO =====
set "DISTRO=%WSL_DISTRO%"
if "%DISTRO%"=="" (
  for /f "usebackq delims=" %%D in (`wsl -l -q`) do (
    set "CAND=%%D"
    if /I not "!CAND!"=="docker-desktop" if /I not "!CAND!"=="docker-desktop-data" (
      if not defined DISTRO set "DISTRO=!CAND!"
      if /I "!CAND:~0,6!"=="Ubuntu" set "DISTRO=!CAND!"
    )
  )
)
if "%DISTRO%"=="" (
  echo [execute] ERROR: No suitable WSL distro found. Install: wsl --install -d Ubuntu
  popd >nul
  exit /b 6
)

REM Convert Windows paths to WSL using the chosen distro
for /f "usebackq delims=" %%i in (`wsl -d %DISTRO% wslpath -a -u "%INVENTORY_WIN%"`) do set "WSL_INVENTORY=%%i"
if "%WSL_INVENTORY%"=="" (
  echo [execute] ERROR: Failed to resolve INVENTORY to a WSL path. Check INVENTORY_FILE and folder exists.
  popd >nul
  exit /b 7
)

REM Temp vars file for Ansible -e @file
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set timestamp=%%a%%b)
set "VARFILE_WIN=%TEMP%\ans_vars_%RANDOM%%RANDOM%.yml"
(
@REM Any other variable that should be sent to the host, can be added to this temp file
@REM Good to remember that this temp file will be deleted at the end of this script.
echo run_at: "%timestamp%"
) > "%VARFILE_WIN%"
for /f "usebackq delims=" %%i in (`wsl -d %DISTRO% wslpath -a -u "%VARFILE_WIN%"`) do set "WSL_VARFILE=%%i"

REM Ensure ansible & sshpass
wsl -d %DISTRO% ansible-playbook --version >nul 2>&1
if errorlevel 1 (
  echo [execute] ERROR: ansible-playbook not found in WSL "%DISTRO%".
  echo  Open "%DISTRO%" and run: sudo apt update && sudo apt install -y ansible
  del /f /q "%VARFILE_WIN%" >nul 2>&1
  popd >nul
  exit /b 4
)
wsl -d %DISTRO% sshpass -V >nul 2>&1
if errorlevel 1 (
  echo [execute] Installing sshpass in WSL "%DISTRO%"...
  wsl -d %DISTRO% sudo apt update
  wsl -d %DISTRO% sudo apt install -y sshpass
)

REM Windows -> WSL playbook path
set "PB_WIN=%PB_ROOT%%PLAYBOOK%"
for /f "usebackq delims=" %%I in (`wsl -d %DISTRO% wslpath -a -u "%PB_WIN%"`) do set "PB_WSL=%%~I"

rem ===================== RUN =====================

echo [execute] WSL distro: %DISTRO%
echo [execute] Inventory:  %WSL_INVENTORY%
echo [execute] Playbook:  %PB_WSL%
echo [execute] Extra args: %EXTRA_VARS%

set "CALL_CMD=ansible-playbook -i '%WSL_INVENTORY%' '%PB_WSL%' %EXTRA_VARS%"
if defined ANS_CFG_WSL (
  wsl -d %DISTRO% bash -lc "ANSIBLE_CONFIG='%ANS_CFG_WSL%' %CALL_CMD%"
  ) else (
  wsl -d %DISTRO% bash -lc "%CALL_CMD%"
)

set "RC=%ERRORLEVEL%"
del /f /q "%VARFILE_WIN%" >nul 2>&1
popd >nul
exit /b %RC%

rem ===================== helpers =====================
:add_kv
rem Requires: setlocal EnableDelayedExpansion at top of the script
set "PAIR=%~1"

rem Split on the first '=' (values can contain more '=')
for /f "tokens=1* delims==" %%K in ("%PAIR%") do (
  set "K=%%~K"
  set "V=%%~L"
)

rem Strip surrounding quotes ONLY for the environment variable
if defined V (
  if "!V:~0,1!"=="\"" if "!V:~-1!"=="\"" set "V=!V:~1,-1!"
)

rem 1) Set the env var (unquoted)
set "!K!=!V!"

rem 2) Forward to Ansible with quotes preserved:
rem  -e ^"key=value^"  (the ^ escapes the " so CMD keeps it as a literal)
if defined EXTRA_VARS (
  set "EXTRA_VARS=!EXTRA_VARS! -e ^"!K!=!V!^""
  ) else (
  set "EXTRA_VARS=-e ^"!K!=!V!^""
)
goto :eof

:usage
echo Usage:
echo  %~nx0 [--trace] PLAYBOOK [-e key=value]... [--env-file path]
echo Examples:
echo  %~nx0 tailscale/deploy -e ts_authkey=tskey-abc123
echo  %~nx0 monitor\health-check.yml --env-file .vars -e region="us-east-1"
echo Notes:
echo  - Each -e sets an environment variable and is also forwarded in %%EXTRA_VARS%%.
echo  - --env-file reads lines like  KEY=VALUE  (use # for comments).
goto :eof
