//
//  MyOperationQueue.m
//  Downloading
//
//  Created by Melany Gulianovych on 3/29/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import "MyOperationQueue.h"
#import "ContentTableView.h"

@interface MyOperationQueue ()

@property(strong, nonatomic) CustomTableViewCell* customCell;
@property(strong, nonatomic) NSURLSession* defaultSession;
@property (strong, nonatomic) NSURLSessionDownloadTask* downloadTask;

@end

@implementation MyOperationQueue

- (id)initWithURL:(NSURL*)url andRaw:(NSInteger)row
{
    if (![super init])
        return nil;
    [self setTargetURL:url];
    [self setCurrentCell:row];
    self.customCell = [[CustomTableViewCell alloc]init];
    self.tableView = [ContentTableView sharedManager];
    self.defaultSession = [self configureSession];
    self.isAsynchronous = YES;
    self.isExecuting = YES;
    return self;
}
#pragma mark  - Overrides


- (BOOL)isExecuting
{
     NSLog(@"Exec");
    return (self.defaultSession != nil);
}

- (BOOL)isFinished
{
    NSLog(@"Finished");
    return (self.defaultSession == nil);
}

- (BOOL)isAsynchronous
{
    return YES;
}

#pragma mark  - Main & Utility Methods

- (void)main
{
    if ([self isCancelled])
        return;
    [self willChangeValueForKey:@"isExecuting"];
    //self.isExecuting = YES;
   
    [self didChangeValueForKey:@"isExecuting"];

    
    
    self.downloadTask = [self.defaultSession downloadTaskWithURL:self.targetURL];
    NSLog(@"I suppose that this queue also download this image");
    
    if ([self isCancelled])  return;
    
    //[self performSelectorOnMainThread:@selector(updateButton) withObject:nil waitUntilDone:NO];
    [ self.downloadTask  resume];
    NSLog(@"Operation finished");

}

- (void)finish
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    self.defaultSession = nil;
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
    
    NSLog(@"operationfinished.");
}

- (void)cancel
{
    [super cancel];
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    self.isExecuting = NO;
    self.isFinished  = YES;
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];

    if(self.downloadTask.state == NSURLSessionTaskStateRunning)
        [self.downloadTask cancel];
    
     NSLog(@"** operation cancelled **");
}

- (void)updateButton
{
    NSLog(@"Visited New York");
    
}

#pragma mark  - Delegate Methods for NSURLSession

- (NSURLSession *) configureSession
{
    NSLog(@"configureSession in Queue");
    NSURLSessionConfiguration *config =
    [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.my.backgroundDownload"];
    config.sessionSendsLaunchEvents = YES;
    config.discretionary = YES;
    //    NSURLSessionConfiguration *config =
    //    [NSURLSessionConfiguration defaultSessionConfiguration];
    //config.allowsCellularAccess = NO;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    //[[self.dataDictionary objectForKey:self.names[self.selectedCell]] setCurrentQueue:one];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        float progress = (float) (totalBytesWritten/1024) / (float) (totalBytesExpectedToWrite/1024);
        if ([self isCancelled])
        {
            NSLog(@"** operation cancelled **");
        }
        self.customCell.progressView.progress = progress;
        self.customCell.realProgressStatus.text = [NSString stringWithFormat:@"%0.f%%", progress*100];
        // NSLog(@"downloaded %d%%", (int)(100.0*prog));
    });
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
    NSLog(@"didFinishDownloadingToURL - Queue");
    NSData *d = [NSData dataWithContentsOfURL:location];
    UIImage *im = [UIImage imageWithData:d];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.customCell.image.image = im;
        self.customCell.realProgressStatus.text = @"Downloaded";
        [self.tableView.tableView reloadData];
    });
    [[self.tableView.dataDictionary objectForKey:self.tableView.names[self.currentCell]] setDownloadedImage:im];
    //[self.savedImages setObject:im forKey:self.customCell.nameOfImage.text];
    NSNumber *myNum = [NSNumber numberWithInteger:self.currentCell];
    [self.tableView.tagsOfCells addObject:myNum];
    [[self.tableView.dataDictionary objectForKey:self.tableView.names[self.currentCell]]setCustomCell:self.customCell];
    
    
}


- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    if([self isCancelled])
    {
        [self cancel];
        return;
    }
       //self.downloadTask = dataTask;
    completionHandler(NSURLSessionResponseAllow);
    NSLog(@"didReceiveResponse in Queue");
    self.customCell.progressView.progress = 0.0f;
    self.downloadSize = [response expectedContentLength];
    self.imageData = [[NSMutableData alloc]init];
    
    self.urlResponse = response;
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSDictionary *dict = httpResponse.allHeaderFields;
    NSString *lengthString = [dict valueForKey:@"Content-Length"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *length = [formatter numberFromString:lengthString];
    self.totalBytes = length.unsignedIntegerValue;
    
    self.imageData = [[NSMutableData alloc] initWithCapacity:self.totalBytes];
}

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
