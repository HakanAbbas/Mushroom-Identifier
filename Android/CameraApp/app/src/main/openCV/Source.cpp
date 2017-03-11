#include "../../../../../../common/source.cpp"



using namespace cv;
using namespace std;


int main(int argc, char** argv)
{
	vector<Pilz> mushlist=detectMushroom("..\\..\\..\\..\\..\\..\\common\\data\\schwammerl.xml", "..\\..\\..\\..\\..\\..\\common\\data\\mushroom_cascade.xml", imread("..\\..\\..\\..\\..\\..\\common\\data\\Eierschwammerl.jpgerl.jpg"));
	cout<<mushlist.size();

	waitKey(0);
	return 0;
}
