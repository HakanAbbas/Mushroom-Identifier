opencv/c++ unter Android
===========================================

opencv aus dem Source Code in der Android Native Toolchain kompilieren
----------------------------------------------------------------------

1. Android Studo in in aktuellster Version installieren
2. in den "Android SDK Tools" CMake und NDK installieren
3. Python installieren
4. CMake installieren
4. Die Datei ```scripts\env.cmd``` auf die Pfade am eigenen Rechner anpassen.
5. [Android NDK standalone toolchain](https://developer.android.com/ndk/guides/standalone_toolchain.html) durchlesen und die Parameter in der Datei ```maketoolchain.cmd``` anpassen. 
4. eine Shell öffnen durch das Doppelklicken der Datei ```shell.cmd``` im Unterverzeichnis ```scripts```, dorthin wechseln und dann von dieser Commandline aus maketoolchain.cmd ausführen, dies erstellt auf dem Desktop ein Toolchain -Verzeichnis ```ndk```
6. OpenCV [Source Code](https://github.com/opencv/opencv/releases) downloaden und in ein Verzeichnis entpacken.
7. im immer noch offenen command - prompt eingeben: cmake-gui
8. im cmake-gui das entpackte opencv source code Verzeichnis auswählen, dann Configure, dann angeben, dass man eine toolchain Datei auswählen will. Diese befindet sich im entpacketen opencv - Verzeichnis unter ```platforms\android\android.toolchain.cmake```
9. im cmake-gui als CMAKE_MAKE_COMMAND die Datei ```~\Desktop\ndk\bin\make.exe``` auswählen.
10. im cmake-gui Generate drücken. Dies erzeugt ein Build Verzeichnis.
11. dorthin mit dem Commmand-Prompt wechseln und folgendes eingeben: ```cmake --build .```
12. nach dem erfolgreichen Build folgendes eingeben: ```cmake --build . --target install```
13. dieses neu installierte install Verzcinis enthält jetzt die include und library - Dateien für die in der Toolchain gewählte Architektur.

How to compile
--------------
- Öffnen sie das Android Studio Projekt
- Öffnen sie die "Projekte" Ansicht, dies können sie links oben ändern