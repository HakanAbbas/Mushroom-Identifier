SET CURDIR=%~dp0
call %CURDIR%env.cmd

python %NDK%\build\tools\make_standalone_toolchain.py --arch x86_64 --api 24 --stl=stlport --unified-headers --install-dir %STANDALONE_TOOLCHAIN%
