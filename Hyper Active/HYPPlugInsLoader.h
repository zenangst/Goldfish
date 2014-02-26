//
//  HYPPlugInsLoader.h
//  Hyper Active
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Christoffer Winterkvist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYPPlugInsLoader : NSObject

@property (nonatomic, retain) NSDictionary *loadedPlugIns;

- (void)loadPlugIns;
- (void)drawViews;
- (void)executePlugIns;
- (void)exectuePlugInWithName:(NSString *)plugInName;
- (NSURL *)applicationDirectory;

@end
