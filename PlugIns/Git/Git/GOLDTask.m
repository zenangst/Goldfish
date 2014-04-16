//
//  GOLDTask.m
//  Git
//
//  Created by Christoffer Winterkvist on 15/04/14.
//
//

#import "GOLDTask.h"

@implementation GOLDTask

+ (NSString *)runCommand:(NSString *)commandPath withArguments:(NSArray *)arguments inDirectory:(NSString *)directory
{
    NSTask *task = [[NSTask alloc] init];
    NSPipe *pipe = [NSPipe pipe];

    task.launchPath = commandPath;
    if (directory) {
        task.currentDirectoryPath = directory;
    }
    task.arguments = arguments;
    task.standardOutput = pipe;

    [task launch];

    NSData *data = [[pipe fileHandleForReading] readDataToEndOfFile];

    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return output;
}

@end
