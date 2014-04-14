//
//  GOLDAppDelegate.h
//  Goldfish
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GOLDWindow.h"
#import "GOLDPreferencesController.h"

@interface GOLDAppDelegate : NSApplication <NSApplicationDelegate>

@property (strong, nonatomic) GOLDWindow *preferencesWindow;
@property (strong, nonatomic) GOLDWindow *window;

@end
