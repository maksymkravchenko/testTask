//
//  MessageModel.m
//  TestTask
//
//  Created by Maksym Kravchenko on 10/11/16.
//  Copyright © 2016 Max. All rights reserved.
//

#import "MessageModel.h"
#import "AppDelegate.h"
#import "Message+CoreDataClass.h"
#import "WebSocketService.h"

@interface MessageModel ()

@property (nonatomic, retain) NSMutableArray *mutableMessages;

@end

@implementation MessageModel

- (instancetype)init
{
	self = [super init];
	
	if (self != nil)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateModelOnCoreDataChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeliveredMessage:) name:@"Delivered" object:nil];
	}
	return self;
}

- (NSArray *)messages
{
	return self.mutableMessages.copy;
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"Delivered" object:nil];

	[_mutableMessages release];
	[_delegate release];
	
	[super dealloc];
}

- (void)sendMessageOfType:(NSInteger)type content:(id)content boolValue:(BOOL)boolValue
{
	Message *newMessage = [NSEntityDescription insertNewObjectForEntityForName:kMessageKey inManagedObjectContext:self.appDelegate.managedObjectContext];
	
	newMessage.type = type;
	newMessage.content = content;
	newMessage.boolValue = boolValue;
	newMessage.updateDate = [NSDate date].timeIntervalSince1970;
	
	[self.appDelegate saveContext];
}

//observation of Core Data changes
- (void)updateModelOnCoreDataChange:(NSNotification *)notification
{
	NSSet *newMessages = [notification.userInfo objectForKey:NSInsertedObjectsKey];
	if (newMessages.count > 0)
	{
		for (Message *message in newMessages)
		{
			if ([message isKindOfClass:[Message class]])
			{
				if (self.mutableMessages == nil)
				{
					self.mutableMessages = @[message].mutableCopy;
				}
				else
				{
					[self.mutableMessages addObject:message];
				}
				
				[self.delegate modelDidAddMessage:self];
				
				[self sendMessage:message];
			}
		}
	}
}

- (void)updateDeliveredMessage:(NSNotification *)notification
{
	Message *message = self.messages.lastObject;
	message.sent = YES;
	[self.delegate model:self didUpdateMessagesAtIndex:self.messages.count - 1];
}

- (void)sendMessage:(Message *)message
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		id encodedMessage = nil;
		
		NSMutableDictionary *userInfo = @{}.mutableCopy;
		userInfo[@"content"] = message.content != nil ? message.content : @"";
		userInfo[@"boolValue"] = @(message.boolValue);
		userInfo[@"updateDate"] = @(message.updateDate);
		
		if (message.type == kMessageTypeXML)
		{
			
			NSMutableData *archiveData = [NSMutableData data];
			NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archiveData];
			archiver.outputFormat = NSPropertyListXMLFormat_v1_0;
			[archiver encodeRootObject:userInfo];
			[archiver finishEncoding];
			encodedMessage = archiveData;

			NSString *xmlString = [NSString stringWithFormat:@"<?xml version=\"1.0\"?> <message> <content>%@</content><boolValue>%d</boolValue><updateDate>%lld</updateDate>	</message>", message.content, message.boolValue, message.updateDate];
			encodedMessage = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
		}
		else if (message.type == kMessageTypeJSON)
		{
			encodedMessage = [NSJSONSerialization dataWithJSONObject:userInfo options:0 error:NULL];
		}
		else
		{
			encodedMessage = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.appDelegate.webSocketService sendMessage:encodedMessage];
		});
	});
}

@end
