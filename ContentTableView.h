//
//  ContentTableView.h
//  Downloading
//
//  Created by Melany Gulianovych on 3/26/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"
#import "Protocol.h"

@interface ContentTableView : UITableViewController<CellDelegate, NSURLConnectionDataDelegate>

@end