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

@interface WebSocketService () <SRWebSocketDelegate, NSXMLParserDelegate>

@property (retain, nonatomic) SRWebSocket *webSocket;
@property (assign, nonatomic, readwrite) WebSocketState state;
@property (retain, nonatomic) NSTimer *timer;

@property (retain, nonatomic) NSMutableDictionary *parsedDict;
@property (copy, nonatomic) NSString *currentElement;


@end

@implementation WebSocketService

- (void)setState:(WebSocketState)state
{
	if (_state != state)
	{
		_state = state;

		[self.delegate webSocket:self didChangeWithState:state];
	}
}

- (instancetype) init
{
	self = [super init];
	
	if (self != nil)
	{
		_state = kWebSocketStateOffline;
	}
	return self;
}

- (void)dealloc
{
	[_delegate release];
	[_webSocket release];
	[_deserializationDelegate release];
	[_timer release];
	[_currentElement release];
	[_parsedDict release];
	
	[super dealloc];
}

- (void)startService
{
	self.state = kWebSocketStateConnecting;

	self.webSocket = nil;
	
	NSURL *url = [NSURL URLWithString:kWetSockerEchoPath];
	self.webSocket = [[SRWebSocket alloc] initWithURL:url];
	self.webSocket.delegate = self;
	
	[self.webSocket open];
}

- (void)stopService
{
	[self.webSocket close];
}

- (void)sendMessage:(id)message
{
	[self.webSocket send:message];
}

- (void)scheduleTimer
{
	self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(onTimerFired:) userInfo:nil repeats:NO];
}

- (void)invalidateTimer
{
	[self.timer invalidate];
	self.timer = nil;
}

- (void)onTimerFired:(NSTimer *)timer
{
	[self startService];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
	if ([message isKindOfClass:[NSData class]])
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"Delivered" object:nil];
		
		NSError *error = nil;
		
		NSDictionary *result = [NSJSONSerialization JSONObjectWithData:message options:0 error:&error];
		if (error == nil)
		{
			[self sendDescriptionToDelegate:[NSString stringWithFormat:@"%@", result]];
		}
		else
		{
			NSString *string = [[NSString alloc] initWithData:message encoding:NSUTF8StringEncoding];
			
			if (string == nil) //binary Data
			{
				result = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:message];
			}
			else
			{
				dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
					NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:message] autorelease];
					parser.delegate = self;
					if ([parser parse])
					{
						dispatch_async(dispatch_get_main_queue(), ^{
							[self.deserializationDelegate webSocket:self didReceiveInfo:self.parsedDict];
							
							[self sendDescriptionToDelegate:[NSString stringWithFormat:@"%@", self.parsedDict]];
						});
					}
				});
			}
		}
		
		if (result != nil)
		{
			[self.deserializationDelegate webSocket:self didReceiveInfo:result];
		}
	}
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
	self.state = kWebSocketStateOnline;
	
	[self invalidateTimer];

	[self sendDescriptionToDelegate:@"WebSockets did open"];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
	self.state = kWebSocketStateOffline;

	[self scheduleTimer];
	
	NSString *message = [NSString stringWithFormat:@"WebSockets did fail with error: %@", error.localizedDescription];
	[self sendDescriptionToDelegate:message];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
	self.state = kWebSocketStateOffline;

	NSString *message = [NSString stringWithFormat:@"WebSockets did fail with code: %lu, reason :%@, wasClean: %@", code, reason, wasClean ? @"YES" : @"NO"];
	[self sendDescriptionToDelegate:message];
}

#pragma mark - NSXMLParserDelegate


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(nonnull NSDictionary<NSString *,NSString *> *)attributeDict
{
	self.currentElement = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (self.parsedDict == nil)
	{
		self.parsedDict = [@{}.mutableCopy autorelease];
	}
	
	if (self.currentElement != nil)
	{
		[self.parsedDict setObject:string forKey:self.currentElement];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	self.currentElement = nil;
}

#pragma mark - Util

- (void)sendDescriptionToDelegate:(NSString *)message
{
	NSString *description = [self descriptionStringWithCurrentDate:message];

	[self.delegate webSocket:self didChangeWithDescription:description];
}

- (NSString *)descriptionStringWithCurrentDate:(NSString *)string
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
	dateFormatter.dateFormat = @"HH:mm";
	NSMutableString *result = [dateFormatter stringFromDate:[NSDate date]].mutableCopy;
	[result appendString:@"\n"];
	[result appendString:string];
	return result.copy;
}

@end
