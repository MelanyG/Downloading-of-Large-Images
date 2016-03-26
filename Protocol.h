//
//  Protocol.h
//  Downloading
//
//  Created by Melany Gulianovych on 3/26/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#ifndef Protocol_h
#define Protocol_h




#endif /* Protocol_h */
#import "CustomTableViewCell.h"

@protocol CellDelegate <NSObject>

@required

- (void)didClickStartAtIndex:(NSInteger)cellIndex withData:(id)data;


@end