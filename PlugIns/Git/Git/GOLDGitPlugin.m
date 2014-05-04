//
//  GOLDGitPlugin.m
//  Git
//
//  Created by Christoffer Winterkvist on 25/02/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import "GOLDGitPlugin.h"
#import "GOLDTask.h"
#import "GOLDGitDataEntry.h"

@implementation GOLDGitPlugin

@synthesize plugInsController, bundleIdentifier;

- (id)initWithPlugInsController:(GOLDPlugInsController *)aPlugInsController {
    self = [super init];
    if (self) {
        self.plugInsController = aPlugInsController;
    }
    return self;
}

- (NSString *)name
{
    return @"Git";
}

- (NSColor *)color
{
    return [NSColor colorWithCalibratedRed:0.902 green:0.725 blue:0.616 alpha:1];
}

- (NSArray *)configurations
{
    return @[
        @{
            @"enabled": @YES,
            @"name"   : @"Goldfish",
            @"path"   : [[NSProcessInfo processInfo] environment][@"XCODE_ROOT"]
        }
    ];
}

- (NSArray *)executeWithConfiguration:(NSDictionary *)configuration
{
    NSString *gitPath = @"/usr/bin/git";
    NSArray *arguments;
    NSString *author;
    NSString *commits;

    BOOL configurationIsEnabled = [configuration[@"enabled"] boolValue];

    if (configurationIsEnabled) {
        __block NSMutableArray *entries = [[NSMutableArray alloc] init];

        author = [[GOLDTask runCommand:gitPath withArguments:@[@"config", @"--get", @"user.name"] inDirectory:configuration[@"path"]] stringByReplacingOccurrencesOfString:@"\n" withString:@""];

        arguments  = @[
            @"log",
            @"--all",
            @"--no-merges",
            [NSString stringWithFormat:@"--author=%@", author],
            [NSString stringWithFormat:@"--format=%@", @"%h %ai %s"]
        ];

        commits = [GOLDTask runCommand:gitPath withArguments:arguments inDirectory:configuration[@"path"]];
        NSArray *lines = [commits componentsSeparatedByString:@"\n"];

        [lines enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {
            if ([line length]) {
                GOLDGitDataEntry *dataEntry = [[GOLDGitDataEntry alloc] init];
                dataEntry.plugInName = self.name;
                dataEntry.commit = [line substringToIndex:7];
                dataEntry.startDate = [NSDate dateWithString:[line substringWithRange:NSMakeRange(8, 25)]];
                dataEntry.title = [line substringFromIndex:34];
                [entries addObject:dataEntry];
            }
        }];
        return [entries copy];
    }
    return nil;
}

- (NSView *)preferenceView
{
    NSView *preferenceView = [[NSView alloc] initWithFrame:NSMakeRect(320,200,0,0)];
    return preferenceView;
}

@end
