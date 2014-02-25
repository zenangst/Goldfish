//
//  HYPPlugInsLoader.m
//  Hyper Active
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Christoffer Winterkvist. All rights reserved.
//

#import "HYPPlugInsLoader.h"
#import "HYPPlugInsController.h"
#import "HYPPlugIn.h"

static NSString * const kHyperFileExtension = @"bundle";

@implementation HYPPlugInsLoader

@synthesize loadedPlugIns;

+ (instancetype)sharedLoader
{
   static id sharedInstance = nil;

   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      sharedInstance = [[self alloc] init];
   });

   return sharedInstance;
}

- (void)loadPlugIns
{
  NSString *builtInPluginsPath = [[NSBundle mainBundle] builtInPlugInsPath];
  NSMutableArray *plugInsArray = [[NSMutableArray alloc] init];
  NSArray *builtInPlugIns = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:builtInPluginsPath error:nil];
  NSBundle *bundle;
  Class plugInClassName;
  NSObject <HYPPlugIn> *plugIn;

  for (NSString *filename in builtInPlugIns) {
    bundle = [NSBundle bundleWithPath:[NSString stringWithFormat:@"%@/%@", builtInPluginsPath, filename]];
    if ([bundle load]) {
      plugInClassName = [bundle principalClass];
      plugIn = [[plugInClassName alloc] init];
      [plugInsArray addObject:plugIn];
    }
  }

  if (self.loadedPlugIns) {
    self.loadedPlugIns = nil;
  }
  self.loadedPlugIns = [[NSSet alloc] initWithArray:plugInsArray];
  plugInsArray = nil;
  
  NSLog(@"loadedPlugIns: %@", loadedPlugIns);  
}

- (void)configurePlugIns
{
	
}

- (void)runPlugIns
{
  
}

- (NSURL *)applicationDirectory
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
  return [appSupportURL URLByAppendingPathComponent:@"com.zenangst.Keyboard_Cowboy_2"];
}

@end
