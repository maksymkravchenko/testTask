//
//  SendingViewController.m
//  TestTask
//
//  Created by Maksym Kravchenko on 10/11/16.
//  Copyright © 2016 Max. All rights reserved.
//

#import "SendingViewController.h"
#import "InfoTableViewCell.h"
#import "MessageModel.h"
#import "Message+CoreDataClass.h"

static NSString *const kSendingViewControllerCellReusableId = @"InfoCell";

@interface SendingViewController () <UITableViewDataSource, UITableViewDelegate, MessageModelDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SendingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.tableView.estimatedRowHeight = 70.0;
}

- (void)dealloc {
	[_tableView release];
	[super dealloc];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.messsageModel.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	InfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kSendingViewControllerCellReusableId];
	
	Message *message = self.messsageModel.messages[indexPath.row];
	NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
	dateFormatter.dateFormat = @"HH:mm";
	NSTimeInterval interval = message.updateDate;
	NSString *date = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]];
	NSString *type = @"XML";
	if (message.type == kMessageTypeJSON)
	{
		type = @"JSON";
	}
	else if (message.type == kMessageTypeBinary)
	{
		type = @"Binary";
	}

	cell.messageText = [NSString stringWithFormat:@"%@ Type: %@ \n boolValue = %@ \n%@", date, type, message.boolValue ? @"YES" : @"NO", message.content];
	
	cell.messageSend = message.sent;
	
	return cell;
}

#pragma mark - MessageModelDelegate

- (void)model:(MessageModel *)model didUpdateMessagesAtIndex:(NSInteger)index
{
	[self.tableView beginUpdates];
	
	NSArray *indexPaths = @[ [NSIndexPath indexPathForRow:model.messages.count - 1 inSection:0] ];
	[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
	
	[self.tableView endUpdates];
	
	[self.tableView scrollToRowAtIndexPath:indexPaths.firstObject atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

@end
