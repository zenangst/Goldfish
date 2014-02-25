//
//  HYPPlugin.h
//  Hyper Active
//
//  Created by Christoffer Winterkvist on 23/02/14.
//  Copyright (c) 2014 Christoffer Winterkvist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYPPlugInsController.h"

@protocol HYPPlugIn <NSObject>

- (NSString *)name;
- (id)initWithPlugInsController:(HYPPlugInsController *)plugInsController;

@optional

- (NSView *)mainView;
- (NSView *)preferenceView;

@end
