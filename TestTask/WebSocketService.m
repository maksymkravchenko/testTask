//
//  WebSocketService.m
//  TestTask
//
//  Created by Maksym Kravchenko on 10/11/16.
//  Copyright © 2016 Max. All rights reserved.
//

#import "WebSocketService.h"
#import "SRWebSocket.h"

static NSString *const kWetSockerEchoPath = @"wss://echo.websocket.org";

@interface WebSocketService () <SRWebSocketDelegate>

@property (strong, nonatomic, readonly) SRWebSocket *webSocket;

@end

@implementation WebSocketService

- (instancetype) init
{
	self = [super init];
	
	if (self != nil)
	{
		NSURL *url = [NSURL URLWithString:kWetSockerEchoPath];
		_webSocket = [[[SRWebSocket alloc] initWithURL:url] autorelease];
		_webSocket.delegate = self;
	}
	return self;
}

- (void)dealloc
{
	[_delegate release];
	[_webSocket release];
	[super dealloc];
}

- (void)startService
{
	[self.webSocket open];
}

- (void)stopService
{
	[self.webSocket close];
}

- (void)sendMessage:(id)message
{
	[self.webSocket send:@"message"];
//	[self.webSocket send:message];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
	NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:messageData options:0 error:NULL];
	
	[self sendDescriptionToDelegate:[NSString stringWithFormat:@"%@", dict]];
	
	NSLog(@"%@", message);
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
	[self sendDescriptionToDelegate:@"WebSockets did open"];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
	NSString *message = [NSString stringWithFormat:@"WebSockets did fail with error: %@", error.localizedDescription];
	[self sendDescriptionToDelegate:message];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
	NSString *message = [NSString stringWithFormat:@"WebSockets did fail with code: %lu, reason :%@, wasClean: %@", code, reason, wasClean ? @"YES" : @"NO"];
	[self sendDescriptionToDelegate:message];
}

#pragma mark - Util

- (void)sendDescriptionToDelegate:(NSString *)message
{
	NSString *description = [self descriptionStringWithCurrentDate:message];

	[self.delegate webSocketStateDidChange:self withDescription:description];
}

- (NSString *)descriptionStringWithCurrentDate:(NSString *)string
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
	dateFormatter.dateFormat = @"yyyyMMdd_HHmmss";
	NSMutableString *result = [dateFormatter stringFromDate:[NSDate date]].mutableCopy;
	[result appendString:@"\n"];
	[result appendString:string];
	return result.copy;
}

@end
