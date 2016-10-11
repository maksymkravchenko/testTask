//
//  Message+CoreDataProperties.h
//  
//
//  Created by Maksym Kravchenko on 10/11/16.
//
//

#import "Message+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Message (CoreDataProperties)

+ (NSFetchRequest<Message *> *)fetchRequest;

@property (nonatomic) int16_t type;
@property (nonatomic) int64_t updateDate;
@property (nullable, nonatomic, retain) NSObject *content;
@property (nonatomic) BOOL boolValue;
@property (nonatomic) BOOL sent;

@end

NS_ASSUME_NONNULL_END
