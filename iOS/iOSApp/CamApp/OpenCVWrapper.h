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

//Bilderkennung (gibt eine Liste aller Pilze, die in Frage kommen, zurück)
+(NSMutableArray<MushroomC *> *) detectMushroom:(UIImage*) img : (NSString*) xmlpathMushrooms : (NSString*) xmlpathHaar;

//gibt eine Liste aller gespeicherten Pilze zurück
+(NSMutableArray<MushroomC *> *) allMushrooms: (NSString*) xmlpathMushrooms;

@end
