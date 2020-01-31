// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingMessage.m instead.

#import "_RingMessage.h"

const struct RingMessageAttributes RingMessageAttributes = {
	.content = @"content",
	.createdAt = @"createdAt",
	.messageId = @"messageId",
};

const struct RingMessageRelationships RingMessageRelationships = {
	.attachFile = @"attachFile",
	.conversation = @"conversation",
	.conversationLatest = @"conversationLatest",
	.receiver = @"receiver",
	.sender = @"sender",
};

@implementation RingMessageID
@end

@implementation _RingMessage

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingMessage" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingMessage";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingMessage" inManagedObjectContext:moc_];
}

- (RingMessageID*)objectID {
	return (RingMessageID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"messageIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"messageId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic content;

@dynamic createdAt;

@dynamic messageId;

- (int32_t)messageIdValue {
	NSNumber *result = [self messageId];
	return [result intValue];
}

- (void)setMessageIdValue:(int32_t)value_ {
	[self setMessageId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveMessageIdValue {
	NSNumber *result = [self primitiveMessageId];
	return [result intValue];
}

- (void)setPrimitiveMessageIdValue:(int32_t)value_ {
	[self setPrimitiveMessageId:[NSNumber numberWithInt:value_]];
}

@dynamic attachFile;

@dynamic conversation;

@dynamic conversationLatest;

@dynamic receiver;

@dynamic sender;

@end

