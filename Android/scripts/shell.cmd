SET CURDIR=%~dp0
call %CURDIR%\env.cmd

%HOMEDRIVE%
pushd %HOMEPATH%\Documents\git

start powershell.exe
rem start cmd
popd


