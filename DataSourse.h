//
//  DataSourse.h
//  Downloading
//
//  Created by Melany Gulianovych on 3/31/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectForTableCell.h"

@interface DataSourse : NSObject

@property(strong, nonatomic) NSMutableDictionary* dataDictionary;
@property(strong, nonatomic) NSMutableArray* names;
@property(strong, nonatomic) NSMutableSet* tagsOfCells;
@property(assign, nonatomic) NSInteger experiment;
@property(strong, nonatomic) NSMutableDictionary* queueRegistration;

+ (instancetype)sharedManager;

@end
