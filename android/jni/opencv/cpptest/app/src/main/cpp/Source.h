//
// Created by Hakan on 27.03.2017.
//

#ifndef CPPTEST_SOURCE_H
#define CPPTEST_SOURCE_H

#include "Mushroom.h"

int detectAndDisplay(Mat frame); //Maschinelles Lernen; FliegenMushroomerkennung
vector<Mushroom> readxml(std::string path); //Lesen der MushroomXML
void CannyThreshold(int, void*); //Umrisse werden erkannt
vector<Mushroom> oneornull(vector<Mushroom> mushlist2, string question); // 1/0 Entscheidungsfragen
vector <Mushroom> roundornot(vector <Mushroom> mushlist, int amountofcircles); //ist der Mushroom Rund oder nicht?
vector <Mushroom> questions(vector <Mushroom>mushlist); //Ausf�hrliche Entscheidungsfragen
int HoughDetection(const Mat& src_gray, const Mat& src_display, int cannyThreshold, int accumulatorThreshold); //Hough Circle Detection
int myStoi(const string& _Str, size_t *_Idx = 0, int _Base = 10);
vector<Mushroom> detectMushroom(vector<Mushroom> mushlist, cv::Mat image);
Mat readImageFromPath(std::string fullImagePath);

#endif //CPPTEST_SOURCE_H
