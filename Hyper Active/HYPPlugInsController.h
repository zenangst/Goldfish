//
//  HYPPlugInsController.h
//  Hyper Active
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Christoffer Winterkvist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HYPPlugInsController : NSObject

- (NSString *)hyperActiveVersion;
- (NSUInteger)apiVersion;
- (NSString *)pluginKey;

@end
