// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingBusyHour.m instead.

#import "_RingBusyHour.h"

const struct RingBusyHourAttributes RingBusyHourAttributes = {
	.busyHourId = @"busyHourId",
	.from = @"from",
	.to = @"to",
};

const struct RingBusyHourRelationships RingBusyHourRelationships = {
	.user = @"user",
};

@implementation RingBusyHourID
@end

@implementation _RingBusyHour

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingBusyHour" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingBusyHour";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingBusyHour" inManagedObjectContext:moc_];
}

- (RingBusyHourID*)objectID {
	return (RingBusyHourID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"busyHourIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"busyHourId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic busyHourId;

- (int32_t)busyHourIdValue {
	NSNumber *result = [self busyHourId];
	return [result intValue];
}

- (void)setBusyHourIdValue:(int32_t)value_ {
	[self setBusyHourId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveBusyHourIdValue {
	NSNumber *result = [self primitiveBusyHourId];
	return [result intValue];
}

- (void)setPrimitiveBusyHourIdValue:(int32_t)value_ {
	[self setPrimitiveBusyHourId:[NSNumber numberWithInt:value_]];
}

@dynamic from;

@dynamic to;

@dynamic user;

@end

