// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingBusinessHour.m instead.

#import "_RingBusinessHour.h"

const struct RingBusinessHourAttributes RingBusinessHourAttributes = {
	.from = @"from",
	.to = @"to",
};

const struct RingBusinessHourRelationships RingBusinessHourRelationships = {
	.user = @"user",
};

@implementation RingBusinessHourID
@end

@implementation _RingBusinessHour

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingBusinessHour" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingBusinessHour";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingBusinessHour" inManagedObjectContext:moc_];
}

- (RingBusinessHourID*)objectID {
	return (RingBusinessHourID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic from;

@dynamic to;

@dynamic user;

@end

