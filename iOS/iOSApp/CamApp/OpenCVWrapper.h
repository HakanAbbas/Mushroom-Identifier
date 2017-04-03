//
//  OpenCVWrapper.h
//  MushroomIdentifier
//
//  Created by Markus Arbeithuber on 18.11.16.
//  Copyright © 2016 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MushroomC.h"

@interface OpenCVWrapper : NSObject

+(NSMutableArray<MushroomC *> *) detectMushroom:(UIImage*) img : (NSString*) xmlpath1 : (NSString*) xmlpath2;

+(NSMutableArray<MushroomC *> *) allMushrooms: (NSString*) xmlpath;

@end
