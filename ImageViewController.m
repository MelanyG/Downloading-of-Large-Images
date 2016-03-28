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
//self.imageView = [[UIImageView alloc] initWithImage:self.myTemporaryImage];
    //self.imageView.image = self.imageView.image;
    [self.imageView setImage:self.myTemporaryImage];
}



@end
