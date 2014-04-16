//
//  GOLDTask.h
//  Git
//
//  Created by Christoffer Winterkvist on 15/04/14.
//
//

#import <Foundation/Foundation.h>

@interface GOLDTask : NSObject

+ (NSString *)runCommand:(NSString *)commandPath withArguments:(NSArray *)arguments inDirectory:(NSString *)directory;

@end
