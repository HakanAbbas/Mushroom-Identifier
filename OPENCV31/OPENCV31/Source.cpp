#include "opencv2/opencv.hpp"
#include "Markup.h"
#include "opencv2/objdetect/objdetect.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "../../common/source.cpp"

using namespace cv;
using namespace std;
//PILZ KLASSE///////////////////////////////////////////////////////////////////////////////////////////////////




int main(int argc, char** argv)
{
	vector<Pilz> mushlist=detectMushroom("..\\..\\common\\data\\schwammerl.xml", "..\\..\\common\\data\\mushroom_cascade.xml", imread("..\\..\\common\\data\\fliegen_oben.jpg"));
	cout << "\n\n" << mushlist.size();

	waitKey(0);
	return 0;
}





////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int counter = 0;
/**
vector<Pilz> oneornull(vector<Pilz> mushlist2, wstring question) {
	wcout << "\n\n\nHat Ihr Pilz" << question << "? 0=NEIN, 1=JA\n";
	int dessicion; //hier bitte Ergebniss speichern
	//cin >> dessicion;
	std::wostringstream ws;
	ws << dessicion;
	const std::wstring dessicion_wstr(ws.str());
	vector<Pilz> mushlist3;
	if (counter == 0) {
		for (int i = 0; i < mushlist2.size(); i++) {

			//if (mushlist2[i].lamell == dessicion_wstr) {
				mushlist3.push_back(mushlist2[i]);
				//wcout << mushlist2[i].name << "\n";
			}
		}
		counter++;
	}
	//else {
		for (int i = 0; i < mushlist2.size(); i++) {

			//if (mushlist2[i].nodule == dessicion_wstr) {
				mushlist3.push_back(mushlist2[i]);
				//wcout << mushlist2[i].name << "\n";
			}
		}

	}

	return mushlist3;
//}




vector <Pilz> questions(vector <Pilz>mushlist) {
	vector<Pilz> mushlist2;

	int dessicion; //hier bitte Ergebniss speichern

	for (int i = 0; i < mushlist.size() && counter != -1; i++) {
		//wcout << "\n\n\nHat Ihr Pilz " << mushlist[i].stalk << "? 0=NEIN, 1=JA\n";
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
		//wcout << mushlist2[i].name;
	}
	return mushlist2;
}

**/



// windows and trackbars name
const std::string windowName = "Hough Circle Detection Demo";
const std::string cannyThresholdTrackbarName = "Canny threshold";
const std::string accumulatorThresholdTrackbarName = "Accumulator Threshold";





//https://solarianprogrammer.com/2015/05/08/detect-red-circles-image-using-opencv/

//http://www.firstobject.com/fast-start-to-xml-in-c++.htm

//Canny Edge Detector


//Expertensystem, Engtscheidungsbaum