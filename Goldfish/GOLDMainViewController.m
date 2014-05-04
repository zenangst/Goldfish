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
    [[self.window contentView] setAutoresizesSubviews:YES];
    self.windowController = [[NSWindowController alloc] initWithWindow:self.window];

    [self.windowController loadWindow];
    [self.windowController setWindowFrameAutosaveName:@"MainWindowFrame"];

    [self.window setWindowController:self.windowController];
    [self.window setTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"]];
    [self.window setFrameAutosaveName:@"MainFrame"];
    [self.window setDelegate:self];

    [self configureToolBar];

    NSSplitView *splitView = [self splitView];
    NSScrollView *scrollView = [self scrollView];
    self.tableView = [self historyView];

    NSTableColumn *column = [[NSTableColumn alloc] init];
    [column setResizingMask:NSTableColumnAutoresizingMask];
    [column setEditable:NO];
    [column setIdentifier:@"Column"];
    [column sizeToFit];
    [self.tableView addTableColumn:column];

    NSClipView *clipView = [self clipView];
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

- (void)configureToolBar
{
    NSView *titleBarView = self.window.titleBarView;
    [titleBarView setAutoresizesSubviews:YES];
    [titleBarView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];

    NSSize segementedSize = NSMakeSize(166.f, 60.f);

    CGFloat x =  NSMidX(titleBarView.bounds) - (segementedSize.width / 2.f);
    CGFloat y =  NSMidY(titleBarView.bounds) - (segementedSize.height / 2.f);

    NSRect segementedFrame = NSMakeRect(x,y, segementedSize.width, segementedSize.height);

    NSSegmentedControl *segmentedControl = [[NSSegmentedControl alloc] initWithFrame:segementedFrame];
    [segmentedControl setSegmentCount:3];
    [segmentedControl setSegmentStyle:NSSegmentStyleTexturedSquare];

    [segmentedControl setWidth:30.0f forSegment:0];
    [segmentedControl setImage:[NSImage imageNamed:@"NSGoLeftTemplate"] forSegment:0];

    [segmentedControl setWidth:100.0f forSegment:1];

    [segmentedControl setWidth:30.0f forSegment:2];
    [segmentedControl setImage:[NSImage imageNamed:@"NSGoRightTemplate"] forSegment:2];

    [segmentedControl setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin];

    [[segmentedControl cell] setTrackingMode:NSSegmentSwitchTrackingMomentary];

    [titleBarView addSubview:segmentedControl];
}

- (NSSplitView *)splitView
{
    CGFloat x = CGRectGetWidth([[self.window contentView] frame]);
    CGFloat y = CGRectGetHeight([[self.window contentView] frame]);
    NSRect splitViewFrame = NSMakeRect(0, 0, x, y);
    NSSplitView *splitView = [[NSSplitView alloc] initWithFrame:splitViewFrame];
    [splitView setAutosaveName:@"MainSplitView"];
    [splitView setIdentifier:@"MainSplitView"];
    [splitView setVertical:YES];
    [splitView setDelegate:self];
    [splitView setDividerStyle:NSSplitViewDividerStylePaneSplitter];
    [splitView setAutoresizesSubviews:YES];
    return splitView;
}

- (NSScrollView *)scrollView
{
    NSScrollView *scrollView = [[NSScrollView alloc] init];
    [scrollView setHasVerticalScroller:YES];
    [scrollView setHasHorizontalScroller:YES];
    [scrollView setAutoresizesSubviews:YES];
    [scrollView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView setAcceptsTouchEvents:YES];
    return scrollView;
}

- (NSClipView *)clipView
{
    NSClipView *clipView = [[NSClipView alloc] init];
    [clipView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [clipView setAutoresizesSubviews:YES];
    return clipView;
}

- (NSTableView *)historyView
{
    if (self.tableView == nil) {
        NSTableView *tableView = [[NSTableView alloc] init];
        [tableView setAutosaveName:@"HistoryView"];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView setAllowsEmptySelection:NO];
        [tableView setRowHeight:32.0f];
        [tableView setHeaderView:nil];
        /* [tableView setUsesAlternatingRowBackgroundColors:YES]; */
        /* [tableView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList]; */
        [tableView setColumnAutoresizingStyle:NSTableViewUniformColumnAutoresizingStyle];
        return tableView;
    }
    return self.tableView;
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

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMax
         ofSubviewAt:(NSInteger)dividerIndex {
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

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    static NSString *cellIdentifier = @"PlugnInView";
    NSTableCellView *cellView = (NSTableCellView*)[tableView makeViewWithIdentifier:cellIdentifier
                                                                              owner:self];

    if (cellView == nil) {
        id <GOLDDataEntry> dataEntry = self.dataSource[row];
        if (dataEntry.plugInName) {
            id <GOLDPlugIn> plugIn = [GOLDPlugInsLoader sharedLoader].loadedPlugIns[dataEntry.plugInName];
            NSTableCellView *plugInView;
            id entry = self.dataSource[row];

            if ([plugIn respondsToSelector:@selector(mainView:)]) {
                plugInView = (NSTableCellView *)[plugIn mainView:entry];
            } else {
                plugInView = (NSTableCellView *)[self defaultMainView:entry plugIn:plugIn];
            }

            [plugInView setIdentifier:cellIdentifier];
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
    dispatch_async(self.plugInQueue, ^{
        NSDictionary *loadedPlugIns = [GOLDPlugInsLoader sharedLoader].loadedPlugIns;

        __block NSMutableArray *plugInData = [[NSMutableArray alloc] init];

        [loadedPlugIns enumerateKeysAndObjectsUsingBlock:^(NSString *plugInName, id <GOLDPlugIn> plugIn, BOOL *stop) {
            NSArray *configurations = [plugIn configurations];


            for (NSDictionary *configuration in configurations) {
                NSArray *dataCache = [plugIn executeWithConfiguration:configuration];
                BOOL dataCacheIsValid = [[dataCache firstObject] conformsToDataEntryProtocol];

                if (dataCacheIsValid) {
                    [plugInData addObjectsFromArray:dataCache];
                }
            }
        }];

        if ([plugInData count]) {
            NSSortDescriptor *sortByStartDateProperty;
            sortByStartDateProperty = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO];
            [plugInData sortUsingDescriptors:@[sortByStartDateProperty]];

            self.dataSource = [plugInData copy];
        }
        [self.tableView reloadData];
    });
}

#pragma mark Fallback for plug-ins without mainView

- (NSView *)defaultMainView:(NSObject<GOLDDataEntry> *)entry plugIn:(id<GOLDPlugIn>)plugIn
{
    NSView *mainView = [[NSView alloc] init];
    [mainView setAutoresizingMask:kCALayerWidthSizable|kCALayerHeightSizable];
    [mainView setAutoresizesSubviews:YES];

    if ([plugIn respondsToSelector:@selector(color)]) {
        NSColor *color = [plugIn color];
        CALayer *viewLayer = [CALayer layer];
        [viewLayer setBackgroundColor:[color CGColor]];
        [mainView setWantsLayer:YES];
        [mainView setLayer:viewLayer];
    }

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
