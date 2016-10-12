//
//  ReceivedViewController.m
//  TestTask
//
//  Created by Maksym Kravchenko on 10/11/16.
//  Copyright © 2016 Max. All rights reserved.
//

#import "ReceivedViewController.h"
#import "WebSocketService.h"
#import "AppDelegate.h"
#import "ReceivedTableViewCell.h"

static NSString *const kReceivedViewControllerCellReusableId = @"ReceivedCell";

@interface ReceivedViewController () <UITableViewDataSource, UITableViewDelegate, WebSocketServiceDeserializationDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) NSMutableArray *messages;

@end

@implementation ReceivedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.tableView.estimatedRowHeight = 44.0;
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.webSocketService.deserializationDelegate = self;
	
	self.messages = @[].mutableCopy;
}

- (void)dealloc
{
	[_messages release];
	[_tableView release];
	
	[super dealloc];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ReceivedTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kReceivedViewControllerCellReusableId];
	
	NSDictionary *dict = self.messages[indexPath.row];
	
	cell.content = [dict objectForKey:@"content"];
	NSTimeInterval interval = [[dict objectForKey:@"updateDate"] doubleValue];
	cell.date = [NSDate dateWithTimeIntervalSince1970:interval];
	cell.booleanValue = [[dict valueForKey:@"boolValue"] boolValue];
	
	return cell;
}

#pragma mark - WebSocketServiceDeserializationDelegate

- (void)webSocket:(WebSocketService *)webSocket didReceiveInfo:(NSDictionary *)info
{
	[self.messages addObject:info];
	
	[self.tableView beginUpdates];
	
	NSArray *indexPaths = @[ [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0] ];
	[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];

	[self.tableView endUpdates];
	
	[self.tableView scrollToRowAtIndexPath:indexPaths.firstObject atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

@end
