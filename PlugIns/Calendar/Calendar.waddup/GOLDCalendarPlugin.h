//
//  GOLDCalendarPlugin.h
//  Calendar.waddup
//
//  Created by Christoffer Winterkvist on 23/02/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GOLDPlugInsController.h"

@interface GOLDCalendarPlugin : NSObject

@property (nonatomic, retain) GOLDPlugInsController *plugInsController;

- (id)initWithPlugInsController:(GOLDPlugInsController *)hyperPlugInsController;
- (NSString *)name;

@end
