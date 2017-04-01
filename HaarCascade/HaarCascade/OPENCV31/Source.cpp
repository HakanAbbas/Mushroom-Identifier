#include "opencv2/objdetect/objdetect.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

#include <iostream>
#include <stdio.h>

using namespace std;
using namespace cv;

/** Function Headers */
void detectAndDisplay(Mat frame, double scaleFactor, int minNeighbours, std::string winName, CascadeClassifier& mushroom_cascade);

/** Global variables */
String mushroom_cascade_name = "..\\data\\mushcascade.xml";
//String mushroom_cascade_name = "..\\data\\newestcascade.xml";

string window_name = "Capture - Mushroom detection";

// windows and trackbars name
const std::string windowName1 = "Fliegenpilz";
const std::string windowName2 = "Nicht-Fliegenpilz";
const std::string scaleFactorTrackbarName = "scaleFactor";
const std::string minNeighboursTrackbarName = "minNeighbours";

// initial and max values of the parameters of interests.
const int scaleFactorInitialValue = 2;
const int minNeighboursInitialValue = 3;
const int maxMinNeighboursThreshold = 150;
const int maxScaleFactorThreshold = 50;

/** @function main */
int main(int argc, const char** argv)
{
	CvCapture* capture;

	Mat frame1;
	Mat frame2;

	frame1 = imread("..\\data\\fliegentest2.jpg");
	frame2 = imread("..\\data\\circles.jpg");
	//frame = imread("..\\data\\Numberguess.jpg");

	//-- 1. Load the cascades
	

	/*
	namedWindow("window", WINDOW_AUTOSIZE);
	imshow("window", frame);*/

	int scaleFactor = scaleFactorInitialValue;
	int minNeighbours = minNeighboursInitialValue;

	// create the main window, and attach the trackbars
	namedWindow("Trackbar", WINDOW_AUTOSIZE);
	createTrackbar(scaleFactorTrackbarName, "Trackbar", &scaleFactor, maxScaleFactorThreshold);
	createTrackbar(minNeighboursTrackbarName, "Trackbar", &minNeighbours, maxMinNeighboursThreshold);

	char key = 0;
	while (key != 'q' && key != 'Q')
	{
		CascadeClassifier mushroom_cascade;
		if (!mushroom_cascade.load(mushroom_cascade_name)) { printf("--(!)Error loading\n"); return -1; };

		//Mat fr1 = frame1.clone();
		//Mat fr2 = frame2.clone();


		int scaleFactor2 = scaleFactor;
		int minNeighbours2 = minNeighbours;

		//scaleFactor = std::max(scaleFactor, 2);
		//minNeighbours = std::max(minNeighbours, 2);

		//runs the detection, and update the display
		detectAndDisplay(frame1.clone(), scaleFactor2, minNeighbours2, windowName1, mushroom_cascade);

		if (!mushroom_cascade.load(mushroom_cascade_name)) { printf("--(!)Error loading\n"); return -1; };

		detectAndDisplay(frame2.clone(), scaleFactor2, minNeighbours2, windowName2, mushroom_cascade);

		// get user key
		key = (char)waitKey(1000);
	}

	waitKey(0);
	return 0;
}

/** @function detectAndDisplay */
void detectAndDisplay(Mat frame, double scaleFactor, int minNeighbours, std::string winName, CascadeClassifier& mushroom_cascade)
{
	std::vector<Rect> mushrooms;
	Mat frame_gray;

	
	cvtColor(frame, frame_gray, CV_BGR2GRAY);
	equalizeHist(frame_gray, frame_gray);
	

	//-- Detect mushrooms
	//1.05
	//3
	mushroom_cascade.detectMultiScale(frame_gray, mushrooms, scaleFactor , minNeighbours, 0 | CV_HAAR_SCALE_IMAGE, Size(30, 30));

	cout << mushrooms.size() << "\n";

	for (size_t i = 0; i < mushrooms.size(); i++)
	{
		Point center(mushrooms[i].x + mushrooms[i].width*0.5, mushrooms[i].y + mushrooms[i].height*0.5);
		ellipse(frame, center, Size(mushrooms[i].width*0.5, mushrooms[i].height*0.5), 0, 0, 360, Scalar(255, 0, 255), 4, 8, 0);

		//Mat faceROI = frame_gray(mushrooms[i]);
		//Mat faceROI = frame(mushrooms[i]);
	}
	//-- Show what you got
	imshow(winName, frame);
	//return frame;
}