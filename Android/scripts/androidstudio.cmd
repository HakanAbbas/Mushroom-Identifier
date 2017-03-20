SET CURDIR=%~dp0
call %CURDIR%\env.cmd

%HOMEDRIVE%
pushd "C:\Program Files\Android\Android Studio\bin"
start studio64.exe
popd


