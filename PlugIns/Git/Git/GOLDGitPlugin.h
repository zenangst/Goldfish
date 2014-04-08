//
//  GOLDGitPlugin.h
//  Git
//
//  Created by Christoffer Winterkvist on 25/02/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GOLDPlugInsController.h"

@interface GOLDGitPlugin : NSObject

@property (nonatomic, retain) GOLDPlugInsController *plugInsController;

- (id)initWithPlugInsController:(GOLDPlugInsController *)hyperPlugInsController;
- (NSString *)name;
- (void)execute;

@end
