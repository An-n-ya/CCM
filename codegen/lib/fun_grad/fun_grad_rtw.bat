@echo off

call "H:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\..\..\VC\Auxiliary\Build\VCVARSALL.BAT" AMD64


call  "\\ANKH-DESKTOP\F$\Program Files\matlab\R2017b\bin\win64\checkMATLABRootForDriveMap.exe" "\\ANKH-DESKTOP\F$\Program Files\matlab\R2017b"  > mlEnv.txt
for /f %%a in (mlEnv.txt) do set "%%a"\n
cd .

if "%1"=="" (nmake MATLAB_ROOT=%MATLAB_ROOT% ALT_MATLAB_ROOT=%ALT_MATLAB_ROOT% MATLAB_BIN=%MATLAB_BIN% ALT_MATLAB_BIN=%ALT_MATLAB_BIN%  -f fun_grad_rtw.mk all) else (nmake MATLAB_ROOT=%MATLAB_ROOT% ALT_MATLAB_ROOT=%ALT_MATLAB_ROOT% MATLAB_BIN=%MATLAB_BIN% ALT_MATLAB_BIN=%ALT_MATLAB_BIN%  -f fun_grad_rtw.mk %1)
@if errorlevel 1 goto error_exit

exit /B 0

:error_exit
echo The make command returned an error of %errorlevel%
An_error_occurred_during_the_call_to_make
