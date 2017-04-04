package com.mushroom.android.cpptest;


/**
 * Schwammerlerkennungs - JNI Bridge
 */

public class MushroomDetector {
    static {
        System.loadLibrary("mushroomlib");
    }
    //Überbrückungsmethode zwischen Java und C++
    //Gibt an, dass diese Methode in C++ geschrieben ist
    public native Mushroom[] computeSchwammerlType(Mushroom[] templates, String imagePath);
}
