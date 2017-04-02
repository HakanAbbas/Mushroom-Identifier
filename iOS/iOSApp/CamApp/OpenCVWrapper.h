//
//  OpenCVWrapper.h
//  CamApp
//
//  Created by mbkair02 on 18.11.16.
//  Copyright © 2016 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PilzC.h"

@interface OpenCVWrapper : NSObject

+(NSMutableArray<PilzC *> *) detectMushroom:(UIImage*) img : (NSString*) xmlpath1 : (NSString*) xmlpath2;

+(NSMutableArray<PilzC *> *) allMushrooms: (NSString*) xmlpath;

@end
