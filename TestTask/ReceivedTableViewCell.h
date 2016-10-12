//
//  ReceivedTableViewCell.h
//  TestTask
//
//  Created by Maksym Kravchenko on 10/12/16.
//  Copyright © 2016 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceivedTableViewCell : UITableViewCell

@property (copy, nonatomic) NSString *content;
@property (assign, nonatomic) BOOL booleanValue;
@property (retain, nonatomic) NSDate *date;

@end
