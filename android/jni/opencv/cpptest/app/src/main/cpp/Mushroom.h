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
    Vec3b bgr;
    Vec3b hsv_v; //HSV Bereich Begin (von)
    Vec3b hsv_b; //HSV Bereich Ende (bis)
    Vec3b hsv_v2;//HSV Bereich Begin (von) fürr Rott�ne
    Vec3b hsv_b2;//HSV Bereich Ende (bis) f�r Rott�ne
    string name;
    string wiki; //Wikipedia Link
    int lamell;
    int round; //ist der Mushroom Rund, 1 ja, 0 nein
    int poisonous; //ist der Mushroom giftig, 1 ja, 0 nein
    int nodule; //= Knolle, Eigenschaftswort (z. B. dicke, rundliche etc.)
    string stalk;
};

#endif //CPPTEST_MUSHROOM_H
