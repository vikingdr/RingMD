// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingStoreSpeciality.m instead.

#import "_RingStoreSpeciality.h"

const struct RingStoreSpecialityAttributes RingStoreSpecialityAttributes = {
	.image = @"image",
	.name = @"name",
	.numDoctors = @"numDoctors",
	.specialityId = @"specialityId",
};

@implementation RingStoreSpecialityID
@end

@implementation _RingStoreSpeciality

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingStoreSpeciality" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingStoreSpeciality";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingStoreSpeciality" inManagedObjectContext:moc_];
}

- (RingStoreSpecialityID*)objectID {
	return (RingStoreSpecialityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"numDoctorsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"numDoctors"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"specialityIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"specialityId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic image;

@dynamic name;

@dynamic numDoctors;

- (int32_t)numDoctorsValue {
	NSNumber *result = [self numDoctors];
	return [result intValue];
}

- (void)setNumDoctorsValue:(int32_t)value_ {
	[self setNumDoctors:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveNumDoctorsValue {
	NSNumber *result = [self primitiveNumDoctors];
	return [result intValue];
}

- (void)setPrimitiveNumDoctorsValue:(int32_t)value_ {
	[self setPrimitiveNumDoctors:[NSNumber numberWithInt:value_]];
}

@dynamic specialityId;

- (int16_t)specialityIdValue {
	NSNumber *result = [self specialityId];
	return [result shortValue];
}

- (void)setSpecialityIdValue:(int16_t)value_ {
	[self setSpecialityId:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSpecialityIdValue {
	NSNumber *result = [self primitiveSpecialityId];
	return [result shortValue];
}

- (void)setPrimitiveSpecialityIdValue:(int16_t)value_ {
	[self setPrimitiveSpecialityId:[NSNumber numberWithShort:value_]];
}

@end

