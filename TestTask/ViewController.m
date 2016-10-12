//
//  ViewController.m
//  TestTask
//
//  Created by Maksym Kravchenko on 10/10/16.
//  Copyright © 2016 Max. All rights reserved.
//

#import "ViewController.h"
#import "MessageModel.h"
#import "InputViewController.h"
#import "SendingViewController.h"

@interface ViewController ()

@property (retain, nonatomic) MessageModel *messsageModel;

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.messsageModel = [[MessageModel new] autorelease];

	
	for (id vc in self.childViewControllers)
	{
		if ([vc isKindOfClass:[InputViewController class]])
		{
			[vc setMesssageModel:_messsageModel];
		}
		else if ([vc isKindOfClass:[SendingViewController class]])
		{
			[vc setMesssageModel:_messsageModel];
			self.messsageModel.delegate = vc;
		}
	}
}

- (void)dealloc
{
	[_messsageModel release];
	
	[super dealloc];
}

@end
