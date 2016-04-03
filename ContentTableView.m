//
//  ContentTableView.m
//  Downloading
//
//  Created by Melany Gulianovych on 3/26/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import "ContentTableView.h"

@interface ContentTableView ()

@property(assign, nonatomic) NSInteger selectedCell;
@property (nonatomic, strong) NSOperationQueue* queue;

@end

@implementation ContentTableView


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.queue = [[NSOperationQueue alloc] init];
    self.queue.name = @"Background Queue";
    
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(updatePage)
               name:LoadImagesNotification
             object:nil];
    
    UIColor *bg = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setBarTintColor:bg];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"Zapfino" size:20.0f],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.source = [DataSourse sharedManager];
}

#pragma mark - Navigation with Segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ImageVC"])
    {
        ImageViewController * ivc = segue.destinationViewController;
        ivc.myTemporaryImage = [[self.source.dataDictionary objectForKey:self.source.names[self.selectedCell]] downloadedImage];
    }
}

#pragma mark - Notification

-(void)updatePage
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.source.names count];
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
    UIImage *img = [UIImage imageNamed:@"placeholder"];
    if (![self.source.tagsOfCells containsObject:myNum])
    {
        customCell.realProgressStatus.text = @"";
        customCell.progressView.progress = 0.1;
        customCell.image.image = img;
        customCell.startButton.enabled = YES;
        [customCell setNeedsLayout];
    }
    else
    {
        if([[self.source.dataDictionary objectForKey:self.source.names[indexPath.row]] progressData] == 1.0f)
        {
            [[self.source.dataDictionary objectForKey:self.source.names[indexPath.row]] setCurrentQueue:nil];
            
            customCell.image.image = [[self.source.dataDictionary objectForKey:self.source.names[indexPath.row]] downloadedImage];
            customCell.realProgressStatus.text = [[self.source.dataDictionary objectForKey:self.source.names[indexPath.row]] realProgressViewStatus];
            customCell.progressView.progress = [[self.source.dataDictionary objectForKey:self.source.names[indexPath.row]] progressData];
            customCell.startButton.enabled = YES;
        }
        else
        {
            customCell.image.image = img;
            customCell.realProgressStatus.text = [[self.source.dataDictionary objectForKey:self.source.names[indexPath.row]] realProgressViewStatus];
            customCell.progressView.progress = [[self.source.dataDictionary objectForKey:self.source.names[indexPath.row]] progressData];
        }
    }
    customCell.delegate = self;
    customCell.cellIndex = indexPath.row;
    customCell.nameOfImage.text = self.source.names[indexPath.row];
    if ( indexPath.row % 2 == 0 )
        customCell.backgroundColor = [UIColor grayColor];
    else
        customCell.backgroundColor = [UIColor darkGrayColor];
    return customCell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCell = indexPath.row;
    if ([[self.source.dataDictionary objectForKey:self.source.names[self.selectedCell]]downloadedImage])
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
    ObjectForTableCell* tmp =[self.source.dataDictionary objectForKey:self.source.names[cellIndex]];
    NSURL *url = [NSURL URLWithString: tmp.imeageURL];
    
    MyOperationQueue * one = [[MyOperationQueue alloc]initWithURL:url andRaw:cellIndex];
    
    [self.queue addOperation:one];
    [[self.source.dataDictionary objectForKey:self.source.names[cellIndex]] setCurrentQueue:one];
    
}

- (void)didClickStopAtIndex:(NSInteger)cellIndex withData:(id)data
{
    if([[self.source.dataDictionary objectForKey:self.source.names[cellIndex]] progressData] == 1.0f)
    {
        [[self.source.dataDictionary objectForKey:self.source.names[cellIndex]] setRealProgressViewStatus:@""];
        [[self.source.dataDictionary objectForKey:self.source.names[cellIndex]] setProgressData:0.1f];
    }
    UIImage *img = [UIImage imageNamed:@"placeholder"];
    [[self.source.dataDictionary objectForKey:self.source.names[cellIndex]] setDownloadedImage:img];
    [[[self.source.dataDictionary objectForKey:self.source.names[cellIndex]] currentQueue] cancel];
    [self.tableView reloadData];
}

@end
