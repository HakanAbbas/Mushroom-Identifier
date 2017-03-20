package com.firstapp.hakan.cameraapp;

import java.util.List;

/**
 * Created by Hakan on 20.03.2017.
 */

public class Mushroom {
    static {
        System.loadLibrary("opencvlib");
    }
    public native List<String> detectMushroom(String pathToSchwammerlImage);
}
