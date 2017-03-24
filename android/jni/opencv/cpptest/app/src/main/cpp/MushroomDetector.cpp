#include <jni.h>
#include <cstring>
#include <iostream>
#include <opencv2/highgui/highgui.hpp>
#include <Source.cpp>

#include "JniUtil.h"
#include "GrayScaler.h"
#include "Mushroom.h"
#include "MushroomDetector.h"

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

    vector<unsigned char> bytes = util.getByteArrayField(obj, "farbe");
    for (int i = 0; i < bytes.size(); i++) {
        mushroom.bgr[i] = bytes[i];
    }
    vector<unsigned  char> byte = util.getByteArrayField(obj, "hsvVon");
    //bytes = util.getByteArrayField(obj, "hsvVon");
    for (int i = 0; i < byte.size(); i++) {
        mushroom.hsv_v[i] = byte[i];
    }
    vector<unsigned char> hsvBis = util.getByteArrayField(obj, "hsvBis");
    for (int i = 0; i < bytes.size(); i++) {
        mushroom.hsv_b[i] = hsvBis[i];
    }
    vector<unsigned char> hsvVonS = util.getByteArrayField(obj, "hsv_v2");
    for (int i = 0; i < bytes.size(); i++) {
        mushroom.hsv_v2[i] = hsvVonS[i];
    }
    vector<unsigned char> hsvBS = util.getByteArrayField(obj, "hsvBS");
    for (int i = 0; i < bytes.size(); i++) {
        mushroom.hsv_b2[i] = hsvBS[i];
    }
    mushroom.name = util.getStringField(obj, "name");
    mushroom.stalk = util.getStringField(obj, "stiel");
    mushroom.wiki = util.getStringField(obj, "wiki");
    mushroom.poisonous = util.getBooleanField(obj, "giftigkeit");
    mushroom.round = util.getBooleanField(obj, "rund");
    mushroom.lamell = util.getBooleanField(obj, "lamellen");
    mushroom.nodule = util.getBooleanField(obj, "knollen");
    return mushroom;
}
jobject MushroomMarshaller::asJavaObject(jclass clazz, const Mushroom& mushroom) {
    JniUtil util(env);

    jmethodID fid = env->GetMethodID(clazz, "<init>", "()V");
    jobject object = env->NewObject(clazz, fid);

    util.setStringField(object, "name", mushroom.name.c_str());
    util.setStringField(object, "stiel", mushroom.stalk.c_str());
    util.setStringField(object, "wiki", mushroom.wiki.c_str());
    util.setBooleanField(object, "giftigkeit", mushroom.poisonous);
    util.setBooleanField(object, "rund", mushroom.round);
    util.setBooleanField(object, "lamellen", mushroom.lamell);
    util.setBooleanField(object, "knollen", mushroom.nodule);

    static const int dims = 3;
    char bytes[dims];
    /*for(int i = 0; i < dims; i++) {
        bytes[i] = mushroom.bgr[i];
    }
    util.setBytearrayField(object, "color", bytes, dims);*/

    return object;
}


extern "C"
JNIEXPORT jobjectArray JNICALL Java_com_example_christianaberger_cpptest_MushroomDetector_computeSchwammerlType
        (JNIEnv *env, jobject mushroomDetector, jobjectArray templates, jstring filePath) {
    JniUtil util(env);
    MushroomMarshaller marshaller(env);

    string path = util.toString(filePath);
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
    // the detected Mushrooms are stored in the detectedShrooms list
    cv:Mat hello;
    vector<Mushroom> detectedShrooms = detectMushroom("somePathtoXML", "somePathToCascadexml", hello);
    jobjectArray objs = env->NewObjectArray(mushrooms.size(), elementClass, NULL);
    jsize index = 0;
    for(vector<Mushroom>::iterator it = detectedShrooms.begin(); it != detectedShrooms.end(); it++) {
        jobject object = marshaller.asJavaObject(elementClass, *it);
        env->SetObjectArrayElement(objs, index++, object);
    }
    return objs;
}