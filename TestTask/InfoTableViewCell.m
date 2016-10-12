//
//  InfoTableViewCell.m
//  TestTask
//
//  Created by Maksym Kravchenko on 10/11/16.
//  Copyright © 2016 Max. All rights reserved.
//

#import "InfoTableViewCell.h"

@interface InfoTableViewCell ()

@property (retain, nonatomic) IBOutlet UILabel *messageLabel;
@property (retain, nonatomic) IBOutlet UILabel *messageSentLabel;

@end

@implementation InfoTableViewCell

- (void)setMessageText:(NSString *)messageText
{
	if (![_messageText isEqualToString:messageText])
	{
		[_messageText release];
		_messageText = messageText.copy;
		
		self.messageLabel.text = _messageText;
	}
}

- (void)setMessageSend:(BOOL)messageSend
{
	_messageSend = messageSend;
		
	self.messageSentLabel.text = _messageSend ? @"Sent" : @"Not sent";
}

- (void)dealloc
{
	[_messageLabel release];
	[_messageSentLabel release];
	[_messageText release];
	
	[super dealloc];
}
@end
