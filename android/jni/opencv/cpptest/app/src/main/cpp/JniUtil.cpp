//
// Created by Hakan Abbas on 23.03.2017.
//
#import "JniUtil.h"
using namespace std;

string JniUtil::toString(jstring jniString) {
    const char *nativeString = env->GetStringUTFChars(jniString, 0);
    string cvString = nativeString;
    env->ReleaseStringUTFChars(jniString, nativeString);
    return cvString;
}
//Umwandlung von Arrays in Vecotren
vector<unsigned char> JniUtil::getByteArrayField(jobject obj, const char *name) {
    jclass klass = env->GetObjectClass(obj);
    jfieldID fid = env->GetFieldID(klass, name, "[B");

    jobject colorObject = env->GetObjectField(obj, fid);
    jbyteArray& byteArray = reinterpret_cast<jbyteArray&>(colorObject);
    int length = env->GetArrayLength(byteArray);
    jbyte *color = env->GetByteArrayElements(byteArray, NULL);
    vector<unsigned char> bytes;
    for (int i = 0; i < length; i++) {
        bytes.push_back(color[i]);
    }
    env->ReleaseByteArrayElements(byteArray, color, 0);
    return bytes;
}

//Umwandlung von Java String in C++ String
string JniUtil::getStringField(jobject obj, const char *name) {
    jclass klass = env->GetObjectClass(obj);
    jfieldID fid = env->GetFieldID(klass, name, "Ljava/lang/String;");
    jstring stringObject = (jstring)env->GetObjectField(obj, fid);
    return stringObject ? toString(stringObject) : "";
}
//Umwandlung von C++ String in Java String
void JniUtil::setStringField(jobject object, const char *name, const char *value) {
    jclass klass = env->GetObjectClass(object);
    jfieldID fieldId = env->GetFieldID(klass, name, "Ljava/lang/String;");
    jstring val = env->NewStringUTF(value);
    env->SetObjectField(object, fieldId, val);
}

//Umwandlung von Java boolean in C++ Integer
int JniUtil::getBooleanField(jobject object, const char *name) {
    jclass klass = env->GetObjectClass(object);
    jfieldID fid = env->GetFieldID(klass, name, "Z");
    jboolean val = env->GetBooleanField(object, fid);
    if(val){
        return 1;
    } else{
        return 0;
    }
}


//Umwandlung von C++ Integer in Java boolean
void JniUtil::setBooleanField(jobject object, const char *name, int value) {
    jclass klass = env->GetObjectClass(object);
    jfieldID fid = env->GetFieldID(klass, name, "Z");
    if(value == 1){
        env->SetBooleanField(object, fid, JNI_TRUE);
    }else{
        env->SetBooleanField(object, fid, JNI_FALSE);
    }
}
