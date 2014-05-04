//
//  GOLDGitPlugin.h
//  Git
//
//  Created by Christoffer Winterkvist on 25/02/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GOLDPlugInsController.h"
#import "GOLDProtocols.h"

@interface GOLDGitPlugin : NSObject <GOLDPlugIn>

@property (nonatomic, retain) GOLDPlugInsController *plugInsController;
@property (nonatomic, retain) NSString *bundleIdentifier;

- (NSView *)preferenceView;

@end
