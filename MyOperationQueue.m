//
//  MyOperationQueue.m
//  Downloading
//
//  Created by Melany Gulianovych on 3/29/16.
//  Copyright © 2016 Melany Gulianovych. All rights reserved.
//

#import "MyOperationQueue.h"

@implementation MyOperationQueue

- (void)main
{
    if ([self isCancelled])
    {
        NSLog(@"** operation cancelled **");
    }
    
    // Do some work here
    NSLog(@"Working... working....");
    
    if ([self isCancelled])
    {
        NSLog(@"** operation cancelled **");
    }
    // Do any clean-up work here...
    
    // If you need to update some UI when the operation is complete, do this:
    [self performSelectorOnMainThread:@selector(updateButton) withObject:nil waitUntilDone:NO];
    
    NSLog(@"Operation finished");
}

- (void)updateButton
{
    // Update the button here
}


@end
