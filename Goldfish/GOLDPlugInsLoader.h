//
//  GOLDPlugInsLoader.h
//  Goldfish
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Christoffer Winterkvist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GOLDPlugInsLoader : NSObject

@property (nonatomic, retain) NSDictionary *loadedPlugIns;

- (void)loadPlugIns;
- (void)drawViews;
- (void)executePlugIns;
- (void)executePlugInWithName:(NSString *)plugInName;
- (NSURL *)applicationDirectory;

@end
