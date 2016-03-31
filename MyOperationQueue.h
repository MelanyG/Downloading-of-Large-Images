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

@interface MyOperationQueue : NSOperation <NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property(assign, nonatomic) BOOL isCancelled;
//@property(assign, nonatomic) BOOL isFinished;
@property (nonatomic, readwrite, getter = isExecuting) BOOL isExecuting;
@property (nonatomic, readwrite, getter = isFinished)  BOOL isFinished;
@property (nonatomic, readwrite, getter = isFinished)  BOOL isAsynchronous;
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
