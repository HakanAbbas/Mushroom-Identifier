//
//  OpenCVWrapper.m
//  CameraApp
//
//  Created by mbkair02 on 31.10.16.
//  Copyright © 2016 user. All rights reserved.
//

#import "OpenCVWrapper.h"
#import "PilzC.h"

#import "Source.cpp"

#include <opencv2/core/core.hpp>
//#include <iostream>
#include "opencv2/opencv.hpp"

#include "opencv2/objdetect/objdetect.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

#include <cstdlib>
#include <iostream>
#include <stdio.h>
//#include <windows.h>
#include <codecvt>
//#include <string>
#include <list>

using namespace std;

//OpenCVWrapper.h File Implementierung
@implementation OpenCVWrapper

+(NSMutableArray<PilzC *> *) detectMushroom:(UIImage*) img : (NSString*) xmlpath1 : (NSString*) xmlpath2
{
    std::string xmlpathh1 = std::string([xmlpath1 UTF8String]);
    std::string xmlpathh2 = std::string([xmlpath2 UTF8String]);
    
    vector<Pilz> mushlist = detectMushroom(xmlpathh1, xmlpathh2, convertToMat(img));
    
    NSMutableArray<PilzC *> *arr = [[NSMutableArray alloc] init];
    PilzC *c = [[PilzC alloc] init];
    
    for(int i = 0; i < mushlist.size(); i++){
        c.name = [NSString stringWithUTF8String:mushlist[i].name.c_str()];
        c.wiki = [NSString stringWithUTF8String:mushlist[i].wiki.c_str()];
        c.stalk = [NSString stringWithUTF8String:mushlist[i].stalk.c_str()];
        c.lamell = mushlist[i].lamell;
        c.nodule = mushlist[i].nodule;
        c.poisonous = mushlist[i].poisonous;
        c.round = mushlist[i].roud;
        
        cout << c.name;
        
        [arr addObject: c];
        
        c = [[PilzC alloc] init];
    }
    
    return arr;
    
}

+(NSMutableArray<PilzC *> *) allMushrooms: (NSString*) xmlpath{
    std::string xmlpathh = std::string([xmlpath UTF8String]);
    
    vector<Pilz> mushlist = readxml(string(xmlpathh)); //Liste aller gelesenen Pilze
    
    NSMutableArray<PilzC *> *arr = [[NSMutableArray alloc] init];
    
    PilzC *c = [[PilzC alloc] init];
    
    for(int i = 0; i < mushlist.size(); i++){
        c.name = [NSString stringWithUTF8String:mushlist[i].name.c_str()];
        c.wiki = [NSString stringWithUTF8String:mushlist[i].wiki.c_str()];
        c.stalk = [NSString stringWithUTF8String:mushlist[i].stalk.c_str()];
        c.lamell = mushlist[i].lamell;
        c.nodule = mushlist[i].nodule;
        c.poisonous = mushlist[i].poisonous;
        c.round = mushlist[i].roud;
        
        cout << c.name;
        
        [arr addObject: c];
        
        c = [[PilzC alloc] init];
    }
    
    return arr;
}


Mat convertToMat(UIImage* img)
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(img.CGImage);
    CGFloat cols = img.size.width;
    CGFloat rows = img.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), img.CGImage);
    CGContextRelease(contextRef);
    
    cv::cvtColor(cvMat, cvMat, cv::COLOR_RGB2BGR);
    
    return cvMat;
}

UIImage* convertToUIImage(Mat image)
{
    NSData *data = [NSData dataWithBytes:image.data length:image.elemSize()*image.total()];
    
    CGColorSpaceRef colorSpace;
    
    if (image.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(image.cols,                                 //width
                                        image.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * image.elemSize(),                       //bits per pixel
                                        image.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}


@end
















