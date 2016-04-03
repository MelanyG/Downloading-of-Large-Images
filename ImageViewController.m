//
//  ImageViewController.m
//  Downloading
//
//  Created by Melany Gulianovych on 3/26/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import "ImageViewController.h"

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"IMAGE";
   
    [self.imageView setImage:self.myTemporaryImage];
}



@end
