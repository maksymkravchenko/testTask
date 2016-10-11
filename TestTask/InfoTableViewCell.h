//
//  InfoTableViewCell.h
//  TestTask
//
//  Created by Maksym Kravchenko on 10/11/16.
//  Copyright © 2016 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *messageText;
@property (nonatomic, assign) BOOL messageSend;

@end
