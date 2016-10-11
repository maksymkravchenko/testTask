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

@property (nonatomic) NSMutableArray *mutableMessages;

@end

@implementation MessageModel

- (instancetype)init
{
	self = [super init];
	
	if (self != nil)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateModelOnCoreDataChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
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
				[self.mutableMessages addObject:message];
				[self.delegate model:self didUpdateMessagesAtIndex:self.messages.count - 1];
				
				[self sendMessage:message];
			}
		}
	}
}

- (void)sendMessage:(Message *)message
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		id encodedMessage = nil;
		if (message.type == kMessageTypeJSON)
		{
			
		}
		else if (message.type == kMessageTypeXML)
		{
			
		}
		else
		{
			
		}
		
		[self.appDelegate.webSocketService sendMessage:encodedMessage]; //TODO:
	});
}

@end
