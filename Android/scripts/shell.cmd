SET CURDIR=%~dp0
call %CURDIR%\env.cmd

%HOMEDRIVE%
pushd %CURDIR%
start powershell.exe

popd


