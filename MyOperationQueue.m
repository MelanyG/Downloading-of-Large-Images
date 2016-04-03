 //
//  MyOperationQueue.m
//  Downloading
//
//  Created by Melany Gulianovych on 3/29/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import "MyOperationQueue.h"
//#import "CustomTableViewCell.h"
#import "DataSourse.h"
#import "ContentTableView.h"

NSString* const LoadImagesNotification = @"ImagesLoaded";


static NSInteger visitedTimes;
//NSInteger selectedCell;
//NSMutableArray *currentDownloadings;
                                      
@interface MyOperationQueue ()

@property(strong, nonatomic) NSURLSession* defaultSession;
@property (strong, nonatomic) NSURLSessionDownloadTask* downloadTask;

@end

@implementation MyOperationQueue
@dynamic executing;
@dynamic finished;


- (id)initWithURL:(NSURL*)url andRaw:(NSInteger)row
{
    if (![super init])
        return nil;
    [self setTargetURL:url];
    self.sourse = [DataSourse sharedManager];
    self.tableView = [[ContentTableView alloc]init];
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
    NSLog(@"I suppose that this queue also download this image");
     [self didChangeValueForKey:@"isExecuting"];
    if ([self isCancelled])  return;

    [ self.downloadTask  resume];
    NSLog(@"Operation finished");

}

- (void)finish
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    self.defaultSession = nil;
    self.downloadTask = nil;
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
     NSLog(@"operationfinished.");
    
}

- (void)cancel
{
    [super cancel];

    if(self.downloadTask.state == NSURLSessionTaskStateRunning)
    [self.downloadTask cancel];
    [self finish];
     NSLog(@"** operation cancelled **");
}

- (void)updateButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LoadImagesNotification
                                                        object:nil
                                                      userInfo:nil];
    //[self.tableView updatePage];
   // NSLog(@"Visited New York");
    
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
    if([self isCancelled])
    {
        [self cancel];
        return;
    }
    //dispatch_async(dispatch_get_main_queue(), ^{
        float progress = (float) (totalBytesWritten/1024) / (float) (totalBytesExpectedToWrite/1024);
        if ([self isCancelled])
        {
         return;
        }
        //self.customCell.progressView.progress = progress;
        //self.customCell.realProgressStatus.text = [NSString stringWithFormat:@"%0.f%%", progress*100];
    NSInteger selectedCell = [[self.sourse.queueRegistration objectForKey:[NSString stringWithFormat:@"%p", self]]intValue];
    [[self.sourse.dataDictionary objectForKey:self.sourse.names[selectedCell]] setRealProgressViewStatus:[NSString stringWithFormat:@"%0.f%%", progress*100]];
    [[self.sourse.dataDictionary objectForKey:self.sourse.names[selectedCell]] setProgressData:progress];
    [self performSelectorOnMainThread:@selector(updateButton) withObject:nil waitUntilDone:NO];
//    [[NSNotificationCenter defaultCenter] postNotificationName:LoadImagesNotification
//                                                        object:nil
//                                                      userInfo:nil];
        // NSLog(@"downloaded %d%%", (int)(100.0*prog));
   // });
}

-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    if(visitedTimes == 1)
    {
        [self cancel];
        NSLog(@"Visited = %ld",(long)visitedTimes);
        //NSLog(@"SelectedCell = %ld",(long)selectedCell);
         NSLog(@"SelectedCell = %@", self.name);
        visitedTimes = 0;
        [self main];
    }

       self.downloadTask = downloadTask;
    if([self isCancelled])
    {
        [self cancel];
        return;
    }
    NSInteger selectedCell = [[self.sourse.queueRegistration objectForKey:[NSString stringWithFormat:@"%p", self]]intValue];
    NSLog(@"didFinishDownloadingToURL - Queue");
    NSData *d = [NSData dataWithContentsOfURL:location];
    UIImage *im = [UIImage imageWithData:d];
    //dispatch_async(dispatch_get_main_queue(), ^{

    //self.customCell.image.image = im;
      //  self.customCell.realProgressStatus.text = @"Downloaded";
        //[self.tableView.tableView reloadData];
    //});
    [[self.sourse.dataDictionary objectForKey:self.sourse.names[selectedCell]] setDownloadedImage:im];
    [[self.sourse.dataDictionary objectForKey:self.sourse.names[selectedCell]] setRealProgressViewStatus:@"Downloaded"];
    [[self.sourse.dataDictionary objectForKey:self.sourse.names[selectedCell]] setProgressData:1.f];
    //[self.savedImages setObject:im forKey:self.customCell.nameOfImage.text];
    NSNumber *myNum = [NSNumber numberWithInteger:selectedCell];
    [self.sourse.tagsOfCells addObject:myNum];
    //[[self.sourse.dataDictionary objectForKey:self.sourse.names[self.currentCell]]setCustomCell:self.customCell];
    [self performSelectorOnMainThread:@selector(updateButton) withObject:nil waitUntilDone:NO];
//    [[NSNotificationCenter defaultCenter] postNotificationName:LoadImagesNotification
//                                                        object:nil
//                                                      userInfo:nil];
    //self.defaultSession.delegateQueue = nil;
   [self finish];
}


//- (void)URLSession:(NSURLSession *)session
//          dataTask:(NSURLSessionDataTask *)dataTask
//didReceiveResponse:(NSURLResponse *)response
// completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
//{
//    if([self isCancelled])
//    {
//        [self cancel];
//        return;
//    }
//       //self.downloadTask = dataTask;
//    completionHandler(NSURLSessionResponseAllow);
//    NSLog(@"didReceiveResponse in Queue");
//    self.customCell.progressView.progress = 0.0f;
//    self.downloadSize = [response expectedContentLength];
//    self.imageData = [[NSMutableData alloc]init];
//    
//    self.urlResponse = response;
//    
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//    NSDictionary *dict = httpResponse.allHeaderFields;
//    NSString *lengthString = [dict valueForKey:@"Content-Length"];
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//    NSNumber *length = [formatter numberFromString:lengthString];
//    self.totalBytes = length.unsignedIntegerValue;
//    
//    self.imageData = [[NSMutableData alloc] initWithCapacity:self.totalBytes];
//}

//- (void)URLSession:(NSURLSession *)session
//          dataTask:(NSURLSessionDataTask *)dataTask
//    didReceiveData:(NSData *)data
//{
//    if([self isCancelled])
//    {
//        [self cancel];
//        return;
//    }
//    [self.imageData appendData:data];
//    float per = [self.imageData length ]/_downloadSize;
//    self.customCell.progressView.progress = per;
//    self.customCell.realProgressStatus.text = [NSString stringWithFormat:@"%0.f%%", per*100];
//}

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
        NSLog(@"Error Queue");
        NSLog(@"completed; error: %@", error);
        [self cancel];
    }
}


@end
