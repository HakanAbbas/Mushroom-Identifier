#include <jni.h>
#include <cstring>
#include <iostream>
#include <opencv2/highgui/highgui.hpp>

#include "JniUtil.h"
#include "GrayScaler.h"
#include "Mushroom.h"
#include "MushroomDetector.h"
#include "Source.h"

using namespace cv;
using namespace std;

/** convert java Mushroom objects to C++ Mushroom objects.
 */
class MushroomMarshaller {
public:
/**
 * @param env the jni environment
 */
    MushroomMarshaller(JNIEnv *env) : env(env) {}
/**
 * for signatures see the constants see the output genterated from javap
 * @param obj the Mushroom java object
 * @return the converted c++ Mushroom object
 */
    Mushroom fromJavaObject(jobject obj);
    jobject asJavaObject(jclass, const Mushroom&);
private:
    JNIEnv *env;
};

/**
 * for signatures see the constants see the output genterated from javap
 * @param env the jni environment
 * @param obj the Mushroom java object
 * @return the converted c++ Mushroom object
 */
Mushroom MushroomMarshaller::fromJavaObject(jobject obj) {
    Mushroom mushroom;
    JniUtil util(env);

    vector<unsigned char> bytes = util.getByteArrayField(obj, "color");
    for (int i = 0; i < bytes.size(); i++) {
        mushroom.bgr[i] = bytes[i];
    }
    vector<unsigned  char> byte = util.getByteArrayField(obj, "hsv_v");
    //bytes = util.getByteArrayField(obj, "hsvVon");
    for (int i = 0; i < byte.size(); i++) {
        mushroom.hsv_v[i] = byte[i];
    }
    vector<unsigned char> hsvBis = util.getByteArrayField(obj, "hsv_b");
    for (int i = 0; i < bytes.size(); i++) {
        mushroom.hsv_b[i] = hsvBis[i];
    }
    vector<unsigned char> hsvVonS = util.getByteArrayField(obj, "hsv_v2");
    for (int i = 0; i < bytes.size(); i++) {
        mushroom.hsv_v2[i] = hsvVonS[i];
    }
    vector<unsigned char> hsvBS = util.getByteArrayField(obj, "hsv_b2");
    for (int i = 0; i < bytes.size(); i++) {
        mushroom.hsv_b2[i] = hsvBS[i];
    }
    mushroom.name = util.getStringField(obj, "name");
    mushroom.stalk = util.getStringField(obj, "stalk");
    mushroom.wiki = util.getStringField(obj, "wiki");
    mushroom.poisonous = util.getBooleanField(obj, "poisonous");
    mushroom.round = util.getBooleanField(obj, "round");
    mushroom.lamell = util.getBooleanField(obj, "lamella");
    mushroom.nodule = util.getBooleanField(obj, "nodule");
    return mushroom;
}
jobject MushroomMarshaller::asJavaObject(jclass clazz, const Mushroom& mushroom) {
    JniUtil util(env);

    jmethodID fid = env->GetMethodID(clazz, "<init>", "()V");
    jobject object = env->NewObject(clazz, fid);

    util.setStringField(object, "name", mushroom.name.c_str());
    util.setStringField(object, "nodule", mushroom.stalk.c_str());
    util.setStringField(object, "wiki", mushroom.wiki.c_str());
    util.setBooleanField(object, "poisonous", mushroom.poisonous);
    util.setBooleanField(object, "round", mushroom.round);
    util.setBooleanField(object, "lamella", mushroom.lamell);
    util.setBooleanField(object, "stalk", mushroom.nodule);

    return object;
}


extern "C"
JNIEXPORT jobjectArray JNICALL Java_com_mushroom_android_cpptest_MushroomDetector_computeSchwammerlType
        (JNIEnv *env, jobject mushroomDetector, jobjectArray templates, jstring imagePath) {
    JniUtil util(env);
    MushroomMarshaller marshaller(env);

    std::string imagePathString = util.toString(imagePath);

    int length = env->GetArrayLength(templates);
    vector<Mushroom> mushrooms;
    jclass elementClass = NULL;
    for (int i = 0; i < length-1; i++) {
        jobject templateElement = env->GetObjectArrayElement(templates, i);
        if (elementClass == NULL) {
            elementClass = env->GetObjectClass(templateElement);
        }
        Mushroom mushroom = marshaller.fromJavaObject(templateElement);
        mushrooms.push_back(mushroom);
    }
    cv::Mat image = readImageFromPath(imagePathString);

    vector<Mushroom> detectedShrooms = detectMushroom(mushrooms, image);

    jobjectArray objs = env->NewObjectArray(mushrooms.size(), elementClass, NULL);
    jsize index = 0;
    for(vector<Mushroom>::iterator it = detectedShrooms.begin(); it != detectedShrooms.end(); it++) {
        jobject object = marshaller.asJavaObject(elementClass, *it);
        env->SetObjectArrayElement(objs, index++, object);
    }
    return objs;
}