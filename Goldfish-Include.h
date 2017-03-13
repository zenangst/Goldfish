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

@property (nonatomic, copy, readonly) NSString * _Nonnull name;
@property (nonatomic, copy, readonly) NSString * _Nonnull version;
@property (nonatomic, readonly) NSViewController * _Nullable controller;

- (void)pluginDidLoad;
- (void)pluginDidAppear;

@end

#endif /* Protocols_h */
