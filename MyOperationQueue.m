//
//  MyOperationQueue.m
//  Downloading
//
//  Created by Melany Gulianovych on 3/29/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import "MyOperationQueue.h"
#import "DataSourse.h"
#import "ContentTableView.h"

NSString* const LoadImagesNotification = @"ImagesLoaded";

@interface MyOperationQueue ()

@property(assign, nonatomic) NSInteger currentCell;
@property(strong, nonatomic) NSURLSession* defaultSession;
@property (strong, nonatomic) NSURLSessionDownloadTask* downloadTask;

@end

@implementation MyOperationQueue
@dynamic executing;
@dynamic finished;
@dynamic cancelled;

- (id)initWithURL:(NSURL*)url andRaw:(NSInteger)row
{
    if (![super init])
        return nil;
    [self setTargetURL:url];
    self.currentCell = row;
    self.sourse = [DataSourse sharedManager];
    self.defaultSession = [self configureSession];
    
    return self;
}
#pragma mark  - Overrides

- (BOOL)isExecuting
{
    if(self.defaultSession!=nil)
        return YES;
    return NO;
}

- (BOOL)isFinished
{
    if(self.defaultSession==nil)
        return YES;
    return NO;
}
- (BOOL)isAsynchronous
{
    return YES;
}

#pragma mark  - Main & Utility Methods

- (void)start
{
    [self willChangeValueForKey:@"isExecuting"];
    
    if ([self isCancelled])
        return;
    
    self.downloadTask = [self.defaultSession downloadTaskWithURL:self.targetURL];
    
    [self didChangeValueForKey:@"isExecuting"];
    if ([self isCancelled])  return;
    
    [ self.downloadTask  resume];
}

- (void)finish
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    self.defaultSession = nil;
    self.downloadTask = nil;
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
    
    
}

- (void)cancel
{
    [super cancel];
    
    if(self.downloadTask.state == NSURLSessionTaskStateRunning)
        [self.downloadTask cancel];
    [self finish];
}

#pragma mark  - Update UI

- (void)updateButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LoadImagesNotification
                                                        object:nil
                                                      userInfo:nil];
}

#pragma mark  - Delegate Methods for NSURLSession

- (NSURLSession *) configureSession
{
    NSURLSessionConfiguration *config =
    [NSURLSessionConfiguration ephemeralSessionConfiguration];
    config.sessionSendsLaunchEvents = YES;
    config.discretionary = YES;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    return session;
}

-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
     didWriteData:(int64_t)bytesWritten
totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    self.downloadTask = downloadTask;
    NSNumber *myNum = [NSNumber numberWithInteger:self.currentCell];
    [self.sourse.tagsOfCells addObject:myNum];
    
    if([self isCancelled])
    {
        [self cancel];
        return;
    }
    float progress = (float) (totalBytesWritten/1024) / (float) (totalBytesExpectedToWrite/1024);
    if ([self isCancelled])
    {
        [self cancel];
        return;
    }
    
    
    [[self.sourse.dataDictionary objectForKey:self.sourse.names[self.currentCell]] setRealProgressViewStatus:[NSString stringWithFormat:@"%0.f%%", progress*100]];
    [[self.sourse.dataDictionary objectForKey:self.sourse.names[self.currentCell]] setProgressData:progress];
    [self performSelectorOnMainThread:@selector(updateButton) withObject:nil waitUntilDone:NO];
    
}

-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    self.downloadTask = downloadTask;
    if([self isCancelled])
    {
        [self cancel];
        return;
    }
    
    NSData *d = [NSData dataWithContentsOfURL:location];
    UIImage *im = [UIImage imageWithData:d];
    
    [[self.sourse.dataDictionary objectForKey:self.sourse.names[self.currentCell]] setDownloadedImage:im];
    [[self.sourse.dataDictionary objectForKey:self.sourse.names[self.currentCell]] setRealProgressViewStatus:@"Downloaded"];
    [[self.sourse.dataDictionary objectForKey:self.sourse.names[self.currentCell]] setProgressData:1.f];
    
    [self performSelectorOnMainThread:@selector(updateButton) withObject:nil waitUntilDone:NO];
    
    [self finish];
}


-(void)URLSession:(NSURLSession *)session
             task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if([self isCancelled])
    {
        [self cancel];
        return;
    }
    if(error)
    {
        NSLog(@"completed; error: %@", error);
        [self cancel];
    }
}


@end
