//
//  GOLDMainViewController.h
//  Goldfish
//
//  Created by Christoffer Winterkvist on 16/04/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GOLDWindow.h"

@interface GOLDMainViewController : NSObject <NSSplitViewDelegate, NSTableViewDelegate, NSTableViewDataSource, NSWindowDelegate>

@property (strong, nonatomic) NSWindowController *windowController;
@property (strong, nonatomic) GOLDWindow *window;
@property (strong, nonatomic) NSSplitView *splitView;
@property (strong, nonatomic) NSTableView *tableView;
@property (strong, nonatomic) NSView *previewView;

@property (strong, nonatomic) NSArray *dataSource;

- (void)showWindow;

@end
