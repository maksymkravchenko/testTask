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

@property (nonatomic, readonly, strong) MessageModel *messsageModel;

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	_messsageModel = [MessageModel new];
	
	for (id vc in self.childViewControllers)
	{
		if ([vc isKindOfClass:[InputViewController class]])
		{
			[vc setMesssageModel:_messsageModel];
		}
		else if ([vc isKindOfClass:[SendingViewController class]])
		{
			[vc setMesssageModel:_messsageModel];
			_messsageModel.delegate = vc;
		}
	}
}

- (void)dealloc
{
	[_messsageModel release];
	
	[super dealloc];
}

@end
