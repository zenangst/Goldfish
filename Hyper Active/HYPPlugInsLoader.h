//
//  HYPPlugInsLoader.h
//  Hyper Active
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Christoffer Winterkvist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYPPlugInsLoader : NSObject

@property (nonatomic, retain) NSSet *loadedPlugIns;

+ (instancetype)sharedLoader;
- (void)loadPlugIns;
- (void)runPlugIns;
- (NSURL *)applicationDirectory;

@end
