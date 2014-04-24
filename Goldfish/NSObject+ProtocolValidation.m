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
    NSArray *arraySelectors = @[
        @"initWithPlugInsController:", @"name", @"configurations",
        @"executeWithConfiguration:",
        @"bundleIdentifier", @"setBundleIdentifier:",
        @"dataCache"
    ];

    return [self conformsToProtocol:NSProtocolFromString(@"GOLDPlugIn")
                  requiredSelectors:arraySelectors];
}

- (BOOL)conformsToDataEntryProtocol
{
    NSArray *arraySelectors = @[
        @"name", @"setName:",
        @"datestamp", @"setDatestamp:"
    ];

    return [self conformsToProtocol:NSProtocolFromString(@"GOLDDataEntry")
                  requiredSelectors:arraySelectors];
}

- (BOOL)conformsToProtocol:(Protocol *)protocol requiredSelectors:(NSArray *)selectors
{
    if (![self conformsToProtocol:protocol]) {
        return NO;
    }

    __block id plugInTest = [[self class] new];
    __block BOOL validates = YES;
    [selectors enumerateObjectsUsingBlock:^(NSString *selectorString, NSUInteger idx, BOOL *stop) {
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
