package com.mushroom.android.cpptest;


import android.graphics.Bitmap;

/**
 * Schwammerlerkennungs - JNI Bridge
 */

public class MushroomDetector {
    static {
        System.loadLibrary("mushroomlib");
    }
    public native Mushroom[] computeSchwammerlType(Mushroom[] templates, String imagePath);
}
