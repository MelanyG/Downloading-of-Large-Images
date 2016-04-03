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



extern NSString* const LoadImagesNotification;


@interface MyOperationQueue : NSOperation <NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property(readonly, getter=isCancelled) BOOL cancelled;
@property(nonatomic, getter=isExecuting) BOOL executing;
@property(nonatomic, getter=isFinished) BOOL finished;
@property(readonly, getter=isAsynchronous) BOOL asynchronous;

@property(strong, nonatomic) DataSourse* sourse;
@property(retain) NSURL *targetURL;
@property(strong, nonatomic) NSMutableData* imageData;


- (id)initWithURL:(NSURL*)url andRaw:(NSInteger)row;
- (void)cancel;

@end
