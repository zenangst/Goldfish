//
//  Protocols.h
//  Goldfish
//
//  Created by Christoffer Winterkvist on 3/9/17.
//  Copyright © 2017 Christoffer Winterkvist. All rights reserved.
//

#ifndef Protocols_h
#define Protocols_h

@import Cocoa;

@protocol Plugin <NSObject>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *version;
@property (nonatomic, readonly) NSViewController *controller;

- (void)pluginDidLoad;

@end

#endif /* Protocols_h */
