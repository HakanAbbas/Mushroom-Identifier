#include <opencv2/opencv.hpp>
//#include "data/Markup.h"
#include "Mushroom.h"
#include <opencv2/objdetect/objdetect.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include "Source.h"

using namespace cv;
using namespace std;

//Mushroom KLASSE///////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/** Function Headers */

																							/** Globale Variablen f�r Maschinelles Lernen*/
static String face_cascade_name = "..\\data\\mushroom_cascade.xml";
static CascadeClassifier face_cascade;
static RNG rng(12345);

//globale Variablen f�r Canny Edge Detector
static Mat src, src_gray;
static Mat dst, detected_edges;
static int edgeThresh = 1;
static int lowThreshold = 70;
static int const max_lowThreshold = 70;
static int ratioo = 3;
static int kernel_size = 3;

Mat readImageFromPath(string fullImagePath){
   cv::Mat image = imread(fullImagePath);
    return image;
}

vector<Mushroom> detectMushroom(vector<Mushroom> mushlist, cv::Mat image)
{
	Mat image_gray;

    cout << "rows: " << image.rows;
    cout << "cols: " << image.cols;

	vector<Mushroom>mushlist2;
	vector<Mushroom>mushlist3;

	Vec3b eier_c;  //Eierschwammerl Farbe
	Vec3b stein_c; //SteinMushroom Farbe 
	Vec3b flig_c;  //FliegenMushroom Farbe
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


	
	src = image;

	//Mitte des Bildes herausfinden
	rows_mid = image.rows / 2;
	cols_mid = image.cols / 2;

	//Mehrere (100) Pixel in der Mitte durchsuchen
	double pixels = 0;

	if (rows_mid > cols_mid) pixels = cols_mid / 1.5;
	else pixels = rows_mid / 1.5;

	int range = sqrt(pixels) / 2 + 1;
	pixels = range * range * 4;

	for (int i = -1 * (range); i < range; i++) {
		for (int j = -1 * (range); j < range; j++) {
			array2[0] += image.at<Vec3b>(rows_mid +i, cols_mid + j)[0];
			array2[1] += image.at<Vec3b>(rows_mid + i, cols_mid + j)[1];
			array2[2] += image.at<Vec3b>(rows_mid + i, cols_mid + j)[2];
			//cout � "yey" � array2[0];
		}
	}


	cout << " rows: " << rows_mid;
	cout << " cols: " << cols_mid;

	//Durchschnittswert der Pixelfarben errechnen
	pix[0] = array2[0] / pixels;
	pix[1] = array2[1] / pixels;
	pix[2] = array2[2] / pixels;

	cout << "bgr: " << pix;

	cv::Mat hsv_image;

	//umwandlung von BGR in HSV
	cv::cvtColor(image, hsv_image, cv::COLOR_BGR2HSV);
cout << "read" << mushlist2.size() << "read";
	//Errechnen, ob der Mushroom von der Farbe her mit einem oder mehrerem aus dem xml-File �bereinstimmt
	for (int i = 0; i<mushlist.size(); i++)
	{

		if (pix[0]<mushlist[i].bgr[0] + schw && pix[0]>mushlist[i].bgr[0] - schw && pix[1]<mushlist[i].bgr[1] + schw && pix[1]>mushlist[i].bgr[1] - schw && pix[2]<mushlist[i].bgr[2] + schw && pix[2]>mushlist[i].bgr[2] - schw) {
			mushlist2.push_back(mushlist[i]);
			cout << "\n\nSchwammerlname: " << mushlist[i].name;
			inRange(hsv_image, Scalar(mushlist[i].hsv_v[0], mushlist[i].hsv_v[1], mushlist[i].hsv_v[2]), Scalar(mushlist[i].hsv_b[0], mushlist[i].hsv_b[1], mushlist[i].hsv_b[2]), hsv_first);
			inRange(hsv_image, Scalar(mushlist[i].hsv_v2[0], mushlist[i].hsv_v2[1], mushlist[i].hsv_v2[2]), Scalar(mushlist[i].hsv_b2[0], mushlist[i].hsv_b2[1], mushlist[i].hsv_b2[2]), hsvhelp);
			cv::addWeighted(hsv_first, 1.0, hsvhelp, 1.0, 0.0, hsv_first);

		}
	}cout << "read" << mushlist2.size() << "read";
	if (mushlist2.size() == 0) {
		return mushlist2;
	}

	cvtColor(image, image_gray, CV_BGR2GRAY);



	cv::Mat hsv_secund, hsv_third;
	cv::addWeighted(hsv_first, 1.0, hsv_first, 1.0, 0.0, hsv_secund);
	cv::GaussianBlur(hsv_secund, hsv_third, cv::Size(9, 9), 0, 0);
	src = hsv_secund;
	src_gray = hsv_secund;


	// Gasusscher Weichzeichner
    GaussianBlur(src_gray, src_gray, cv::Size(9, 9), 2, 2);






	int amountofcircles = HoughDetection(src_gray, src_gray, 99, 41);
	cout << "\nAnzahl der Kreise: " << amountofcircles;
	int fliegennull = 0;

	//Hier sage ich: wenn ein Mushroom von der Farbe her ein FliegenMushroom sein k�nnte und noch mehrere Kreise erkannt werden, dann ist es verdammt nochmal ein FliegenMushroom, danke aus.
	for (int i = 0; i < mushlist2.size(); i++) {
		string fliegen;
		fliegen = ("FliegenMushroom");
		if (mushlist2[i].name.compare(fliegen) == 0) {
			CvCapture* capture;
			Mat frame;

			frame = image;

			//-- 1. Load the cascades
			if (!face_cascade.load(face_cascade_name)) { printf("--(!)Error loading\n"); 
			};

			if (detectAndDisplay(frame) > 0) {
				mushlist3.push_back(mushlist2[i]);
				fliegennull = 1;
				cout << "ich bin hier...FliegenMushroom";
				mushlist2 = mushlist3;
			}

		}
	}


	//Schwarz Wei� Bin�res Bild
	cv::Mat grayscaleMat(image.size(), CV_8U);
	cv::cvtColor(image, grayscaleMat, CV_BGR2GRAY);
	cv::Mat binaryMat(grayscaleMat.size(), grayscaleMat.type());
	cv::threshold(grayscaleMat, binaryMat, 100, 255, cv::THRESH_BINARY);

	return mushlist2;
}

/** @function detectAndDisplay */
int detectAndDisplay(Mat frame) //Markus�ss Maschinelles Lernen Algorithmus 
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

        cv::Mat faceROI = frame_gray(faces[i]);
	}

	return faces.size();
}


//XML LESEN/////////////////////////////////////////////////////////////////////////////////////////////////////
/*vector<Mushroom> readxml(std::string path) {
	Mushroom mush;
	vector<Mushroom>mushlist;
	CMarkup xml;
	xml.Load(path); //XML Datei Laden

	std:stringstream help;

	int counter = 1;
	help << counter;
	std::string counter_str;
	counter_str = help.str();
	help.str(std::string());

	std::string s("P");
	std::string ws;
	std::string Mushroom;
	ws.assign(s.begin(), s.end());
	try
	{
		while (xml.FindElem(MCD_T("Mushroom")))
		{
			xml.IntoElem();
			help << counter;
			counter_str = help.str();
			help.str(std::string());
			Mushroom = ws + counter_str;
			//cout << "Mushroom: " << Mushroom;
			xml.FindElem(Mushroom);  //z. B. P1, P2, P3, ...
			xml.IntoElem();
			Vec3b bgr;

			//Farbe (BGR)
			xml.FindElem(MCD_T("Farbe"));
			mush.bgr[0] = stoi(xml.GetAttrib(MCD_T("b")).c_str());
			mush.bgr[1] = stoi(xml.GetAttrib(MCD_T("g")).c_str());
			mush.bgr[2] = stoi(xml.GetAttrib(MCD_T("r")).c_str());

			//Name
			xml.FindElem(MCD_T("Name"));
			mush.name = xml.GetData();

			//HSV-von
			xml.FindElem(MCD_T("HSV-von"));
			mush.hsv_v[0] = stoi(xml.GetAttrib(MCD_T("h")).c_str());
			mush.hsv_v[1] = stoi(xml.GetAttrib(MCD_T("s")).c_str());
			mush.hsv_v[2] = stoi(xml.GetAttrib(MCD_T("v")).c_str());
			//HSV-bis
			xml.FindElem(MCD_T("HSV-bis"));
			mush.hsv_b[0] = stoi(xml.GetAttrib(MCD_T("h")).c_str());
			mush.hsv_b[1] = stoi(xml.GetAttrib(MCD_T("s")).c_str());
			mush.hsv_b[2] = stoi(xml.GetAttrib(MCD_T("v")).c_str());

			//HSV-von2
			xml.FindElem(MCD_T("HSV-von2"));
			mush.hsv_v2[0] = stoi(xml.GetAttrib(MCD_T("h")).c_str());
			mush.hsv_v2[1] = stoi(xml.GetAttrib(MCD_T("s")).c_str());
			mush.hsv_v2[2] = stoi(xml.GetAttrib(MCD_T("v")).c_str());

			//HSV-bis2
			xml.FindElem(MCD_T("HSV-bis2"));
			mush.hsv_b2[0] = stoi(xml.GetAttrib(MCD_T("h")).c_str());
			mush.hsv_b2[1] = stoi(xml.GetAttrib(MCD_T("s")).c_str());
			mush.hsv_b2[2] = stoi(xml.GetAttrib(MCD_T("v")).c_str());
			//Wiki
			xml.FindElem(MCD_T("Wiki"));
			mush.wiki = xml.GetData();

			//Giftigkeit
			xml.FindElem(MCD_T("Giftigkeit"));
			mush.poisonous = stoi(xml.GetData().c_str());

			//Rund
			xml.FindElem(MCD_T("Rund"));
			mush.round = stoi(xml.GetData().c_str());

			//Lamellen
			//Knolle
			xml.FindElem(MCD_T("Lamellen"));
			mush.lamell = stoi(xml.GetData().c_str());

			xml.FindElem(MCD_T("Knolle"));
			mush.nodule = stoi(xml.GetData().c_str());

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
}*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//String in Integer konvertieren
int myStoi(const string& _Str, size_t *_Idx,
	int _Base)
{	// convert string to int
	const char *_Ptr = _Str.c_str();
	char *_Eptr;
	long _Ans = strtol(_Ptr, &_Eptr, _Base);

	if (_Idx != 0)
		*_Idx = (size_t)(_Eptr - _Ptr);
	return ((int)_Ans);
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
/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////
int counter = 0;
vector<Mushroom> oneornull(vector<Mushroom> mushlist2, string question) {
	cout << "\n\n\nHat Ihr Mushroom" << question << "? 0=NEIN, 1=JA\n";
	int dessicion; //hier bitte Ergebniss speichern
	cin >> dessicion;
	std::ostringstream ws;
	ws << dessicion;
	const std::string dessicion_wstr(ws.str());
	vector<Mushroom> mushlist3;
	if (counter == 0) {
		for (int i = 0; i < mushlist2.size(); i++) {

			if (mushlist2[i].lamell == dessicion_wstr) {
				mushlist3.push_back(mushlist2[i]);
				cout << mushlist2[i].name << "\n";
			}
		}
		counter++;
	}
	else {
		for (int i = 0; i < mushlist2.size(); i++) {

			if (mushlist2[i].nodule == dessicion_wstr) {
				mushlist3.push_back(mushlist2[i]);
				cout << mushlist2[i].name << "\n";
			}
		}

	}

	return mushlist3;
}

vector <Mushroom> roundornot(vector <Mushroom> mushlist, int amountofcircles) {
	vector<Mushroom> mushlist2;
	for (int i = 0; i < mushlist.size(); i++) {
		if (amountofcircles >= mushlist[i].roud) {
			mushlist2.push_back(mushlist[i]);
		}
	}
	return mushlist2;
}

vector <Mushroom> questions(vector <Mushroom>mushlist) {
	vector<Mushroom> mushlist2;

	int dessicion; //hier bitte Ergebniss speichern

	for (int i = 0; i < mushlist.size() && counter != -1; i++) {
		cout << "\n\n\nHat Ihr Mushroom " << mushlist[i].stalk << "? 0=NEIN, 1=JA\n";
		cin >> dessicion;
		std::ostringstream ws;
		ws << dessicion;
		const std::string dessicion_wstr(ws.str());
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

*/


/*
// windows and trackbars name
const std::string windowName = "Hough Circle Detection Demo";
const std::string cannyThresholdTrackbarName = "Canny threshold";
const std::string accumulatorThresholdTrackbarName = "Accumulator Threshold";
*/
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

	// shows the results

	return (circles.size());
}



//https://solarianprogrammer.com/2015/05/08/detect-red-circles-image-using-opencv/

//http://www.firstobject.com/fast-start-to-xml-in-c++.htm

//Canny Edge Detector


//Expertensystem, Engtscheidungsbaum
