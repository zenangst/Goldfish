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

- (BOOL)conformsToPlugInProtocol
{
    // TODO Improve by parsing protocol selectors at runtime
    NSArray *arraySelectors = @[
        @"initWithPlugInsController:", @"name", @"configurations",
        @"executeWithConfiguration:",
        @"bundleIdentifier", @"setBundleIdentifier:",
        @"dataCache"
    ];

    return [self conformsToProtocol:NSProtocolFromString(@"GOLDPlugIn")
                 requiringSelectors:arraySelectors];
}

- (BOOL)conformsToDataEntryProtocol
{
    NSArray *arraySelectors = @[
        @"name",
        @"datestamp",
        @"plugIn"
    ];

    return [self conformsToProtocol:NSProtocolFromString(@"GOLDDataEntry")
                 requiringSelectors:arraySelectors];
}

- (BOOL)conformsToProtocol:(Protocol *)protocol requiringSelectors:(NSArray *)selectors
{
    if (![self conformsToProtocol:protocol]) {
        return NO;
    }

    __block id plugInTest = [[self class] new];
    __block BOOL validates = YES;

    [selectors enumerateObjectsUsingBlock:^(NSString *selectorString, NSUInteger idx, BOOL *stop) {
        BOOL plugInValidates = [plugInTest respondsToSelector:NSSelectorFromString(selectorString)];
        if (!plugInValidates) {
            [NSException raise:@"PROTOCOL_VALIDATION_FAILED" format:@"%@ does not respond to selector(%@)", [plugInTest class], selectorString];
            validates = NO;
            *stop = YES;
        }
    }];

    plugInTest = nil;

    return validates;
}

@end
