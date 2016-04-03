//
//  MyOperationQueue.h
//  Downloading
//
//  Created by Melany Gulianovych on 3/29/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DataSourse;
@class ContentTableView;
//@class CustomTableViewCell;


extern NSString* const LoadImagesNotification;


@interface MyOperationQueue : NSOperation <NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property(readonly, getter=isCancelled) BOOL cancelled;
@property(nonatomic, getter=isExecuting) BOOL executing;
@property(nonatomic, getter=isFinished) BOOL finished;
@property(readonly, getter=isAsynchronous) BOOL asynchronous;
@property(strong, nonatomic) ContentTableView* tableView;

@property(strong, nonatomic) DataSourse* sourse;
@property(assign, nonatomic) NSInteger currentCell;
@property(retain) NSURL *targetURL;
@property(strong, nonatomic) NSMutableData* imageData;
@property (nonatomic) float downloadSize;
@property (strong, nonatomic) NSURLResponse *urlResponse;
@property (nonatomic) NSUInteger totalBytes;

- (id)initWithURL:(NSURL*)url andRaw:(NSInteger)row;
- (void)cancel;

@end
