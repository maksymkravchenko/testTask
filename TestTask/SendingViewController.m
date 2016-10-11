//
//  SendingViewController.m
//  TestTask
//
//  Created by Maksym Kravchenko on 10/11/16.
//  Copyright © 2016 Max. All rights reserved.
//

#import "SendingViewController.h"
#import "InfoTableViewCell.h"

static NSString *const kSendingViewControllerCellReusableId = @"InfoCell";

@interface SendingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation SendingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
}

- (void)dealloc {
	[_tableView release];
	[super dealloc];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	InfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kSendingViewControllerCellReusableId];
	return cell;
}

@end
