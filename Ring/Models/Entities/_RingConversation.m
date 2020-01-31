// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingConversation.m instead.

#import "_RingConversation.h"

const struct RingConversationAttributes RingConversationAttributes = {
	.unreadCount = @"unreadCount",
};

const struct RingConversationRelationships RingConversationRelationships = {
	.latestMessage = @"latestMessage",
	.messages = @"messages",
	.users = @"users",
};

@implementation RingConversationID
@end

@implementation _RingConversation

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingConversation" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingConversation";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingConversation" inManagedObjectContext:moc_];
}

- (RingConversationID*)objectID {
	return (RingConversationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"unreadCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"unreadCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic unreadCount;

- (int16_t)unreadCountValue {
	NSNumber *result = [self unreadCount];
	return [result shortValue];
}

- (void)setUnreadCountValue:(int16_t)value_ {
	[self setUnreadCount:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveUnreadCountValue {
	NSNumber *result = [self primitiveUnreadCount];
	return [result shortValue];
}

- (void)setPrimitiveUnreadCountValue:(int16_t)value_ {
	[self setPrimitiveUnreadCount:[NSNumber numberWithShort:value_]];
}

@dynamic latestMessage;

@dynamic messages;

- (NSMutableSet*)messagesSet {
	[self willAccessValueForKey:@"messages"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"messages"];

	[self didAccessValueForKey:@"messages"];
	return result;
}

@dynamic users;

- (NSMutableSet*)usersSet {
	[self willAccessValueForKey:@"users"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"users"];

	[self didAccessValueForKey:@"users"];
	return result;
}

@end

