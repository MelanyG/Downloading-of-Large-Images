//
//  ObjectForTableCell.h
//  Downloading
//
//  Created by Melany Gulianovych on 3/26/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MyOperationQueue.h"

@interface ObjectForTableCell : NSObject


@property (strong, nonatomic) MyOperationQueue* currentQueue;
@property(strong, nonatomic) NSString* imageName;
@property(strong, nonatomic) NSString* imeageURL;
@property (strong, nonatomic) UIImage* downloadedImage;
//@property(strong, nonatomic) CustomTableViewCell *customCell;
@property (strong, nonatomic) NSString* realProgressViewStatus;
@property (assign, atomic) CGFloat progressData;


@end
