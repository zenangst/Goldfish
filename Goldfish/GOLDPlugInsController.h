//
//  GOLDPlugInsController.h
//  Goldfish
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Christoffer Winterkvist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GOLDPlugInsController : NSObject

+ (instancetype)sharedPlugInsController;

- (NSString *)goldfishVersion;
- (NSUInteger)apiVersion;

@end
