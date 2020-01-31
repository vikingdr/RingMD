// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingCallRequest.m instead.

#import "_RingCallRequest.h"

const struct RingCallRequestAttributes RingCallRequestAttributes = {
	.callRequestId = @"callRequestId",
	.callTime = @"callTime",
	.currency = @"currency",
	.doctorJoined = @"doctorJoined",
	.durationEstimate = @"durationEstimate",
	.numberPhone = @"numberPhone",
	.patientJoined = @"patientJoined",
	.price = @"price",
	.rate = @"rate",
	.reason = @"reason",
	.state = @"state",
	.type = @"type",
};

const struct RingCallRequestRelationships RingCallRequestRelationships = {
	.caller = @"caller",
	.openTokSesion = @"openTokSesion",
	.receiver = @"receiver",
	.timeSlots = @"timeSlots",
};

@implementation RingCallRequestID
@end

@implementation _RingCallRequest

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingCallRequest" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingCallRequest";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingCallRequest" inManagedObjectContext:moc_];
}

- (RingCallRequestID*)objectID {
	return (RingCallRequestID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"callRequestIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"callRequestId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"doctorJoinedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"doctorJoined"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"durationEstimateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"durationEstimate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"patientJoinedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"patientJoined"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"rateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic callRequestId;

- (int32_t)callRequestIdValue {
	NSNumber *result = [self callRequestId];
	return [result intValue];
}

- (void)setCallRequestIdValue:(int32_t)value_ {
	[self setCallRequestId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveCallRequestIdValue {
	NSNumber *result = [self primitiveCallRequestId];
	return [result intValue];
}

- (void)setPrimitiveCallRequestIdValue:(int32_t)value_ {
	[self setPrimitiveCallRequestId:[NSNumber numberWithInt:value_]];
}

@dynamic callTime;

@dynamic currency;

@dynamic doctorJoined;

- (BOOL)doctorJoinedValue {
	NSNumber *result = [self doctorJoined];
	return [result boolValue];
}

- (void)setDoctorJoinedValue:(BOOL)value_ {
	[self setDoctorJoined:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveDoctorJoinedValue {
	NSNumber *result = [self primitiveDoctorJoined];
	return [result boolValue];
}

- (void)setPrimitiveDoctorJoinedValue:(BOOL)value_ {
	[self setPrimitiveDoctorJoined:[NSNumber numberWithBool:value_]];
}

@dynamic durationEstimate;

- (int32_t)durationEstimateValue {
	NSNumber *result = [self durationEstimate];
	return [result intValue];
}

- (void)setDurationEstimateValue:(int32_t)value_ {
	[self setDurationEstimate:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveDurationEstimateValue {
	NSNumber *result = [self primitiveDurationEstimate];
	return [result intValue];
}

- (void)setPrimitiveDurationEstimateValue:(int32_t)value_ {
	[self setPrimitiveDurationEstimate:[NSNumber numberWithInt:value_]];
}

@dynamic numberPhone;

@dynamic patientJoined;

- (BOOL)patientJoinedValue {
	NSNumber *result = [self patientJoined];
	return [result boolValue];
}

- (void)setPatientJoinedValue:(BOOL)value_ {
	[self setPatientJoined:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitivePatientJoinedValue {
	NSNumber *result = [self primitivePatientJoined];
	return [result boolValue];
}

- (void)setPrimitivePatientJoinedValue:(BOOL)value_ {
	[self setPrimitivePatientJoined:[NSNumber numberWithBool:value_]];
}

@dynamic price;

@dynamic rate;

- (float)rateValue {
	NSNumber *result = [self rate];
	return [result floatValue];
}

- (void)setRateValue:(float)value_ {
	[self setRate:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveRateValue {
	NSNumber *result = [self primitiveRate];
	return [result floatValue];
}

- (void)setPrimitiveRateValue:(float)value_ {
	[self setPrimitiveRate:[NSNumber numberWithFloat:value_]];
}

@dynamic reason;

@dynamic state;

@dynamic type;

@dynamic caller;

@dynamic openTokSesion;

@dynamic receiver;

@dynamic timeSlots;

- (NSMutableOrderedSet*)timeSlotsSet {
	[self willAccessValueForKey:@"timeSlots"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"timeSlots"];

	[self didAccessValueForKey:@"timeSlots"];
	return result;
}

@end

@implementation _RingCallRequest (TimeSlotsCoreDataGeneratedAccessors)
- (void)addTimeSlots:(NSOrderedSet*)value_ {
	[self.timeSlotsSet unionOrderedSet:value_];
}
- (void)removeTimeSlots:(NSOrderedSet*)value_ {
	[self.timeSlotsSet minusOrderedSet:value_];
}
- (void)addTimeSlotsObject:(RingTimeSlot*)value_ {
	[self.timeSlotsSet addObject:value_];
}
- (void)removeTimeSlotsObject:(RingTimeSlot*)value_ {
	[self.timeSlotsSet removeObject:value_];
}
- (void)insertObject:(RingTimeSlot*)value inTimeSlotsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"timeSlots"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self timeSlots]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"timeSlots"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"timeSlots"];
}
- (void)removeObjectFromTimeSlotsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"timeSlots"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self timeSlots]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"timeSlots"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"timeSlots"];
}
- (void)insertTimeSlots:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"timeSlots"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self timeSlots]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"timeSlots"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"timeSlots"];
}
- (void)removeTimeSlotsAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"timeSlots"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self timeSlots]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"timeSlots"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"timeSlots"];
}
- (void)replaceObjectInTimeSlotsAtIndex:(NSUInteger)idx withObject:(RingTimeSlot*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"timeSlots"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self timeSlots]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"timeSlots"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"timeSlots"];
}
- (void)replaceTimeSlotsAtIndexes:(NSIndexSet *)indexes withTimeSlots:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"timeSlots"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self timeSlots]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"timeSlots"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"timeSlots"];
}
@end

