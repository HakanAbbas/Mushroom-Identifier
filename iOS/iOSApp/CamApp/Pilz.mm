//
//  Pilz.m
//  CamApp
//
//  Created by mbkair02 on 21.02.17.
//  Copyright © 2017 user. All rights reserved.
//

#import "OpenCVWrapper.h"
#import <opencv2/opencv.hpp>
#import <UIKit/UIKit.h>

//#import "OpenCV.h"

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
//#include <iostream>
#include "opencv2/opencv.hpp"

#include "opencv2/objdetect/objdetect.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

#include <cstdlib>
#include <iostream>
#include <stdio.h>
#include "Markup.h"
//#include <windows.h>
#include <codecvt>
#include <string>
#include <list>

using namespace cv;
using namespace std;

//PILZ KLASSE///////////////////////////////////////////////////////////////////////////////////////////////////
class Pilz { //Pilzklasse
public:
    Vec3b bgr;   //BGR Farbe
    Vec3b hsv_v; //HSV Bereich Begin (von)
    Vec3b hsv_b; //HSV Bereich Ende (bis)
    Vec3b hsv_v2;//HSV Bereich Begin (von) f¸r Rottˆne
    Vec3b hsv_b2;//HSV Bereich Ende (bis) f¸r Rottˆne
    string name; //Name des Pilzes
    string wiki; //Wikipedia Link
    int lamell; //1 f¸r es gibt Lamellen, 0 f¸r es gibt keine Lamellen, Eigenschaftswort f¸r "Hat der pilz ... Lamellen?"
    int roud; //ist der Pilz Rund, 1 ja, 0 nein
    int poisonous; //ist der Pilz giftig, 1 ja, 0 nein
    int nodule; //= Knolle, Eigenschaftswort (z. B. dicke, rundliche etc.)
    string stalk;
};
