//
//  GOLDProtocols.h
//  Goldfish
//
//  Created by Christoffer Winterkvist on 23/02/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GOLDPlugInsController.h"

@protocol GOLDPlugIn <NSObject>

@required

@property (nonatomic, retain) NSString *bundleIdentifier;

- (id)initWithPlugInsController:(GOLDPlugInsController *)plugInsController;
- (NSString *)name;
- (NSArray *)configurations;
- (NSArray *)executeWithConfiguration:(NSDictionary *)configuration;

@optional

+ (BOOL)singleton;
- (NSTableCellView *)mainView:(NSDictionary *)entry;
- (NSView *)preferenceView;
- (NSColor *)color;

@end

@protocol GOLDDataEntry <NSObject>

@required

@property (nonatomic, retain) NSString *plugInName;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *startDate;

@optional

@property (nonatomic, retain) NSDate *endDate;

@end
