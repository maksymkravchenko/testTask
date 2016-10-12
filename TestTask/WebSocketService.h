//
//  WebSocketService.h
//  TestTask
//
//  Created by Maksym Kravchenko on 10/11/16.
//  Copyright © 2016 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
	kWebSocketStateConnecting = 0,
	kWebSocketStateOnline,
	kWebSocketStateOffline
} WebSocketState;

@protocol WebSocketServiceDelegate;
@protocol WebSocketServiceDeserializationDelegate;

@interface WebSocketService : NSObject

@property (nonatomic, assign) id<WebSocketServiceDelegate> delegate;
@property (nonatomic, assign) id<WebSocketServiceDeserializationDelegate> deserializationDelegate;

@property (nonatomic, readonly, assign) WebSocketState state;

- (void)startService;
- (void)stopService;
- (void)sendMessage:(id)message;

@end

@protocol WebSocketServiceDelegate <NSObject>

- (void)webSocket:(WebSocketService *)webSocket didChangeWithDescription:(NSString *)descriptionText;
- (void)webSocket:(WebSocketService *)webSocket didChangeWithState:(WebSocketState)state;

@end

@protocol WebSocketServiceDeserializationDelegate <NSObject>

- (void)webSocket:(WebSocketService *)webSocket didReceiveInfo:(NSDictionary *)info;

@end

