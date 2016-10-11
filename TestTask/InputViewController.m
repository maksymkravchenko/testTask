//
//  InputViewController.m
//  TestTask
//
//  Created by Maksym Kravchenko on 10/11/16.
//  Copyright © 2016 Max. All rights reserved.
//

#import "InputViewController.h"
#import "MessageModel.h"

@interface InputViewController ()

@property (retain, nonatomic) IBOutlet UILabel *stateLabel;
@property (retain, nonatomic) IBOutlet UITextView *loggerLabel;
@property (retain, nonatomic) IBOutlet UITextField *inputTextField;
@property (retain, nonatomic) IBOutlet UISwitch *boolValueSwitch;
@property (retain, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;


@end

@implementation InputViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)dealloc
{
	[_stateLabel release];
	[_loggerLabel release];
	[_inputTextField release];
	[_boolValueSwitch release];
	[_typeSegmentedControl release];
	[super dealloc];
}

- (IBAction)onSendAction:(id)sender
{
	[self.messsageModel sendMessageOfType:self.typeSegmentedControl.selectedSegmentIndex content:self.inputTextField.text boolValue:self.boolValueSwitch.on];
}

@end
