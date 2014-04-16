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

+ (BOOL)hasConfiguration
{
	return YES;
}

- (id)initWithPlugInsController:(GOLDPlugInsController *)aPlugInsController {
    self = [super init];
	if (self) {
		self.plugInsController = aPlugInsController;
        self.dataCache = nil;
        NSLog(@"%@: loaded", [self name]);
	}
	return self;
}

- (NSString *)name
{
	return @"Git";
}

- (void)execute
{
    NSArray *configurations = @[
        @{@"enabled": @YES,
          @"name"   : @"Goldfish",
          @"path"   : @"/Users/christofferwinterkvist/Library/Mobile Documents/iCloud/Developer/Cocoa/Goldfish/Goldfish"
        }
    ];

    __block NSString *gitPath = @"/usr/bin/git";
    __block NSArray *arguments;
    __block NSString *author;
    __block NSString *commits;
    __block NSMutableArray *entries = [[NSMutableArray alloc] init];
    __block NSArray *indexFields = @[@"commit", @"datestamp", @"summary"];

    [configurations enumerateObjectsUsingBlock:^(NSDictionary *configuration, NSUInteger idx, BOOL *stop) {
        BOOL configIsEnabled = [configuration[@"enabled"] boolValue];

        if (configIsEnabled) {
            author = [[GOLDTask runCommand:gitPath withArguments:@[@"config", @"--get", @"user.name"] inDirectory:configuration[@"path"]] stringByReplacingOccurrencesOfString:@"\n" withString:@""];

            arguments  = @[
                @"log",
                @"--all",
                @"--no-merges",
                [NSString stringWithFormat:@"--author=%@", author],
                [NSString stringWithFormat:@"--format=%@", @"%h -> %ai -> %s"]
            ];

            commits = [GOLDTask runCommand:gitPath withArguments:arguments inDirectory:configuration[@"path"]];
            NSArray *lines = [commits componentsSeparatedByString:@"\n"];

            [lines enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {
                if ([line length]) {
                    NSArray *components = [line componentsSeparatedByString:@"->"];
                    __block NSMutableDictionary *mdict = [[NSMutableDictionary alloc] init];

                    [components enumerateObjectsUsingBlock:^(NSString *component, NSUInteger idx, BOOL *stop) {
                        [mdict setObject:[component stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:indexFields[idx]];
                    }];

                    [entries addObject:[mdict copy]];
                    mdict = nil;
                }
            }];
        }
    }];

    if (self.dataCache) {
        self.dataCache = nil;
    }

    self.dataCache = [entries copy];
    entries = nil;
}

- (NSView *)mainView
{
    NSView *mainView = [[NSView alloc] initWithFrame:NSMakeRect(320,200,20,20)];
    CALayer *viewLayer = [CALayer layer];
    CGColorRef backgroundColor = CGColorCreateGenericRGB(1.0, 0.0, 0.0, 0.4);
    [viewLayer setBackgroundColor:backgroundColor];
    [mainView setWantsLayer:YES];
    [mainView setLayer:viewLayer];
    CGColorRelease(backgroundColor);
    return mainView;
}

- (NSView *)preferenceView
{
    NSView *preferenceView = [[NSView alloc] initWithFrame:NSMakeRect(320,200,0,0)];
    return preferenceView;
}

@end
