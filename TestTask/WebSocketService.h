//
//  WebSocketService.h
//  TestTask
//
//  Created by Maksym Kravchenko on 10/11/16.
//  Copyright © 2016 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebSocketServiceDelegate;

@interface WebSocketService : NSObject

@property (nonatomic, assign) id<WebSocketServiceDelegate> delegate;

- (void)startService;
- (void)stopService;
- (void)sendMessage:(id)message;

@end

@protocol WebSocketServiceDelegate <NSObject>

- (void)webSocketStateDidChange:(WebSocketService *)webSocket withDescription:(NSString *)descriptionText;

@end
