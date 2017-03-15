SET CURDIR=%~dp0
call %CURDIR%\env.cmd

%HOMEDRIVE%
pushd %HOMEPATH%\Downloads

start powershell.exe
start cmd
popd


