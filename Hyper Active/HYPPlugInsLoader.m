//
//  HYPPlugInsLoader.m
//  Hyper Active
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Christoffer Winterkvist. All rights reserved.
//

#import "HYPPlugInsLoader.h"
#import "HYPPlugInsController.h"

@implementation HYPPlugInsLoader

+ (instancetype)sharedLoader
{
   static id sharedInstance = nil;

   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      sharedInstance = [[self alloc] init];
   });

   return sharedInstance;
}

- (id)init 
{
	self = [super init];
	if (self) {
		
	}
	return self;
}

@end
