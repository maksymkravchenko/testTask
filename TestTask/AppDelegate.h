//
//  AppDelegate.h
//  TestTask
//
//  Created by Maksym Kravchenko on 10/10/16.
//  Copyright © 2016 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class WebSocketService;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, readonly) WebSocketService *webSocketService;
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

