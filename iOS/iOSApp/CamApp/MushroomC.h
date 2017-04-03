//
//  MushroomC.h
//  MushroomIdentifier
//
//  Created by mbkair02 on 22.02.17.
//  Copyright © 2017 user. All rights reserved.
//

#import <Foundation/Foundation.h>

//PILZ KLASSE///////////////////////////////////////////////////////////////////////////////////////////////////
@interface MushroomC:NSObject

    @property(nonatomic, readwrite) NSString *name;     // Name des Pilzes
    @property(nonatomic, readwrite) NSString *wiki;     // Wikipedia Link
    @property(nonatomic, readwrite) int poisonous;      // ist der Pilz giftig, 1 ja, 0 nein
    @property(nonatomic, readwrite) int round;          // ist der Pilz rund, 1 ja, 0 nein
    @property(nonatomic, readwrite) int lamell;         // hat der Pilz Lamellen, 1 ja, 0 nein
    @property(nonatomic, readwrite) int nodule;         // hat der Pilz eine Knolle, 1 ja, 0 nein
    @property(nonatomic, readwrite) NSString *stalk;    // Beschreibung des Stiels

@end


