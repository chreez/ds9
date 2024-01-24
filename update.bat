@echo off
setlocal

:: Set the URL of the repository's ZIP file
set REPO_ZIP_URL=https://github.com/chreez/ds9/archive/refs/heads/main.zip

:: Get the current directory (where the batch file is located)
set CURRENT_DIR=%~dp0

:: Name of the batch file
set BATCH_FILE=update.bat

:: Download the ZIP file using PowerShell
powershell -command "Invoke-WebRequest -Uri '%REPO_ZIP_URL%' -OutFile '%CURRENT_DIR%repo.zip'"

:: Extract the ZIP file
powershell -command "Expand-Archive -Path '%CURRENT_DIR%repo.zip' -DestinationPath '%CURRENT_DIR%' -Force"

:: Move the contents up one level and remove the top-level folder
powershell -command "$zipFolder = (Get-ChildItem '%CURRENT_DIR%' | Where-Object { $_.PSIsContainer }).FullName; Get-ChildItem -Path $zipFolder -Recurse | Move-Item -Destination '%CURRENT_DIR%'; Remove-Item -Path $zipFolder -Recurse -Force"

:: Delete the ZIP file
del "%CURRENT_DIR%repo.zip"

:: Check if the batch file was updated and restart if necessary
if exist "%CURRENT_DIR%new_%BATCH_FILE%" (
    move /Y "%CURRENT_DIR%new_%BATCH_FILE%" "%CURRENT_DIR%%BATCH_FILE%"
    call "%CURRENT_DIR%%BATCH_FILE%"
    exit /b
)

endlocal