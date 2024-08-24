@echo off
git add .
for /f "tokens=1-4 delims=/ " %%a in ("%date%") do set date=%%a-%%b-%%c
for /f "tokens=1-2 delims=:," %%a in ("%time%") do set time=%%a-%%b
set datetime=%date% %time%
git commit -m "my info - Date: %datetime%"
git pull
git push
pause
