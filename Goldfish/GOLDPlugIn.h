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

- (NSString *)name;
- (id)initWithPlugInsController:(GOLDPlugInsController *)plugInsController;
- (void)execute;

@optional

- (NSView *)mainView;
- (NSView *)preferenceView;

@end
