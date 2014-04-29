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

- (void)executeWithConfiguration:(NSDictionary *)configuration
{
    NSString *gitPath = @"/usr/bin/git";
    NSArray *arguments;
    NSString *author;
    NSString *commits;
    NSMutableArray *entries = [[NSMutableArray alloc] init];

    BOOL configIsEnabled = [configuration[@"enabled"] boolValue];

    if (configIsEnabled) {
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
    }

    self.dataCache = [entries copy];
}

- (NSView *)mainView:(NSObject<GOLDDataEntry> *)entry
{
    NSView *mainView = [[NSView alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss ZZZZ"];

    NSTextField *summaryField = [[NSTextField alloc] initWithFrame:NSMakeRect(5, 22, 200, 17)];
    [summaryField setStringValue:entry.title];
    [summaryField setBezeled:NO];
    [summaryField setDrawsBackground:NO];
    [summaryField setEditable:NO];
    [summaryField setSelectable:NO];
    [summaryField setFont:[NSFont systemFontOfSize:13]];
    [summaryField setAutoresizingMask:NSViewWidthSizable];

    NSTextField *dateField = [[NSTextField alloc] initWithFrame:NSMakeRect(5, 2, 200, 17)];
    [dateField setStringValue:[dateFormat stringFromDate:entry.startDate]];
    [dateField setBezeled:NO];
    [dateField setDrawsBackground:NO];
    [dateField setEditable:NO];
    [dateField setSelectable:NO];
    [dateField setFont:[NSFont systemFontOfSize:10]];
    [dateField setAutoresizingMask:NSViewWidthSizable];

    [mainView addSubview:summaryField];
    [mainView addSubview:dateField];

    return mainView;
}

- (NSView *)preferenceView
{
    NSView *preferenceView = [[NSView alloc] initWithFrame:NSMakeRect(320,200,0,0)];
    return preferenceView;
}

@end
