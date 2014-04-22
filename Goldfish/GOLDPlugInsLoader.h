//
//  GOLDPlugInsLoader.h
//  Goldfish
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface GOLDPlugInsLoader : NSObject

@property (nonatomic, retain) NSDictionary *loadedPlugIns;

+ (instancetype)sharedLoader;

- (void)loadPlugIns;
- (NSURL *)applicationDirectory;

@end
