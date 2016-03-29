//
//  ContentTableView.m
//  Downloading
//
//  Created by Melany Gulianovych on 3/26/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import "ContentTableView.h"
#import "ObjectForTableCell.h"
#import "ImageViewController.h"

#define myAsyncQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface ContentTableView ()

@property(strong, nonatomic) NSMutableDictionary* dataDictionary;
@property(strong, nonatomic) NSMutableArray* names;
@property(strong, nonatomic) CustomTableViewCell *customCell;
@property (strong, nonatomic) NSURLConnection *connectionManager;
@property (strong, nonatomic) NSURLResponse *urlResponse;
@property(nonatomic, strong) NSMutableData *imageData;
@property(strong, nonatomic) NSMutableDictionary* savedImages;
@property(assign, nonatomic) NSInteger selectedCell;
@property(strong, nonatomic) NSMutableSet* tagsOfCells;
@property (nonatomic) NSUInteger totalBytes;
@property (nonatomic) NSUInteger receivedBytes;

@property (nonatomic, copy) void (^backgroundSessionCompletionHandler)(void);
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionUploadTask *uploadTask;


@end

@implementation ContentTableView

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.session= [NSURLSession sharedSession];
//    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
//                                                          delegate:nil
//                                                     delegateQueue:[NSOperationQueue currentQueue]];
   //self.session =[self backgroundSession];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"World"];
    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    self.dataDictionary = [[NSMutableDictionary alloc]init];
    self.savedImages = [[NSMutableDictionary alloc]init];
    self.tagsOfCells = [[NSMutableSet alloc]init];
    self.names = [[NSMutableArray alloc]initWithObjects:@"Snow Tiger", @"Elephant", @"Sunset",@"Nature silence",@"Tree",@"White tiger",@"Waterfall",@"Owl",@"Fairytail",@"End of space",@"House", @"Beautiful Nature",@"Green Waterfall", @"Wooden road", @"Beach", @"Color nature", @"Autumn nature", @"New year", @"Christmas tree", @"Christmas", nil];
    NSArray* urlNames = [[NSArray alloc]initWithObjects:
                         @"https://www.planwallpaper.com/static/images/Winter-Tiger-Wild-Cat-Images.jpg",
                         @"https://www.planwallpaper.com/static/images/9-credit-1.jpg",
                         @"https://www.planwallpaper.com/static/images/wallpaper-sunset-images-back-217159.jpg",
                         @"https://www.planwallpaper.com/static/images/beautiful-sunset-images-196063.jpg",
                         @"https://www.planwallpaper.com/static/images/6775415-beautiful-images.jpg",
                         @"https://www.planwallpaper.com/static/images/desktop-year-of-the-tiger-images-wallpaper.jpg",
                         @"https://www.planwallpaper.com/static/images/6986083-waterfall-images_Mc3SaMS.jpg",
                         @"https://www.planwallpaper.com/static/images/7028135-cool-pictures-for-wallpapers-hd.jpg",
                         @"https://www.planwallpaper.com/static/images/2ba7dbaa96e79e4c81dd7808706d2bb7_large.jpeg",
                         @"https://www.planwallpaper.com/static/images/6-940622110b39cad584098e6749eac708.jpg",
                         @"https://www.planwallpaper.com/static/images/6-house-in-green-field.jpg",
                         @"https://www.planwallpaper.com/static/images/Blue-Green-beautiful-nature-21891805-1920-1200.jpg",
                         @"https://www.planwallpaper.com/static/images/Nature-Wallpapers-6_J0BmGvg.jpg",
                         @"https://www.planwallpaper.com/static/images/Rossville_Boardwalk_Wolf_River.jpg",
                         @"https://www.planwallpaper.com/static/images/clairvoyant-nature-nature5.jpg",
                         @"https://www.planwallpaper.com/static/images/colorful-nature-wallpaper.jpg",
                         @"https://www.planwallpaper.com/static/images/autumn-nature-bridge-wood-trees-leaves-red-green-yellow.jpg",
                         @"https://www.planwallpaper.com/static/images/9c752472-d5a9-4d74-978c-344511d0896e.jpg",
                         @"https://www.planwallpaper.com/static/images/LOA-christmas-tree.jpg",
                         @"https://www.planwallpaper.com/static/images/Clifton_Mill_Christmas_2005.JPG",
                         nil];
    NSInteger count =[self.names count];
    
    for(int i=0; i< count; i++)
    {
        ObjectForTableCell* tmp = [[ObjectForTableCell alloc]init];
        tmp.imageName = self.names[i];
        tmp.imeageURL = urlNames[i];
        [self.dataDictionary setObject:tmp forKey:self.names[i]];
    }
}


#pragma mark - Delegate Methods

-(void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    
    self.urlResponse = response;
    
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSDictionary *dict = httpResponse.allHeaderFields;
    NSString *lengthString = [dict valueForKey:@"Content-Length"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *length = [formatter numberFromString:lengthString];
    self.totalBytes = length.unsignedIntegerValue;
    
    self.imageData = [[NSMutableData alloc] initWithCapacity:self.totalBytes];
}

-(void)connection:(NSURLConnection *)connection
   didReceiveData:(NSData *)data
{
    
    [self.imageData appendData:data];
    self.customCell.progressView.progress = ((100.0/self.urlResponse.expectedContentLength)*self.imageData.length)/100;
    
    float per = ((100.0/self.urlResponse.expectedContentLength)*self.imageData.length);
    self.customCell.realProgressStatus.text = [NSString stringWithFormat:@"%0.f%%", per];
    
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"This image were not loaded" message:@"Error" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.customCell.realProgressStatus.text = @"Downloaded";
        
        UIImage *img = [UIImage imageWithData:self.imageData];
        self.customCell.image.image = img;
        self.customCell.tag = self.selectedCell;
        [self.savedImages setObject:img forKey:self.customCell.nameOfImage.text];
        NSNumber *myNum = [NSNumber numberWithInteger:self.selectedCell];
        [self.tagsOfCells addObject:myNum];
    });
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Navigation with Segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ImageVC"])
    {
        ImageViewController * ivc = segue.destinationViewController;
        ivc.myTemporaryImage = [self.savedImages objectForKey:self.names[self.selectedCell]];;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.names count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* PlaceholderCellIdentifier = @"Cell";
    CustomTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier forIndexPath:indexPath];
    
    if (!customCell)
    {
        customCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:@"cell"];
    }
    
    NSNumber *myNum = [NSNumber numberWithInteger:indexPath.row];
    
    if (![self.tagsOfCells containsObject:myNum])
    {
        
        UIImage *img = [UIImage imageNamed:@"placeholder"];
        customCell.realProgressStatus.text = @"";
        customCell.progressView.progress = 0.1;
        customCell.image.image = img;
        [customCell setNeedsLayout];
        customCell.startButton.enabled = YES;
    }
    else
    {
        customCell.image.image = [self.savedImages objectForKey:self.names[indexPath.row]];
        customCell.realProgressStatus.text = @"Downloaded";
        customCell.progressView.progress = 1;
        customCell.startButton.enabled = NO;
    }
    
    customCell.delegate = self;
    customCell.cellIndex = indexPath.row;
    customCell.nameOfImage.text = self.names[indexPath.row];
    if ( indexPath.row % 2 == 0 )
        customCell.backgroundColor = [UIColor grayColor];
    else
        customCell.backgroundColor = [UIColor darkGrayColor];
    
    
    return customCell;
}



-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCell = indexPath.row;
    if ([self.savedImages objectForKey:self.names[self.selectedCell]])
    {
        [self performSegueWithIdentifier:@"ImageVC" sender: indexPath];
        return nil;
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"You should download the image first" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    return nil;
}

#pragma mark - Delegate methods


- (void)didClickStartAtIndex:(NSInteger)cellIndex withData:(CustomTableViewCell*)data
{
    //dispatch_async(myAsyncQueue, ^{
    self.customCell = data;
    self.selectedCell = cellIndex;
    ObjectForTableCell* tmp =[self.dataDictionary objectForKey:self.names[cellIndex]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:tmp.imeageURL]];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:urlRequest];

//
//                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                            timeoutInterval:60.0];
//    self.connectionManager = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
//    });
//[self asynchLoad:nil forIndexPath:cellIndex];
    
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:tmp.imeageURL]];
//    
//    NSURLSessionDownloadTask *task = [self.session downloadTaskWithRequest:request];
//    //[self imageUrl:tmp.imeageURL];
   [task resume];
}
//- (void)URLSession:(NSURLSession *)session
//              task:(NSURLSessionTask *)task
//   didSendBodyData:(int64_t)bytesSent
//    totalBytesSent:(int64_t)totalBytesSent
//totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_progress setProgress:
//         (double)totalBytesSent /
//         (double)totalBytesExpectedToSend animated:YES];
//    });
//}
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
//   NSMutableData *responseData = self.responsesData[@(dataTask.taskIdentifier)];
//    if (!responseData)
//    {
////        responseData = [NSMutableData dataWithData:data];
////        self.responsesData[@(dataTask.taskIdentifier)] = responseData;
//    }
//    else
//    {
        [self.imageData appendData:data];
        self.customCell.progressView.progress = ((100.0/self.urlResponse.expectedContentLength)*self.imageData.length)/100;
        
        float per = ((100.0/self.urlResponse.expectedContentLength)*self.imageData.length);
        self.customCell.realProgressStatus.text = [NSString stringWithFormat:@"%0.f%%", per];
   // }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if (error)
    {
        NSLog(@"%@ failed: %@", task.originalRequest.URL, error);
    }
    
//    NSMutableData *responseData = self.responsesData[@(task.taskIdentifier)];
//    
//    if (responseData) {
//        // my response is JSON; I don't know what yours is, though this handles both
//        
//        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
//        if (response) {
//            NSLog(@"response = %@", response);
//        } else {
//            NSLog(@"responseData = %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
//        }
//        
//        [self.responsesData removeObjectForKey:@(task.taskIdentifier)];
//    }
//    else
//    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"This image were not loaded" message:@"Error" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    //}
}
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    self.urlResponse = response;
    NSUInteger jo=dataTask.taskIdentifier;
    //NSURLSessionDataTask *dataTask1;
     NSMutableData *responseData = [NSMutableData dataWithBytes:&jo length:sizeof(jo)];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSDictionary *dict = httpResponse.allHeaderFields;
    NSString *lengthString = [dict valueForKey:@"Content-Length"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *length = [formatter numberFromString:lengthString];
    self.totalBytes = length.unsignedIntegerValue;
    self.imageData = [[NSMutableData alloc] initWithCapacity:self.totalBytes];
    [self.imageData appendData:responseData];
    self.customCell.progressView.progress = ((100.0/self.urlResponse.expectedContentLength)*self.imageData.length)/100;
    
    float per = ((100.0/self.urlResponse.expectedContentLength)*self.imageData.length);
    self.customCell.realProgressStatus.text = [NSString stringWithFormat:@"%0.f%%", per];
    self.imageData = [[NSMutableData alloc] initWithCapacity:self.totalBytes];

}
//Mix
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    if (self.backgroundSessionCompletionHandler)
    {
        dispatch_async(dispatch_get_main_queue(),
                       ^{
        self.customCell.realProgressStatus.text = @"Downloaded";
        
        UIImage *img = [UIImage imageWithData:self.imageData];
        self.customCell.image.image = img;
        self.customCell.tag = self.selectedCell;
        [self.savedImages setObject:img forKey:self.customCell.nameOfImage.text];
        NSNumber *myNum = [NSNumber numberWithInteger:self.selectedCell];
        [self.tagsOfCells addObject:myNum];

        self.backgroundSessionCompletionHandler = nil;
                       });
    }
}


- (void)imageUrl:(NSString*)urlImage
{
    NSURLSessionDownloadTask *getImageTask =
   [self.session downloadTaskWithURL:[NSURL URLWithString:urlImage]
     
               completionHandler:^(NSURL *location,
                                   NSURLResponse *response,
                                   NSError *error) {
                   // 2
                   UIImage *downloadedImage =
                   [UIImage imageWithData:
                    [NSData dataWithContentsOfURL:location]];
                   //3
                   dispatch_async(dispatch_get_main_queue(), ^{
                       // do stuff with image
                       self.customCell.image.image = downloadedImage;
                   });
               }];

    
    }

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
        dispatch_async(dispatch_get_main_queue(),
                   ^{
                       float progress = (float) (totalBytesWritten/1024) / (float) (totalBytesExpectedToWrite/1024);

                       self.customCell.progressView.progress = progress;
                       self.customCell.realProgressStatus.text = [NSString stringWithFormat:@"%0.f%%", progress*100];

                       NSLog(@"%f", progress);
                   });
}

- (NSURLSession *)backgroundSession
{
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
                  ^{    // Session Configuration
                      NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.NSUrlSession.app"];
                      
                      // Initialize Session
                      session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                              delegate:self
                                                         delegateQueue:nil];
        
         });
    
    return session;
}


//Ray

//- (void)uploadImage:(UIImage*)image
//{
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
//    
//    // 1
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    config.HTTPMaximumConnectionsPerHost = 1;
//    //[config setHTTPAdditionalHeaders:@{@"Authorization": [Dropbox apiAuthorizationHeader]}];
//    
//    // 2
//    NSURLSession *upLoadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
//    
//    // for now just create a random file name, dropbox will handle it if we overwrite a file and create a new name..
//    NSURL *url = [Dropbox createPhotoUploadURL];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    [request setHTTPMethod:@"PUT"];
//    
//    // 3
//    self.uploadTask = [upLoadSession uploadTaskWithRequest:request fromData:imageData];
//    
//    // 4
//    self.uploadView.hidden = NO;
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    
//    // 5
//    [_uploadTask resume];
//}
//
//#pragma mark - NSURLSessionTaskDelegate methods
//
//- (void)URLSession:(NSURLSession *)session
//              task:(NSURLSessionTask *)task
//   didSendBodyData:(int64_t)bytesSent
//    totalBytesSent:(int64_t)totalBytesSent
//totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_progress setProgress:
//         (double)totalBytesSent /
//         (double)totalBytesExpectedToSend animated:YES];
//    });
//}
//
//- (void)URLSession:(NSURLSession *)session
//              task:(NSURLSessionTask *)task
//didCompleteWithError:(NSError *)error
//{
//    // 1
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//        _uploadView.hidden = YES;
//        [_progress setProgress:0.5];
//    });
//    
//    if (!error) {
//        // 2
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self refreshPhotos];
//        });
//    } else {
//        // Alert for error
//    }
//}


//Ray


- (void)asynchLoad:(NSString *)urlString forIndexPath:(NSInteger)indexPath
{
    static int a = 1;
    ObjectForTableCell* tmp =[self.dataDictionary objectForKey:self.names[indexPath]];
    
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:tmp.imeageURL]];
   
//    [[session dataTaskWithURL:[NSURL URLWithString:londonWeatherUrl]
//            completionHandler:^(NSData *data,
//                                NSURLResponse *response,
//                                NSError *error)
   //NSURLSession * session;
    NSURLSessionTask *task = [self.session dataTaskWithRequest:urlRequest ];
//               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                   if (!error)
//                   {
//                       self.customCell.progressView.progress = ((100.0/response.expectedContentLength)*data.length)/100;
//                       NSLog(@"%d", a);
//                       a++;
//                       float per = ((100.0/response.expectedContentLength)*data.length);
//                       self.customCell.realProgressStatus.text = [NSString stringWithFormat:@"%0.f%%", per];            // create the image
//                       UIImage *img = [UIImage imageWithData:data];
//                       
//                       
//                       dispatch_async(dispatch_get_main_queue(), ^{
//                           
//                           self.customCell.realProgressStatus.text = @"Downloaded";
//                           
//                           //UIImage *img = [UIImage imageWithData:self.imageData];
//                           self.customCell.image.image = img;
//                           self.customCell.tag = indexPath;
//                           [self.savedImages setObject:img forKey:self.names[indexPath]];
//                           NSNumber *myNum = [NSNumber numberWithInteger:indexPath];
//                           [self.tagsOfCells addObject:myNum];
//                       });
//                       // important part - we make no assumption about the state of the table at this point
//                       // find out if our original index path is visible, then update it, taking
//                       // advantage of the cached image (and a bonus option row animation)
//                       
//                       //            NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
//                       //            if ([visiblePaths containsObject:indexPath])
//                       //            {
//                       //                NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
//                       //                [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation: UITableViewRowAnimationFade];
//                       //                // because we cached the image, cellForRow... will see it and run fast
//                       //            }
//                   }
//               }];

    //NSURLSessionDataTask * dataTask = [defaultSession :url
                                       
    [task resume];
//    
//    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        if (!error)
//        {
//            self.customCell.progressView.progress = ((100.0/response.expectedContentLength)*data.length)/100;
//            NSLog(@"%d", a);
//            a++;
//            float per = ((100.0/response.expectedContentLength)*data.length);
//            self.customCell.realProgressStatus.text = [NSString stringWithFormat:@"%0.f%%", per];            // create the image
//            UIImage *img = [UIImage imageWithData:data];
//            
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                self.customCell.realProgressStatus.text = @"Downloaded";
//                
//                //UIImage *img = [UIImage imageWithData:self.imageData];
//                self.customCell.image.image = img;
//                self.customCell.tag = indexPath;
//                [self.savedImages setObject:img forKey:self.names[indexPath]];
//                NSNumber *myNum = [NSNumber numberWithInteger:indexPath];
//                [self.tagsOfCells addObject:myNum];
//            });
//            // important part - we make no assumption about the state of the table at this point
//            // find out if our original index path is visible, then update it, taking
//            // advantage of the cached image (and a bonus option row animation)
//            
////            NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
////            if ([visiblePaths containsObject:indexPath])
////            {
////                NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
////                [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation: UITableViewRowAnimationFade];
////                // because we cached the image, cellForRow... will see it and run fast
////            }
//        }
//    }];
}
- (void)didClickStopAtIndex:(NSInteger)cellIndex withData:(id)data
{
    self.customCell = data;
    self.selectedCell = cellIndex;
    
    
}

@end
