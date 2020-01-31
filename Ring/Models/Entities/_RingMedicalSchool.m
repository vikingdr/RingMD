// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingMedicalSchool.m instead.

#import "_RingMedicalSchool.h"

const struct RingMedicalSchoolAttributes RingMedicalSchoolAttributes = {
	.medicalSchoolId = @"medicalSchoolId",
	.name = @"name",
};

@implementation RingMedicalSchoolID
@end

@implementation _RingMedicalSchool

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingMedicalSchool" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingMedicalSchool";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingMedicalSchool" inManagedObjectContext:moc_];
}

- (RingMedicalSchoolID*)objectID {
	return (RingMedicalSchoolID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"medicalSchoolIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"medicalSchoolId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic medicalSchoolId;

- (int16_t)medicalSchoolIdValue {
	NSNumber *result = [self medicalSchoolId];
	return [result shortValue];
}

- (void)setMedicalSchoolIdValue:(int16_t)value_ {
	[self setMedicalSchoolId:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveMedicalSchoolIdValue {
	NSNumber *result = [self primitiveMedicalSchoolId];
	return [result shortValue];
}

- (void)setPrimitiveMedicalSchoolIdValue:(int16_t)value_ {
	[self setPrimitiveMedicalSchoolId:[NSNumber numberWithShort:value_]];
}

@dynamic name;

@end

