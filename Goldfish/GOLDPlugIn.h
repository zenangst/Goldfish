//
//  GOLDPlugin.h
//  Goldfish
//
//  Created by Christoffer Winterkvist on 23/02/14.
//  Copyright (c) 2014 Christoffer Winterkvist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GOLDPlugInsController.h"

@protocol GOLDPlugIn <NSObject>

@required

@property (nonatomic, retain) NSString *bundleIdentifier;

- (id)initWithPlugInsController:(GOLDPlugInsController *)plugInsController;
- (NSString *)name;
- (void)execute;

@optional
+ (BOOL)hasConfiguration;
- (NSView *)mainView;
- (NSView *)preferenceView;

@end
