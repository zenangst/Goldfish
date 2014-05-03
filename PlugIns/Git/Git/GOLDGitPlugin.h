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

- (id)initWithPlugInsController:(GOLDPlugInsController *)aPlugInsController;
- (NSString *)name;
- (NSDictionary *)color;
- (NSArray *)executeWithConfiguration:(NSDictionary *)configuration;
- (NSView *)preferenceView;

@end
