//
//  HYPGitPlugin.h
//  Git
//
//  Created by Christoffer Winterkvist on 25/02/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HYPPlugInsController.h"

@interface HYPGitPlugin : NSObject

@property (nonatomic, retain) HYPPlugInsController *plugInsController;

- (id)initWithPlugInsController:(HYPPlugInsController *)hyperPlugInsController;
- (NSString *)name;

@end
