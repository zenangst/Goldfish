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
- (id)initWithPlugInsController:(GOLDPlugInsController *)plugInsController;
- (NSString *)name;
- (void)execute;

@optional
- (NSView *)mainView;
- (NSView *)preferenceView;

@end
