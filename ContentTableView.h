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
#import "MyOperationQueue.h"
#import "ObjectForTableCell.h"
#import "ImageViewController.h"
#import "DataSourse.h"

@interface ContentTableView : UITableViewController<CellDelegate, NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property(strong, nonatomic) DataSourse* source;
//@property(strong, nonatomic) NSMutableDictionary* dataDictionary;
//@property(strong, nonatomic) NSMutableArray* names;
//@property(strong, nonatomic) NSMutableSet* tagsOfCells;
-(void)updatePage;
//+ (instancetype)sharedManager;

@end
