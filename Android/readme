Hier wird beschrieben, wie sie die C++ Quelldatei in Android Studio kompilieren können

1. Öffnen sie das Android Studio Projekt
2. Öffnen sie die "Projekte" Ansicht, dies können sie links oben ändern
3. Öffnen sie den "App" Ordner und öffnen die Datei CMakelists.txt
	Finden sie diesen Text: 
	add_library( # Sets the name of the library.
             openlib

             # Sets the library as a shared library.
             SHARED

             # Provides a relative path to your source file(s).
             # Associated headers in the same location as their source
             # file are automatically included.
             src/main/openCV/Source.cpp) <- Die zu kompilierende Datei befindet sich in ihrem src/main/openCV/
4. In der "app" Verzeichnis befindet sich noch eine build.gradle File öffnen sie diese und versicheren sie sich, dass dieser Text drinnen steht
 externalNativeBuild {
        cmake {

            path 'CMakeLists.txt'
        }
    }
Ansonsten wird die CMakeLists.txt nicht ausgeführt, und die C++ Qelldatei nicht kompiliert