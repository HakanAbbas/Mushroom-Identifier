#ifndef CPPTEST_MUSHROOM_H
#define CPPTEST_MUSHROOM_H
#include <vector>
#include <opencv2/opencv.hpp>
using namespace std;
using namespace cv;
/**
 * a mushroom to be detected by the app
 */
class Mushroom {
public:
    /** default constructor */
    Mushroom();
    /** copy constructor */
    Mushroom(const Mushroom&);

    /** assignment operator */
    Mushroom& operator=(const Mushroom& other);

    /** BGR color */
    Vec3b color;
    Vec3b hsvV; //HSV Bereich Begin (von)
    Vec3b hsvB; //HSV Bereich Ende (bis)
    Vec3b hsvVS;//HSV Bereich Begin (von) fürr Rott�ne
    Vec3b hsvBS;//HSV Bereich Ende (bis) f�r Rott�ne
    string wiki; //Wikipedia Link
    int lamell;
    string mushRoomName;
    int round; //ist der Pilz Rund, 1 ja, 0 nein
    int poisonous; //ist der Pilz giftig, 1 ja, 0 nein
    int nodule; //= Knolle, Eigenschaftswort (z. B. dicke, rundliche etc.)
    string stalk;
};

#endif //CPPTEST_MUSHROOM_H
