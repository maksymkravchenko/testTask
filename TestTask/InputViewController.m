//
//  InputViewController.m
//  TestTask
//
//  Created by Maksym Kravchenko on 10/11/16.
//  Copyright © 2016 Max. All rights reserved.
//

#import "InputViewController.h"
#import "MessageModel.h"
#import "WebSocketService.h"
#import "AppDelegate.h"

@interface InputViewController () <WebSocketServiceDelegate, UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UILabel *stateLabel;
@property (retain, nonatomic) IBOutlet UITextView *loggerTextView;
@property (retain, nonatomic) IBOutlet UITextField *inputTextField;
@property (retain, nonatomic) IBOutlet UISwitch *boolValueSwitch;
@property (retain, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;

@property (retain, nonatomic) NSMutableString *loggerText;

@end

@implementation InputViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.webSocketService.delegate = self;
	
	[self updateStateLabelTextWithState:appDelegate.webSocketService.state];
}

- (void)dealloc
{
	[_stateLabel release];
	[_loggerTextView release];
	[_inputTextField release];
	[_boolValueSwitch release];
	[_typeSegmentedControl release];
	[_messsageModel release];
	[_loggerText release];
	
	[super dealloc];
}

- (IBAction)onSendAction:(id)sender
{
	[self.messsageModel sendMessageOfType:self.typeSegmentedControl.selectedSegmentIndex content:self.inputTextField.text boolValue:self.boolValueSwitch.on];
}

- (void)updateStateLabelTextWithState:(WebSocketState)state
{
	if (state == kWebSocketStateConnecting)
	{
		self.stateLabel.text = @"Connecting ...";
	}
	else if (state == kWebSocketStateOnline)
	{
		self.stateLabel.text = @"Online";
	}
	else
	{
		self.stateLabel.text = @"Offline";
	}
}

#pragma mark - WebSocketServiceDelegate

- (void)webSocket:(WebSocketService *)webSocket didChangeWithDescription:(NSString *)descriptionText
{
	if (self.loggerText == nil)
	{
		self.loggerText = [[NSMutableString new] autorelease];
	}
	
	if (self.loggerText.length > 0)
	{
		[self.loggerText appendString:@"\n"];
	}
	[self.loggerText appendString:descriptionText];
	self.loggerTextView.text = [self.loggerText.copy autorelease];
}

- (void)webSocket:(WebSocketService *)webSocket didChangeWithState:(WebSocketState)state
{
	[self updateStateLabelTextWithState:state];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	return YES;
}

@end
