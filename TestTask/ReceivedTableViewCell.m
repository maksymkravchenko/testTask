//
//  ReceivedTableViewCell.m
//  TestTask
//
//  Created by Maksym Kravchenko on 10/12/16.
//  Copyright © 2016 Max. All rights reserved.
//

#import "ReceivedTableViewCell.h"

@interface ReceivedTableViewCell ()

@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *boolValueLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation ReceivedTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)dealloc
{
	[_content release];
	[_date release];
	
	[_timeLabel release];
	[_boolValueLabel release];
	[_contentLabel release];
	[super dealloc];
}

- (void)setDate:(NSDate *)date
{
	if (![_date isEqual:date])
	{
		[_date release];
		_date = [date retain];
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
		dateFormatter.dateFormat = @"HH:mm";
		NSString *result = [dateFormatter stringFromDate:date];
		self.timeLabel.text = result;
	}
}

- (void)setContent:(NSString *)content
{
	if (![_content isEqualToString:content])
	{
		[_content release];
		_content = content.copy;
		
		self.contentLabel.text = _content;
	}
}

- (void)setBooleanValue:(BOOL)booleanValue
{
	_booleanValue = booleanValue;
	
	self.boolValueLabel.text = [NSString stringWithFormat:@"BoolValue = %@", _booleanValue ? @"YES" : @"NO"];
}

@end
