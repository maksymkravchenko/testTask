//
//  MessageModel.h
//  TestTask
//
//  Created by Maksym Kravchenko on 10/11/16.
//  Copyright © 2016 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
	kMessageTypeXML = 0,
	kMessageTypeJSON,
	kMessageTypeBinary
} MessageType;

@class Message;
@protocol MessageModelDelegate;

@interface MessageModel : NSObject

@property (nonatomic, readonly, retain) NSArray *messages;
@property (nonatomic, assign) id<MessageModelDelegate> delegate;

- (void)sendMessageOfType:(NSInteger)type content:(NSString *)content boolValue:(BOOL)boolValue;

@end

@protocol MessageModelDelegate <NSObject>

- (void)model:(MessageModel *)model didUpdateMessagesAtIndex:(NSInteger)index;
- (void)modelDidAddMessage:(MessageModel *)model;

@end
