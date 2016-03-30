//
//  MyOperationQueue.h
//  Downloading
//
//  Created by Melany Gulianovych on 3/29/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ContentTableView;
@class CustomTableViewCell;
//#import "ObjectForTableCell.h"

@interface MyOperationQueue : NSOperation

@property(assign, nonatomic) BOOL isCancelled;
@property(strong, nonatomic) ContentTableView* tableView;

@property(assign, nonatomic) NSInteger currentCell;
@property(retain) NSURL *targetURL;
@property(strong, nonatomic) NSMutableData* imageData;
@property (nonatomic) float downloadSize;
@property (strong, nonatomic) NSURLResponse *urlResponse;
@property (nonatomic) NSUInteger totalBytes;

- (id)initWithURL:(NSURL*)url andRaw:(NSInteger)row;
- (void)cancel;

@end
