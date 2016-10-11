//
//  Logger.h
//  TestTask
//
//  Created by Maksym Kravchenko on 10/11/16.
//  Copyright © 2016 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebSocketService;

@interface Logger : NSObject

@property (nonatomic, strong) WebSocketService *webSocketService;

@end

@protocol LoggerDelegate <NSObject>

- (void)logger:(Logger *)logger didLogMessage:(NSString *)message;

@end
