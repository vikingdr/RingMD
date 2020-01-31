// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingNotification.m instead.

#import "_RingNotification.h"

const struct RingNotificationAttributes RingNotificationAttributes = {
	.createdAt = @"createdAt",
	.image = @"image",
	.message = @"message",
	.notificationId = @"notificationId",
	.notificationObjectId = @"notificationObjectId",
	.notificationType = @"notificationType",
};

const struct RingNotificationRelationships RingNotificationRelationships = {
	.actionUser = @"actionUser",
};

@implementation RingNotificationID
@end

@implementation _RingNotification

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingNotification" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingNotification";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingNotification" inManagedObjectContext:moc_];
}

- (RingNotificationID*)objectID {
	return (RingNotificationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"notificationIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"notificationId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"notificationObjectIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"notificationObjectId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic createdAt;

@dynamic image;

@dynamic message;

@dynamic notificationId;

- (int32_t)notificationIdValue {
	NSNumber *result = [self notificationId];
	return [result intValue];
}

- (void)setNotificationIdValue:(int32_t)value_ {
	[self setNotificationId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveNotificationIdValue {
	NSNumber *result = [self primitiveNotificationId];
	return [result intValue];
}

- (void)setPrimitiveNotificationIdValue:(int32_t)value_ {
	[self setPrimitiveNotificationId:[NSNumber numberWithInt:value_]];
}

@dynamic notificationObjectId;

- (int32_t)notificationObjectIdValue {
	NSNumber *result = [self notificationObjectId];
	return [result intValue];
}

- (void)setNotificationObjectIdValue:(int32_t)value_ {
	[self setNotificationObjectId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveNotificationObjectIdValue {
	NSNumber *result = [self primitiveNotificationObjectId];
	return [result intValue];
}

- (void)setPrimitiveNotificationObjectIdValue:(int32_t)value_ {
	[self setPrimitiveNotificationObjectId:[NSNumber numberWithInt:value_]];
}

@dynamic notificationType;

@dynamic actionUser;

@end

