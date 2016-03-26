//
//  ContentTableView.m
//  Downloading
//
//  Created by Melany Gulianovych on 3/26/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import "ContentTableView.h"
#import "ObjectForTableCell.h"

@interface ContentTableView ()

@property(strong, nonatomic) NSMutableDictionary* dataDictionary;
@property(strong, nonatomic) NSMutableArray* names;
@property(strong, nonatomic) CustomTableViewCell *customCell;
@property (strong, nonatomic) NSURLConnection *connectionManager;
@property (strong, nonatomic) NSMutableData *downloadedMutableData;
@property (strong, nonatomic) NSURLResponse *urlResponse;
@property(nonatomic, assign) CGFloat length;
@property(nonatomic, strong) NSMutableData *imageData;

@property (nonatomic) NSUInteger totalBytes;
@property (nonatomic) NSUInteger receivedBytes;
@end

@implementation ContentTableView

- (void)viewDidLoad
{
    [super viewDidLoad];

    //self.imageData = [[NSMutableData alloc] init];
    self.dataDictionary = [[NSMutableDictionary alloc]init];
   self.names = [[NSMutableArray alloc]initWithObjects:@"Snow Tiger", @"Elephant", @"Balloons",@"Adventures in the Sea",@"Tree",@"Fishing",@"Waterfall",@"Owl",nil];
    NSArray* urlNames = [[NSArray alloc]initWithObjects:
                         @"https://www.planwallpaper.com/static/images/Winter-Tiger-Wild-Cat-Images.jpg",
                         @"https://www.planwallpaper.com/static/images/9-credit-1.jpg",
                         @"https://www.planwallpaper.com/static/images/canberra_hero_image_JiMVvYU.jpg",
                         @"https://www.planwallpaper.com/static/images/offset_WaterHouseMarineImages_62652-2-660x440.jpg",
                         @"https://www.planwallpaper.com/static/images/6775415-beautiful-images.jpg",
                         @"https://www.planwallpaper.com/static/images/image5_170127819.jpg",
                         @"https://www.planwallpaper.com/static/images/6986083-waterfall-images_Mc3SaMS.jpg",
                         @"https://www.planwallpaper.com/static/images/7028135-cool-pictures-for-wallpapers-hd.jpg",
                         nil];
  
    for(int i=0; i<8; i++)
    {
        ObjectForTableCell* tmp = [[ObjectForTableCell alloc]init];
        tmp.imageName = self.names[i];
        tmp.imeageURL = urlNames[i];
        [self.dataDictionary setObject:tmp forKey:self.names[i]];
    }
}

#pragma mark - Delegate Methods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
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

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [self.imageData appendData:data];
    self.customCell.progressView.progress = ((100.0/self.urlResponse.expectedContentLength)*self.imageData.length)/100;
    
    float per = ((100.0/self.urlResponse.expectedContentLength)*self.imageData.length);
    self.customCell.realProgressStatus.text = [NSString stringWithFormat:@"%0.f%%", per];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"This image were not loaded" message:@"Error" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}]];

}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    self.customCell.realProgressStatus.text = @"Downloaded";
    
    
    
    UIImage *img = [UIImage imageWithData:self.imageData];
    self.customCell.image.image = img;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.names count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    
    CustomTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    customCell.delegate = self;
    customCell.cellIndex = indexPath.row;
    
    if ( indexPath.row % 2 == 0 )
        customCell.backgroundColor = [UIColor grayColor];
    else
        customCell.backgroundColor = [UIColor darkGrayColor];

   
    customCell.nameOfImage.text = self.names[indexPath.row];
    
    return customCell;
}

- (void)didClickStartAtIndex:(NSInteger)cellIndex withData:(CustomTableViewCell*)data
{
    self.customCell = data;

    
    ObjectForTableCell* tmp =[self.dataDictionary objectForKey:self.names[cellIndex]];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:tmp.imeageURL]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:60.0];
//    self.connectionManager = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
     NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
}

//-(UIImage *) getImageFromURL:(NSString *)fileURL
//{
//    UIImage * result;
//    
//    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
//    result = [UIImage imageWithData:data];
//    
//    return result;
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //cell.selectedBackgroundView = [[UIImageView alloc] init] ;
    //UIImage *img  = [UIImage imageNamed:@"toyota_venza.jpg"];
    //((UIImageView *)cell.selectedBackgroundView).image = img;
}
    
    @end
