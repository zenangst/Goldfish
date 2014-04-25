//
//  GOLDGitPlugin.m
//  Git
//
//  Created by Christoffer Winterkvist on 25/02/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import "GOLDGitPlugin.h"
#import "GOLDTask.h"

@implementation GOLDGitPlugin

@synthesize plugInsController, bundleIdentifier;

- (id)initWithPlugInsController:(GOLDPlugInsController *)aPlugInsController {
    self = [super init];
    if (self) {
        self.plugInsController = aPlugInsController;
        self.dataCache = nil;
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
    NSDictionary *env = [[NSProcessInfo processInfo] environment];
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
                NSDictionary *entryDictionary = @{
                    @"plugIn"    : self.name,
                    @"commit"    : [line substringToIndex:7],
                    @"datestamp" : [line substringWithRange:NSMakeRange(8, 25)],
                    @"name"      : [line substringFromIndex:34]
                };
                [entries addObject:entryDictionary];
            }
        }];
    }

    self.dataCache = [entries copy];
    entries = nil;
}

- (NSView *)mainView:(NSDictionary *)entry isRowSelected:(BOOL)rowIsSelected
{
    NSView *mainView = [[NSView alloc] init];

    NSTextField *summaryField = [[NSTextField alloc] initWithFrame:NSMakeRect(5, 22, 200, 17)];
    [summaryField setStringValue:entry[@"name"]];
    [summaryField setBezeled:NO];
    [summaryField setDrawsBackground:NO];
    [summaryField setEditable:NO];
    [summaryField setSelectable:NO];
    [summaryField setFont:[NSFont systemFontOfSize:13]];
    [summaryField setAutoresizingMask:NSViewWidthSizable];

    if (rowIsSelected) {
        /* [summaryField ] */
    }

    NSTextField *dateField = [[NSTextField alloc] initWithFrame:NSMakeRect(5, 2, 200, 17)];
    [dateField setStringValue:entry[@"datestamp"]];
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
