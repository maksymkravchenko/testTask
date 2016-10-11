//
//  Message+CoreDataClass.h
//  
//
//  Created by Maksym Kravchenko on 10/11/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSObject;

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kMessageKey;

@interface Message : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Message+CoreDataProperties.h"
