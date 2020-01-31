// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingTimeSlotInMonth.m instead.

#import "_RingTimeSlotInMonth.h"

const struct RingTimeSlotInMonthAttributes RingTimeSlotInMonthAttributes = {
	.endTime = @"endTime",
	.startTime = @"startTime",
	.state = @"state",
	.status = @"status",
	.timeSlotInMonthId = @"timeSlotInMonthId",
	.type = @"type",
};

@implementation RingTimeSlotInMonthID
@end

@implementation _RingTimeSlotInMonth

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingTimeSlotInMonth" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingTimeSlotInMonth";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingTimeSlotInMonth" inManagedObjectContext:moc_];
}

- (RingTimeSlotInMonthID*)objectID {
	return (RingTimeSlotInMonthID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"timeSlotInMonthIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"timeSlotInMonthId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic endTime;

@dynamic startTime;

@dynamic state;

@dynamic status;

@dynamic timeSlotInMonthId;

- (int32_t)timeSlotInMonthIdValue {
	NSNumber *result = [self timeSlotInMonthId];
	return [result intValue];
}

- (void)setTimeSlotInMonthIdValue:(int32_t)value_ {
	[self setTimeSlotInMonthId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTimeSlotInMonthIdValue {
	NSNumber *result = [self primitiveTimeSlotInMonthId];
	return [result intValue];
}

- (void)setPrimitiveTimeSlotInMonthIdValue:(int32_t)value_ {
	[self setPrimitiveTimeSlotInMonthId:[NSNumber numberWithInt:value_]];
}

@dynamic type;

@end

