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
    
    return self;
}

- (void)main
{
    if ([self isCancelled])
    {
        NSLog(@"** operation cancelled **");
        return;
    }
    // NSURLSession *defaultSession;
    self.defaultSession = [self configureSession];
    //NSURL *url = [NSURL URLWithString: self.targetURL];
    // MyOperationQueue * one = [[MyOperationQueue alloc]initWithURL:url andRaw:self.selectedCell];
    //[self.queue addOperation:one];
    NSURLSessionDownloadTask *task = [self.defaultSession downloadTaskWithURL:self.targetURL];
    NSLog(@"I suppose that this queue also download this image");
    
    
    
    if ([self isCancelled])
    {
        NSLog(@"** operation cancelled **");
        return;
    }
    // Do any clean-up work here...
    
    // If you need to update some UI when the operation is complete, do this:
    [self performSelectorOnMainThread:@selector(updateButton) withObject:nil waitUntilDone:NO];
    [task resume];
    NSLog(@"Operation finished");
}

- (void)updateButton
{
    NSLog(@"Visitied New York");
    // Update the button here
}

- (void)cancel
{
    self.isCancelled = YES;
    NSLog(@"** operation cancelled **");
    
}


- (NSURLSession *) configureSession
{
    NSLog(@"configureSession in Queue");
    NSURLSessionConfiguration *config =
    [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.my.backgroundDownload"];
    config.allowsCellularAccess = NO;
    ObjectForTableCell* tmp =[self.tableView.dataDictionary objectForKey:self.tableView.names[self.currentCell]];
    // NSURL *url = [NSURL URLWithString: tmp.imeageURL];
    // MyOperationQueue * one = [[MyOperationQueue alloc]initWithURL:url andRaw:self.currentCell];
    //one.cancelled = YES;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self.tableView delegateQueue:self];
    //[self.queue addOperation:one];
    //[[self.dataDictionary objectForKey:self.names[self.selectedCell]] setCurrentQueue:one];
    return session;
}

-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
     didWriteData:(int64_t)bytesWritten
totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
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
}


- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
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

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
    float per = [self.imageData length ]/_downloadSize;
    self.customCell.progressView.progress = per;
    self.customCell.realProgressStatus.text = [NSString stringWithFormat:@"%0.f%%", per*100];
}

-(void)URLSession:(NSURLSession *)session
             task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if(error)
    {
        NSLog(@"Error Queue");
        NSLog(@"completed; error: %@", error);
    }
}

@end
