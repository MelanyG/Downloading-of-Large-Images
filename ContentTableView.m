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
@property (nonatomic) float downloadSize;
@property (nonatomic, strong) MyOperationQueue* one;
@property (nonatomic, strong) NSOperationQueue* queue;
@end

@implementation ContentTableView

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
     self.queue = [[NSOperationQueue alloc] init];
    
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
//    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue currentQueue]];
    NSURLSession *defaultSession;
    defaultSession = [self configureSession];
    NSURL *url = [NSURL URLWithString: tmp.imeageURL];
 
    NSURLSessionDownloadTask *task = [defaultSession downloadTaskWithURL:url];
    [task resume];



}
- (NSURLSession *) configureSession
{
    NSURLSessionConfiguration *config =
    [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.melany.backgroundDownload"];
    config.allowsCellularAccess = NO;
    MyOperationQueue * one = [[MyOperationQueue alloc]init];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue: one];
    [self.queue addOperation:one];
    return session;
}

-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
     didWriteData:(int64_t)bytesWritten
totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float progress = (float) (totalBytesWritten/1024) / (float) (totalBytesExpectedToWrite/1024);

    self.customCell.progressView.progress = progress;
    self.customCell.realProgressStatus.text = [NSString stringWithFormat:@"%0.f%%", progress*100];
   // NSLog(@"downloaded %d%%", (int)(100.0*prog));
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{

}

-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSData *d = [NSData dataWithContentsOfURL:location];
    UIImage *im = [UIImage imageWithData:d];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.customCell.image.image = im;
        self.customCell.realProgressStatus.text = @"Downloaded";
        [self.tableView reloadData];
    });
    [self.savedImages setObject:im forKey:self.customCell.nameOfImage.text];
    NSNumber *myNum = [NSNumber numberWithInteger:self.selectedCell];
    [self.tagsOfCells addObject:myNum];
}







- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    
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
    NSLog(@"completed; error: %@", error);
}


- (void)didClickStopAtIndex:(NSInteger)cellIndex withData:(id)data
{
    self.customCell = data;
    self.selectedCell = cellIndex;
 
}


@end
