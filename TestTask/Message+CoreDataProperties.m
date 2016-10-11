//
//  Message+CoreDataProperties.m
//  
//
//  Created by Maksym Kravchenko on 10/11/16.
//
//

#import "Message+CoreDataProperties.h"

@implementation Message (CoreDataProperties)

+ (NSFetchRequest<Message *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Message"];
}

@dynamic type;
@dynamic updateDate;
@dynamic content;
@dynamic boolValue;
@dynamic sent;

@end
