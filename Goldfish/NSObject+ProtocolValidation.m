//
//  NSObject+ProtocolValidation.m
//  Goldfish
//
//  Created by Christoffer Winterkvist on 4/24/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import "NSObject+ProtocolValidation.h"
#import "GOLDProtocols.h"

@implementation NSObject (ProtocolValidation)

- (BOOL)conformsToPlugInProtocol {
    Protocol *protocol = NSProtocolFromString(@"GOLDPlugIn");
    if (![self conformsToProtocol:protocol]) {
        return NO;
    }

    NSArray *requiredSelectors = @[
        @"initWithPlugInsController:", @"name", @"configurations",
        @"executeWithConfiguration:",
        @"bundleIdentifier", @"setBundleIdentifier:",
        @"dataCache"
    ];

    __block id plugInTest = [[self class] new];
    __block BOOL validates = YES;
    [requiredSelectors enumerateObjectsUsingBlock:^(NSString *selectorString, NSUInteger idx, BOOL *stop) {
        if (![plugInTest respondsToSelector:NSSelectorFromString(selectorString)]) {
            NSLog(@"class: %@ failed on : %@", [plugInTest class], selectorString);
            validates = NO;
            stop = YES;
        }
    }];

    plugInTest = nil;
    return validates;
}

@end
