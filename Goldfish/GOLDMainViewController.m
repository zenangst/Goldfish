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

static const float kTableViewMinWidth = 150.0f;
static const float kTableViewMaxWidth = 350.0f;

@implementation GOLDMainViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureInterface];
    }
    return self;
}

- (void)showWindow
{
    [NSApp activateIgnoringOtherApps:YES];
    [self.windowController showWindow:self];
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
    self.splitView = [[NSSplitView alloc] initWithFrame:splitViewFrame];
    [self.splitView setAutosaveName:@"MainSplitView"];
    [self.splitView setIdentifier:@"MainSplitView"];
    [self.splitView setVertical:YES];
    [self.splitView setDelegate:self];
    [self.splitView setDividerStyle:NSSplitViewDividerStylePaneSplitter];
    [self.splitView setAutoresizesSubviews:YES];

    NSScrollView *scrollView = [[NSScrollView alloc] init];
    [scrollView setHasVerticalScroller:YES];
    [scrollView setHasHorizontalScroller:YES];
    [scrollView setAutoresizesSubviews:YES];
    [scrollView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView setAcceptsTouchEvents:YES];

    self.dataSource = nil;

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

    [self.splitView addSubview:scrollView];
    [self.splitView addSubview:self.previewView];

    [self.splitView setAutoresizingMask:kCALayerWidthSizable|kCALayerHeightSizable];
    [self.splitView setAutoresizesSubviews:YES];

    [[self.window contentView] addSubview:self.splitView];
    [self refreshDataSources];
}

#pragma mark Window Delegate

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn
                                                               row:(NSInteger)row {
    return [NSString stringWithFormat:@"%ld", row];
}

- (void)windowDidBecomeMain:(NSNotification *)notification
{
    [self refreshDataSources];
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

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMin
                                                         ofSubviewAt:(NSInteger)dividerIndex {
    if (dividerIndex == 0) {
        proposedMin = kTableViewMinWidth;
    }
    return proposedMin;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainSplitPosition:(CGFloat)proposedPosition
                                                         ofSubviewAt:(NSInteger)dividerIndex {
    if (proposedPosition > kTableViewMaxWidth)
        return 200.0f;
    if (proposedPosition < kTableViewMinWidth)
        return 100.0f;
	return proposedPosition;
}

#pragma mark Table View Delegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn
                                                              row:(NSInteger)row
{
    NSView *cellView = (NSView*)[tableView makeViewWithIdentifier:@"PlugnInView"
                                                            owner:[tableView delegate]];
    if (cellView == nil) {
        NSString *plugInName = self.dataSource[row][@"plugIn"];
        if (plugInName) {
            NSObject<GOLDPlugIn> *plugIn = [GOLDPlugInsLoader sharedLoader].loadedPlugIns[plugInName];
            NSView *plugInView = [plugIn mainView:self.dataSource[row] isRowSelected:row];
            [plugInView setIdentifier:@"PlugnInView"];
            cellView = plugInView;
        }
    }
    return cellView;
}

- (CGFloat)tableView:(NSTableView *)tableView
         heightOfRow:(NSInteger)row {
	return 44.f;
}

#pragma mark Table View Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return self.dataSource.count;
}

- (void)refreshDataSources
{
    __block NSMutableArray *plugInData = [[NSMutableArray alloc] init];

    [[GOLDPlugInsLoader sharedLoader].loadedPlugIns enumerateKeysAndObjectsUsingBlock:^(NSString *plugInName, NSObject<GOLDPlugIn> *plugIn, BOOL *stop) {
        [plugIn execute];
        if ([plugIn respondsToSelector:NSSelectorFromString(@"dataCache")]
        && plugIn.dataCache) {
            [plugInData addObjectsFromArray:plugIn.dataCache];
        }
    }];

    self.dataSource = [plugInData copy];
    [self.tableView reloadData];
}

@end
