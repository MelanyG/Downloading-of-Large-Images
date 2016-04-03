//
//  CustomTableViewCell.m
//  Downloading
//
//  Created by Melany Gulianovych on 3/26/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)buttonClicked:(UIButton *)sender;
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickStartAtIndex:withData:)])
    {
        [self.delegate didClickStartAtIndex:self.cellIndex withData:self];
        
    }
    self.startButton.enabled = NO;
}


- (IBAction)stopDownloading:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickStopAtIndex:withData:)])
    {
        [self.delegate didClickStopAtIndex:self.cellIndex withData:self];
    }
    self.startButton.enabled = YES;
}
@end
