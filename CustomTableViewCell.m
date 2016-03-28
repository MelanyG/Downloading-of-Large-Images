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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonClicked:(UIButton *)sender;
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickStartAtIndex:withData:)])
    {
        [self.delegate didClickStartAtIndex:self.cellIndex withData:self];
      
    }


}

//-(void)prepareForReuse
//{
//    [super prepareForReuse];
//    
//    self.progressView.progress = 0.1;
//    self.realProgressStatus.text = @"";
//    self.image.image = [UIImage imageNamed:@"placeholder"];
//}

- (IBAction)stopDownloading:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickStopAtIndex:withData:)])
    {
        [self.delegate didClickStopAtIndex:self.cellIndex withData:self];
    }

}
@end
