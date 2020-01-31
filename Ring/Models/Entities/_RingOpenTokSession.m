// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingOpenTokSession.m instead.

#import "_RingOpenTokSession.h"

const struct RingOpenTokSessionAttributes RingOpenTokSessionAttributes = {
	.sessionId = @"sessionId",
	.token = @"token",
};

const struct RingOpenTokSessionRelationships RingOpenTokSessionRelationships = {
	.callRequest = @"callRequest",
};

@implementation RingOpenTokSessionID
@end

@implementation _RingOpenTokSession

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingOpenTokSession" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingOpenTokSession";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingOpenTokSession" inManagedObjectContext:moc_];
}

- (RingOpenTokSessionID*)objectID {
	return (RingOpenTokSessionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic sessionId;

@dynamic token;

@dynamic callRequest;

@end

