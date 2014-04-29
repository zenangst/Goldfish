//
//  GOLDMainViewController.m
//  Goldfish
//
//  Created by Christoffer Winterkvist on 16/04/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import "GOLDMainViewController.h"
#import "GOLDPlugInsLoader.h"
#import "GOLDProtocols.h"
#import "NSObject+ProtocolValidation.h"

static const float kTableViewMinWidth = 150.0f;
static const float kTableViewMaxWidth = 350.0f;

@implementation GOLDMainViewController

// TODO Split into multiple files and use delegates

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureGrandCentralDispatch];
        [self configureInterface];
    }
    return self;
}

- (void)showWindow
{
    [NSApp activateIgnoringOtherApps:YES];
    [self.windowController showWindow:self];
}

#pragma mark Grand Central dispatch

- (void)configureGrandCentralDispatch
{
	self.plugInQueue = dispatch_queue_create("plugInDispatch", DISPATCH_QUEUE_SERIAL);
}

#pragma mark Interface construction

- (void)configureInterface
{
    NSRect frame = NSMakeRect(0, 0, 320, 240);

    self.window = [[GOLDWindow alloc] initWithContentRect:frame];
    self.windowController = [[NSWindowController alloc] initWithWindow:self.window];

    [self.windowController loadWindow];
    [self.windowController setWindowFrameAutosaveName:@"MainWindowFrame"];

    [self.window setWindowController:self.windowController];
    [self.window setTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"]];
    [self.window setFrameAutosaveName:@"MainFrame"];
    [self.window setDelegate:self];

    NSRect splitViewFrame = NSMakeRect(0, 0, CGRectGetWidth([[self.window contentView] frame]), CGRectGetHeight([[self.window contentView] frame]));
    NSSplitView *splitView = [[NSSplitView alloc] initWithFrame:splitViewFrame];
    [splitView setAutosaveName:@"MainSplitView"];
    [splitView setIdentifier:@"MainSplitView"];
    [splitView setVertical:YES];
    [splitView setDelegate:self];
    [splitView setDividerStyle:NSSplitViewDividerStylePaneSplitter];
    [splitView setAutoresizesSubviews:YES];

    NSScrollView *scrollView = [[NSScrollView alloc] init];
    [scrollView setHasVerticalScroller:YES];
    [scrollView setHasHorizontalScroller:YES];
    [scrollView setAutoresizesSubviews:YES];
    [scrollView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView setAcceptsTouchEvents:YES];

    self.tableView = [[NSTableView alloc] init];
    [self.tableView setAutosaveName:@"HistoryView"];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setAllowsEmptySelection:NO];
    [self.tableView setRowHeight:32.0f];
    [self.tableView setHeaderView:nil];
    [self.tableView setUsesAlternatingRowBackgroundColors:YES];
    [self.tableView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];

    NSTableColumn *column = [[NSTableColumn alloc] init];
    [column setEditable:NO];
    [column setIdentifier:@"Column"];
    [self.tableView addTableColumn:column];

    NSClipView *clipView = [[NSClipView alloc] init];
    [clipView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [clipView setAutoresizesSubviews:YES];
    [clipView setDocumentView:self.tableView];
    [clipView setBounds:[scrollView frame]];

    [scrollView setContentView:clipView];
    [[scrollView contentView] setCopiesOnScroll:NO];
    [[scrollView contentView] setDrawsBackground:NO];
    [scrollView setDrawsBackground:NO];

    self.previewView = [[NSView alloc] init];
    CGColorRef backgroundColor = CGColorCreateGenericRGB(1.0, 1.0, 0.0, 0.4);
    CALayer *viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor:backgroundColor];
    [self.previewView setWantsLayer:YES];
    [self.previewView setLayer:viewLayer];
    CGColorRelease(backgroundColor);

    [splitView addSubview:scrollView];
    [splitView addSubview:self.previewView];

    [splitView setAutoresizingMask:kCALayerWidthSizable|kCALayerHeightSizable];
    [splitView setAutoresizesSubviews:YES];

    [[self.window contentView] addSubview:splitView];
}

#pragma mark Window Delegate

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return [NSString stringWithFormat:@"%ld", row];
}

- (void)windowDidBecomeMain:(NSNotification *)notification
{
    //[self refreshDataSources];
}

#pragma mark Split View Delegate

- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)subview
{
	return NO;
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
	return NO;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)dividerIndex {
    if (dividerIndex == 0) {
    	proposedMax = kTableViewMaxWidth;
    }
    return proposedMax;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)dividerIndex {
    if (dividerIndex == 0) {
        proposedMin = kTableViewMinWidth;
    }
    return proposedMin;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainSplitPosition:(CGFloat)proposedPosition ofSubviewAt:(NSInteger)dividerIndex {
    if (proposedPosition > kTableViewMaxWidth)
        return 200.0f;
    if (proposedPosition < kTableViewMinWidth)
        return 100.0f;
	return proposedPosition;
}

#pragma mark Table View Delegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSView *cellView = (NSView*)[tableView makeViewWithIdentifier:@"PlugnInView"
                                                            owner:[tableView delegate]];
    if (!cellView) {
        NSObject<GOLDDataEntry> *dataEntry = self.dataSource[row];

        if (dataEntry.plugInName) {
            NSObject<GOLDPlugIn> *plugIn = [GOLDPlugInsLoader sharedLoader].loadedPlugIns[dataEntry.plugInName];
            NSView *plugInView;
            id entry = self.dataSource[row];

            if ([plugIn respondsToSelector:@selector(mainView:)]) {
                plugInView = [plugIn mainView:entry];
            } else {
                plugInView = [self defaultMainView:entry];
            }

            [plugInView setIdentifier:@"PlugnInView"];
            cellView = plugInView;
        }
    }
    return cellView;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
	return 44.f;
}

#pragma mark Table View Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return self.dataSource.count;
}

- (void)refreshDataSources
{
    // TODO Discuss with Tim if it might have some implications that
    dispatch_async(self.plugInQueue, ^{
        __block NSMutableArray *plugInData = [[NSMutableArray alloc] init];
        NSDictionary *loadedPlugIns = [GOLDPlugInsLoader sharedLoader].loadedPlugIns;

        [loadedPlugIns enumerateKeysAndObjectsUsingBlock:^(NSString *plugInName, NSObject<GOLDPlugIn> *plugIn, BOOL *stop) {
            NSArray *configurations = [plugIn configurations];

            [configurations enumerateObjectsUsingBlock:^(NSDictionary *configuration, NSUInteger idx, BOOL *stop) {
                [plugIn executeWithConfiguration:configuration];
            }];

            if ([plugIn respondsToSelector:NSSelectorFromString(@"dataCache")]
            && plugIn.dataCache) {
                BOOL dataCacheIsValid = [[plugIn.dataCache firstObject] conformsToDataEntryProtocol];

                if (dataCacheIsValid) {
                    [plugInData addObjectsFromArray:plugIn.dataCache];
                }
            }
        }];

        if ([plugInData count]) {
            NSSortDescriptor *sortByStartDateProperty = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO];
            [plugInData sortUsingDescriptors:@[sortByStartDateProperty]];

            self.dataSource = [plugInData copy];
        }
        [self.tableView reloadData];
    });
}

#pragma mark Fallback for plug-ins without mainView

- (NSView *)defaultMainView:(NSObject<GOLDDataEntry> *)entry
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

@end
