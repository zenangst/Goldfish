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
@property (nonatomic, retain) NSArray *dataCache;

- (id)initWithPlugInsController:(GOLDPlugInsController *)plugInsController;
- (NSString *)name;
- (NSArray *)configurations;
- (void)executeWithConfiguration:(NSDictionary *)configuration;

@optional
+ (BOOL)hasConfiguration;
+ (BOOL)singleton;
- (NSView *)mainView:(NSDictionary *)entry isRowSelected:(BOOL)rowIsSelected;
- (NSView *)preferenceView;

@end

@protocol GOLDDataEntry

@required

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDate *datestamp;

@end
