//
//  HYPCalendarPlugin.h
//  Calendar.waddup
//
//  Created by Christoffer Winterkvist on 23/02/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HYPPlugInsController.h"

@interface HYPCalendarPlugin : NSObject

@property (nonatomic, retain) HYPPlugInsController *plugInsController;

- (id)initWithPlugInsController:(HYPPlugInsController *)hyperPlugInsController;
- (NSString *)name;

@end
