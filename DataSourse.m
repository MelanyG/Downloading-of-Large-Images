//
//  DataSourse.m
//  Downloading
//
//  Created by Melany Gulianovych on 3/31/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import "DataSourse.h"

@implementation DataSourse

+ (instancetype)sharedManager
{
    static DataSourse *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DataSourse alloc] init];
        
    });
    return instance;
}

- (id) init
{
    self.dataDictionary = [[NSMutableDictionary alloc]init];
    self.tagsOfCells = [[NSMutableSet alloc]init];
    self.names = [[NSMutableArray alloc]initWithObjects:@"Snow Tiger", @"Elephant", @"Sunset",@"Nature silence",@"Tree",@"White tiger",@"Waterfall",@"Owl",@"Fairytail",@"End of space",@"House", @"Beauty Nature",@"Green Water", @"Wooden road", @"Beach", @"Color nature", @"Autumn nature", @"New year", @"Christmas tree", @"Christmas", nil];
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
    return self;
}

@end
