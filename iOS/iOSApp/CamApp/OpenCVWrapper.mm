//
//  OpenCVWrapper.m
//  CameraApp
//
//  Created by mbkair02 on 31.10.16.
//  Copyright © 2016 user. All rights reserved.
//

#import "OpenCVWrapper.h"
#import <opencv2/opencv.hpp>
#import <UIKit/UIKit.h>
#import "Pilz.mm"
#import "PilzC.h"

//#import "OpenCV.h"

#include <opencv2/core/core.hpp>
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
//#include <string>
#include <list>

using namespace cv;
using namespace std;

/** Globale Variablen f¸r Maschinelles Lernen*/
String face_cascade_name;
CascadeClassifier face_cascade;
RNG rng(12345);

//globale Variablen f¸r Canny Edge Detector
Mat src, src_gray;
Mat dst, detected_edges;
int edgeThresh = 1;
int lowThreshold=70;
int const max_lowThreshold = 70;
int ratioo = 3;
int kernel_size = 3;
char* window_name = "Canny Edge Detector";


////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/** Function Headers */
int detectAndDisplay(Mat frame); //Maschinelles Lernen; Fliegenpilzerkennung
vector<Pilz> readxml(); //Lesen der PilzXML
void CannyThreshold(int, void*); //Umrisse werden erkannt
vector<Pilz> oneornull(vector<Pilz> mushlist2, wstring question); // 1/0 Entscheidungsfragen
vector <Pilz> roundornot(vector <Pilz> mushlist, int amountofcircles); //ist der Pilz Rund oder nicht?
vector <Pilz> questions(vector <Pilz>mushlist); //Ausf¸hrliche Entscheidungsfragen
int HoughDetection(const Mat& src_gray, const Mat& src_display, int cannyThreshold, int accumulatorThreshold); //Hough Circle Detection


//XML LESEN/////////////////////////////////////////////////////////////////////////////////////////////////////
vector<Pilz> readxml(string xmlpath) {
    Pilz mush;
    vector<Pilz>mushlist;
    CMarkup xml;
    
    cout << "XML PATH: " << xmlpath;
    
    xml.Load(MCD_T(xmlpath)); //XML Datei Laden
    
    int counter = 1;
    std::string counter_str = to_string(counter);
    std::string s("P");
    std::string ws;
    std::string pilz;
    ws.assign(s.begin(), s.end());
    try
    {
        while (xml.FindElem(MCD_T("Schwammerl")))
        {
            xml.IntoElem();
            counter_str = to_string(counter);
            pilz = ws + counter_str;
            cout << "pilz: " << pilz;
            xml.FindElem(pilz);  //z. B. P1, P2, P3, ...
            xml.IntoElem();
            Vec3b bgr;
            
            //Farbe (BGR)
            xml.FindElem(MCD_T("Farbe"));
            mush.bgr[0] = std::stoi(xml.GetAttrib(MCD_T("b")));
            mush.bgr[1] = std::stoi(xml.GetAttrib(MCD_T("g")));
            mush.bgr[2] = std::stoi(xml.GetAttrib(MCD_T("r")));
            
            //Name
            xml.FindElem(MCD_T("Name"));
            mush.name = xml.GetData();
            
            //HSV-von
            xml.FindElem(MCD_T("HSV-von"));
            mush.hsv_v[0] = std::stoi(xml.GetAttrib(MCD_T("h")));
            mush.hsv_v[1] = std::stoi(xml.GetAttrib(MCD_T("s")));
            mush.hsv_v[2] = std::stoi(xml.GetAttrib(MCD_T("v")));
            
            //HSV-bis
            xml.FindElem(MCD_T("HSV-bis"));
            mush.hsv_b[0] = std::stoi(xml.GetAttrib(MCD_T("h")));
            mush.hsv_b[1] = std::stoi(xml.GetAttrib(MCD_T("s")));
            mush.hsv_b[2] = std::stoi(xml.GetAttrib(MCD_T("v")));
            
            //HSV-von2
            xml.FindElem(MCD_T("HSV-von2"));
            mush.hsv_v2[0] = std::stoi(xml.GetAttrib(MCD_T("h")));
            mush.hsv_v2[1] = std::stoi(xml.GetAttrib(MCD_T("s")));
            mush.hsv_v2[2] = std::stoi(xml.GetAttrib(MCD_T("v")));
            
            //HSV-bis2
            xml.FindElem(MCD_T("HSV-bis2"));
            mush.hsv_b2[0] = std::stoi(xml.GetAttrib(MCD_T("h")));
            mush.hsv_b2[1] = std::stoi(xml.GetAttrib(MCD_T("s")));
            mush.hsv_b2[2] = std::stoi(xml.GetAttrib(MCD_T("v")));
            
            //Wiki
            xml.FindElem(MCD_T("Wiki"));
            mush.wiki = xml.GetData();
            
            //Giftigkeit
            xml.FindElem(MCD_T("Giftigkeit"));
            mush.poisonous = std::stoi(xml.GetData());
            
            //Rund
            xml.FindElem(MCD_T("Rund"));
            mush.roud = std::stoi(xml.GetData());
            
            //Lamellen
            xml.FindElem(MCD_T("Lamellen"));
            mush.lamell = std::stoi(xml.GetData());
            
            //Knolle
            xml.FindElem(MCD_T("Knolle"));
            mush.nodule = std::stoi(xml.GetData());
            
            xml.FindElem(MCD_T("Stiel"));
            mush.stalk = xml.GetData();
            
            mushlist.push_back(mush);
            
            counter++;
            xml.ResetPos();
        }
    }
    catch (const std::exception)
    {
        return mushlist;
    }
    return mushlist;
}


//OpenCVWrapper.h File Implementierung
@implementation OpenCVWrapper

+(NSMutableArray<PilzC *> *) DetectByColor:(UIImage*) img : (NSString*) xmlpath1 : (NSString*) xmlpath2
{
    std::string xmlpathh1 = std::string([xmlpath1 UTF8String]);
    std::string xmlpathh2 = std::string([xmlpath2 UTF8String]);
    
    vector<Pilz>mushlist = readxml(string(xmlpathh1)); //Liste aller gelesenen Pilze
    vector<Pilz>mushlist2;
    vector<Pilz>mushlist3;
    
    Vec3b eier_c;  //Eierschwammerl Farbe
    Vec3b stein_c; //Steinpilz Farbe
    Vec3b flig_c;  //Fliegenpilz Farbe
    int schw = 30; //Schwelle
    Vec3b eier_c_hsv;
    int array2[3];
    array2[0] = 0;
    array2[1] = 0;
    array2[2] = 0;
    int rows_mid;
    int cols_mid;
    Vec3b pix;
    cv::Mat hsv_first;
    cv::Mat hsvhelp;
    
    /*if (argc != 2)
     {
     cout << " Usage: display_image ImageToLoadAndDisplay" << endl;
     //return @"Usage: display_image ImageToLoadAndDisplay";
     }*/
    //Mat image;
    Mat image_gray;
    Mat image = convertToMat(img);
    //image = imread("/Users/mbkair02/Downloads/OPENCV31/data/eiersch.jpg");    //Eierschwammerl
    //image = imread("C:\\Users\\Jakob\\Documents\\Visual Studio 2015\\Projects\\OPENCV31\\data\\steinpilz.jpg");  //Steinpilz
    //image = imread("C:\\Users\\Jakob\\Documents\\Visual Studio 2015\\Projects\\OPENCV31\\data\\steinpilz2.jpg");  //Steinpilz2
    //image = imread("/Users/mbkair02/Downloads/OPENCV31/data/fliegen.JPG");	   //Fliegenpilz
    //image = imread("C:\\Users\\Jakob\\Documents\\Visual Studio 2015\\Projects\\OPENCV31\\data\\circles.jpg");
    //image = imread("C:\\Users\\Jakob\\Documents\\Visual Studio 2015\\Projects\\OPENCV31\\data\\fliegen_oben.jpg");	   //Fliegenpilz
    
    
    //*******************************************************************************************************************
    //*******************************************************************************************************************
    
    
    
    //*******************************************************************************************************************
    //*******************************************************************************************************************
    
    
    
    
    src = image;
    if (!image.data)                              // konnte gelesen werden?
    {
        cout << "Bild konnte nicht gelesen werden" << std::endl;
        //return @"Bild konnte nicht gelesen werden";
    }
    
    cv::cvtColor(image, image, cv::COLOR_RGB2BGR);
    
    //*******************************************************************************************************************
    //*******************************************************************************************************************
    
    
    //return convertToUIImage(image);
    
    
    //*******************************************************************************************************************
    //*******************************************************************************************************************
    
    
    
    //namedWindow("Pilz_ohne_Aenderung", WINDOW_AUTOSIZE);    // Fenster zum anzeigen erstellen
    //imshow("Pilz_ohne_Aenderung", image);                   // Foto darin darstellen
    
    //Mitte des Bildes herausfinden
    rows_mid = image.rows / 2;
    cols_mid = image.cols / 2;
    
    double pixels = 0;
    
    if(rows_mid > cols_mid) pixels = cols_mid / 1.5;
    else pixels = rows_mid / 1.5;
    
    int range = sqrt(pixels) / 2 + 1;
    pixels = range * range * 4;
    
    //Mehrere (100) Pixel in der Mitte durchsuchen
    for (int i = -1 * (range); i < range; i++) {
        for (int j = -1 * (range); j < range; j++) {
            array2[0] += image.at<Vec3b>(rows_mid + i, cols_mid + j)[0];
            array2[1] += image.at<Vec3b>(rows_mid + i, cols_mid + j)[1];
            array2[2] += image.at<Vec3b>(rows_mid + i, cols_mid + j)[2];
            //cout << "yey" << array2[0];
        }
    }
    
    cout << " rows: " << rows_mid;
    cout << " cols: " << cols_mid;
    
    cout << " pixels: " << pixels;
    cout << " range: " << range;
    
    //Durchschnittswert der Pixelfarben errechnen
    pix[0] = array2[0] / pixels;
    pix[1] = array2[1] / pixels;
    pix[2] = array2[2] / pixels;
    
    cout << "bgr: " << pix;
    
    cv::Mat hsv_image;
    
    //umwandlung von BGR in HSV
    cv::cvtColor(image, hsv_image, cv::COLOR_BGR2HSV);
    
    //Errechnen, ob der Pilz ein Eierschwammerl sein kˆnnte (Farbe)
    
    NSString *ret = @"abc";
    
    for (int i=0; i<mushlist.size(); i++)
    {
        if (pix[0]<mushlist[i].bgr[0] + schw && pix[0]>mushlist[i].bgr[0] - schw && pix[1]<mushlist[i].bgr[1] + schw && pix[1]>mushlist[i].bgr[1] - schw && pix[2]<mushlist[i].bgr[2] + schw && pix[2]>mushlist[i].bgr[2] - schw) {
            mushlist2.push_back(mushlist[i]);
            //ret = [NSString stringWithUTF8String:mushlist[i].name.c_str()];
            inRange(hsv_image, Scalar(mushlist[i].hsv_v[0], mushlist[i].hsv_v[1], mushlist[i].hsv_v[2]), Scalar(mushlist[i].hsv_b[0], mushlist[i].hsv_b[1], mushlist[i].hsv_b[2]), hsv_first);
            inRange(hsv_image, Scalar(mushlist[i].hsv_v2[0], mushlist[i].hsv_v2[1], mushlist[i].hsv_v2[2]), Scalar(mushlist[i].hsv_b2[0], mushlist[i].hsv_b2[1], mushlist[i].hsv_b2[2]), hsvhelp);
            cv::addWeighted(hsv_first, 1.0, hsvhelp, 1.0, 0.0, hsv_first);
            //fastNlMeansDenoising(hsv_first, hsv_first, 50, 21, 21);
        }
    }
    if(mushlist2.size() == 0){
        return [[NSMutableArray<PilzC *> alloc] init];
    }
    
    cvtColor(image, image_gray, CV_BGR2GRAY);
    
    
    
    cv::Mat hsv_secund, hsv_third;
    cv::addWeighted(hsv_first, 1.0, hsv_first, 1.0, 0.0, hsv_secund);
    cv::GaussianBlur(hsv_secund, hsv_third, cv::Size(9, 9), 0, 0);
    src = hsv_secund;
    src_gray = hsv_secund;
    
    
    // Gasusscher Weichzeichner
    GaussianBlur(src_gray, src_gray, cv::Size(9, 9), 2, 2);
    
    
    int amountofcircles=HoughDetection(src_gray, src_gray, 99, 41);
    cout << "\nAnzahl der Kreise: " << amountofcircles;
    int fliegennull = 0;
    
    //Hier sage ich: wenn ein Pilz von der Farbe her ein Fliegenpilz sein kˆnnte und noch mehrere Kreise erkannt werden, dann ist es verdammt nochmal ein Fliegenpilz, danke aus.
    for (int i = 0; i < mushlist2.size(); i++) {
        string fliegen;
        fliegen = ("Fliegenpilz");
        if (mushlist2[i].name.compare(fliegen) == 0) {
            CvCapture *capture;
            Mat frame;
            
            frame = image;
            
            //-- 1. Load the cascades
            if (!face_cascade.load(xmlpathh2)) {
                printf("--(!)Error loading\n");
            }
            
            if (detectAndDisplay(frame) > 0) {
                mushlist3.push_back(mushlist2[i]);
                fliegennull = 1;
                cout << "ich bin hier...Fliegenpilz";
                mushlist2 = mushlist3;
            }
            
        }
    }
    
    if (mushlist2.size() > 1) {
        mushlist2 = roundornot(mushlist2, amountofcircles);
    }
    
    //ret = [NSString stringWithFormat:@"%lu", mushlist2.size()];
    
    NSMutableArray<PilzC *> *arr = [[NSMutableArray alloc] init];
    //PilzC *c = [[PilzC alloc]init];;
    //PilzC box1 = [[PilzC alloc]init];
    PilzC *c = [[PilzC alloc] init];
    
    for(int i = 0; i < mushlist2.size(); i++){
        c.name = [NSString stringWithUTF8String:mushlist2[i].name.c_str()];
        c.wiki = [NSString stringWithUTF8String:mushlist2[i].wiki.c_str()];
        c.stiel = [NSString stringWithUTF8String:mushlist2[i].stalk.c_str()];
        c.lamellen = mushlist2[i].lamell;
        c.knolle = mushlist2[i].nodule;
        c.giftigkeitt = mushlist2[i].poisonous;
        c.rund = mushlist2[i].roud;
        
        cout << c.name;
        
        [arr addObject: c];
        
        c = [[PilzC alloc] init];
    }
    
    
    //return convertToUIImage(image);
    return arr;
    
}

+(NSMutableArray<PilzC *> *) allMushs: (NSString*) xmlpath{
    std::string xmlpathh = std::string([xmlpath UTF8String]);
    
    vector<Pilz>mushlist = readxml(string(xmlpathh)); //Liste aller gelesenen Pilze
    
    NSMutableArray<PilzC *> *arr = [[NSMutableArray alloc] init];
    //PilzC *c = [[PilzC alloc]init];;
    //PilzC box1 = [[PilzC alloc]init];
    PilzC *c = [[PilzC alloc] init];
    
    for(int i = 0; i < mushlist.size(); i++){
        c.name = [NSString stringWithUTF8String:mushlist[i].name.c_str()];
        c.wiki = [NSString stringWithUTF8String:mushlist[i].wiki.c_str()];
        c.stiel = [NSString stringWithUTF8String:mushlist[i].stalk.c_str()];
        c.lamellen = mushlist[i].lamell;
        c.knolle = mushlist[i].nodule;
        c.giftigkeitt = mushlist[i].poisonous;
        c.rund = mushlist[i].roud;
        
        cout << c.name;
        
        [arr addObject: c];
        
        c = [[PilzC alloc] init];
    }
    
    return arr;
}


/** @function detectAndDisplay */
int detectAndDisplay(Mat frame) //Markus¥ Maschinelles Lernen Algorithmus
{
    std::vector<cv::Rect> faces;
    Mat frame_gray;
    
    cvtColor(frame, frame_gray, CV_BGR2GRAY);
    equalizeHist(frame_gray, frame_gray);
    
    //-- Detect faces
    face_cascade.detectMultiScale(frame_gray, faces, 1.1, 2, 0 | CV_HAAR_SCALE_IMAGE, cv::Size(30, 30));
    
    for (size_t i = 0; i < faces.size(); i++)
    {
        cv::Point center(faces[i].x + faces[i].width*0.5, faces[i].y + faces[i].height*0.5);
        ellipse(frame, center, cv::Size(faces[i].width*0.5, faces[i].height*0.5), 0, 0, 360, Scalar(255, 0, 255), 4, 8, 0);
        
        Mat faceROI = frame_gray(faces[i]);
    }
    
    return faces.size();
}

//Canny Algorithmus/////////////////////////////////////////////////////////////////////////////////////////////
void CannyThreshold(int, void*)
{
    /// Reduce noise with a kernel 3x3
    blur(src_gray, detected_edges, cv::Size(3, 3));
    
    /// Canny detector
    Canny(detected_edges, detected_edges, lowThreshold, lowThreshold*ratioo, kernel_size);
    
    /// Using Canny's output as a mask, we display our result
    dst = Scalar::all(0);
    
    src.copyTo(dst, detected_edges);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int counter = 0;
vector<Pilz> oneornull(vector<Pilz> mushlist2, string question) {
    cout << "\n\n\nHat Ihr Pilz" << question << "? 0=NEIN, 1=JA\n";
    int dessicion; //hier bitte Ergebniss speichern
    cin >> dessicion;
    std::ostringstream ws;
    ws << dessicion;
    const std::string dessicion_str(ws.str());
    vector<Pilz> mushlist3;
    
    stringstream ss;
    if (counter == 0) {
        for (int i = 0; i < mushlist2.size(); i++) {
            ss << mushlist2[i].lamell;
            if (ss.str() == dessicion_str) {
                mushlist3.push_back(mushlist2[i]);
                cout << mushlist2[i].name << "\n";
            }
        }
        counter++;
    }
    else {
        for (int i = 0; i < mushlist2.size(); i++) {
            ss << mushlist2[i].nodule;
            if (ss.str() == dessicion_str) {
                mushlist3.push_back(mushlist2[i]);
                cout << mushlist2[i].name << "\n";
            }
        }
        
    }
    
    return mushlist3;
}

vector <Pilz> roundornot(vector <Pilz> mushlist, int amountofcircles) {
    vector<Pilz> mushlist2;
    for (int i = 0; i < mushlist.size(); i++) {
        if (amountofcircles >= mushlist[i].roud) {
            mushlist2.push_back(mushlist[i]);
        }
    }
    return mushlist2;
}

vector <Pilz> questions(vector <Pilz>mushlist) {
    vector<Pilz> mushlist2;
    
    int dessicion; //hier bitte Ergebniss speichern
    
    for (int i = 0; i < mushlist.size() && counter != -1; i++) {
        cout << "\n\n\nHat Ihr Pilz " << mushlist[i].stalk << "? 0=NEIN, 1=JA\n";
        cin >> dessicion;
        std::wostringstream ws;
        ws << dessicion;
        const std::wstring dessicion_wstr(ws.str());
        if (dessicion == 1) {
            mushlist2.push_back(mushlist[i]);
            counter = -1;
        }
    }
    for (int i = 0; i < mushlist2.size(); i++) {
        cout << mushlist2[i].name;
    }
    return mushlist2;
}





// windows and trackbars name
const std::string windowName = "Hough Circle Detection Demo";
const std::string cannyThresholdTrackbarName = "Canny threshold";
const std::string accumulatorThresholdTrackbarName = "Accumulator Threshold";

// initial and max values of the parameters of interests.
const int cannyThresholdInitialValue = 200;
const int accumulatorThresholdInitialValue = 50;
const int maxAccumulatorThreshold = 200;
const int maxCannyThreshold = 255;

int HoughDetection(const Mat& src_gray, const Mat& src_display, int cannyThreshold, int accumulatorThreshold)
{
    // will hold the results of the detection
    std::vector<Vec3f> circles;
    // runs the actual detection
    HoughCircles(src_gray, circles, CV_HOUGH_GRADIENT, 1, src_gray.rows / 8, cannyThreshold, accumulatorThreshold, 0, 0);
    
    // clone the colour, input image for displaying purposes
    Mat display = src_display.clone();
    for (size_t i = 0; i < circles.size(); i++)
    {
        cv::Point center(cvRound(circles[i][0]), cvRound(circles[i][1]));
        int radius = cvRound(circles[i][2]);
        // circle center
        circle(display, center, 3, Scalar(0, 255, 0), -1, 8, 0);
        // circle outline
        circle(display, center, radius, Scalar(0, 0, 255), 3, 8, 0);
    }
    
    
    return (circles.size());
}


Mat convertToMat(UIImage* img)
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(img.CGImage);
    CGFloat cols = img.size.width;
    CGFloat rows = img.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), img.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

UIImage* convertToUIImage(Mat image)
{
    NSData *data = [NSData dataWithBytes:image.data length:image.elemSize()*image.total()];
    
    CGColorSpaceRef colorSpace;
    
    if (image.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(image.cols,                                 //width
                                        image.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * image.elemSize(),                       //bits per pixel
                                        image.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}


@end
















