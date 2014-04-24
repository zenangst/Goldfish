//
//  NSObject+ProtocolValidation.h
//  Goldfish
//
//  Created by Christoffer Winterkvist on 4/24/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ProtocolValidation)

- (BOOL)conformsToPlugInProtocol:(Protocol *)protocol;

@end
