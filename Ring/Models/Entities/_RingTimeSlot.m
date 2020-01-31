// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingTimeSlot.m instead.

#import "_RingTimeSlot.h"

const struct RingTimeSlotAttributes RingTimeSlotAttributes = {
	.callTime = @"callTime",
	.state = @"state",
	.timeSlotId = @"timeSlotId",
};

const struct RingTimeSlotRelationships RingTimeSlotRelationships = {
	.callRequest = @"callRequest",
};

@implementation RingTimeSlotID
@end

@implementation _RingTimeSlot

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingTimeSlot" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingTimeSlot";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingTimeSlot" inManagedObjectContext:moc_];
}

- (RingTimeSlotID*)objectID {
	return (RingTimeSlotID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"timeSlotIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"timeSlotId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic callTime;

@dynamic state;

@dynamic timeSlotId;

- (int32_t)timeSlotIdValue {
	NSNumber *result = [self timeSlotId];
	return [result intValue];
}

- (void)setTimeSlotIdValue:(int32_t)value_ {
	[self setTimeSlotId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTimeSlotIdValue {
	NSNumber *result = [self primitiveTimeSlotId];
	return [result intValue];
}

- (void)setPrimitiveTimeSlotIdValue:(int32_t)value_ {
	[self setPrimitiveTimeSlotId:[NSNumber numberWithInt:value_]];
}

@dynamic callRequest;

@end

