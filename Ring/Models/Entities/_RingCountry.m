// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingCountry.m instead.

#import "_RingCountry.h"

const struct RingCountryAttributes RingCountryAttributes = {
	.countryId = @"countryId",
	.name = @"name",
};

@implementation RingCountryID
@end

@implementation _RingCountry

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingCountry" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingCountry";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingCountry" inManagedObjectContext:moc_];
}

- (RingCountryID*)objectID {
	return (RingCountryID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"countryIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"countryId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic countryId;

- (int16_t)countryIdValue {
	NSNumber *result = [self countryId];
	return [result shortValue];
}

- (void)setCountryIdValue:(int16_t)value_ {
	[self setCountryId:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveCountryIdValue {
	NSNumber *result = [self primitiveCountryId];
	return [result shortValue];
}

- (void)setPrimitiveCountryIdValue:(int16_t)value_ {
	[self setPrimitiveCountryId:[NSNumber numberWithShort:value_]];
}

@dynamic name;

@end

