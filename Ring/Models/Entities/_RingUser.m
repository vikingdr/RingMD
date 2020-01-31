// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingUser.m instead.

#import "_RingUser.h"

const struct RingUserAttributes RingUserAttributes = {
	.about = @"about",
	.authToken = @"authToken",
	.avatar = @"avatar",
	.avatarFull = @"avatarFull",
	.canReview = @"canReview",
	.currentSymptoms = @"currentSymptoms",
	.currentTreatment = @"currentTreatment",
	.featuredRank = @"featuredRank",
	.licenseNumber = @"licenseNumber",
	.location = @"location",
	.name = @"name",
	.numCalls = @"numCalls",
	.numReviews = @"numReviews",
	.numSpecialities = @"numSpecialities",
	.numVideos = @"numVideos",
	.phoneCode = @"phoneCode",
	.phoneRawNumber = @"phoneRawNumber",
	.pricePerMinuteText = @"pricePerMinuteText",
	.profileId = @"profileId",
	.promotionalCode = @"promotionalCode",
	.rating = @"rating",
	.role = @"role",
	.type = @"type",
	.userId = @"userId",
};

const struct RingUserRelationships RingUserRelationships = {
	.businessHours = @"businessHours",
	.busyHours = @"busyHours",
	.callRequests = @"callRequests",
	.conversations = @"conversations",
	.favorites = @"favorites",
	.notifications = @"notifications",
	.patientAnswers = @"patientAnswers",
	.receiveMessages = @"receiveMessages",
	.receiveRequests = @"receiveRequests",
	.sentMessages = @"sentMessages",
	.specialities = @"specialities",
	.userFavorite = @"userFavorite",
};

@implementation RingUserID
@end

@implementation _RingUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingUser" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingUser";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingUser" inManagedObjectContext:moc_];
}

- (RingUserID*)objectID {
	return (RingUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"canReviewValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"canReview"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"featuredRankValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"featuredRank"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"numCallsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"numCalls"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"numReviewsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"numReviews"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"numSpecialitiesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"numSpecialities"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"numVideosValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"numVideos"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"profileIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"profileId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"ratingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rating"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"typeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"type"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"userIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"userId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic about;

@dynamic authToken;

@dynamic avatar;

@dynamic avatarFull;

@dynamic canReview;

- (BOOL)canReviewValue {
	NSNumber *result = [self canReview];
	return [result boolValue];
}

- (void)setCanReviewValue:(BOOL)value_ {
	[self setCanReview:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveCanReviewValue {
	NSNumber *result = [self primitiveCanReview];
	return [result boolValue];
}

- (void)setPrimitiveCanReviewValue:(BOOL)value_ {
	[self setPrimitiveCanReview:[NSNumber numberWithBool:value_]];
}

@dynamic currentSymptoms;

@dynamic currentTreatment;

@dynamic featuredRank;

- (int16_t)featuredRankValue {
	NSNumber *result = [self featuredRank];
	return [result shortValue];
}

- (void)setFeaturedRankValue:(int16_t)value_ {
	[self setFeaturedRank:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveFeaturedRankValue {
	NSNumber *result = [self primitiveFeaturedRank];
	return [result shortValue];
}

- (void)setPrimitiveFeaturedRankValue:(int16_t)value_ {
	[self setPrimitiveFeaturedRank:[NSNumber numberWithShort:value_]];
}

@dynamic licenseNumber;

@dynamic location;

@dynamic name;

@dynamic numCalls;

- (int32_t)numCallsValue {
	NSNumber *result = [self numCalls];
	return [result intValue];
}

- (void)setNumCallsValue:(int32_t)value_ {
	[self setNumCalls:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveNumCallsValue {
	NSNumber *result = [self primitiveNumCalls];
	return [result intValue];
}

- (void)setPrimitiveNumCallsValue:(int32_t)value_ {
	[self setPrimitiveNumCalls:[NSNumber numberWithInt:value_]];
}

@dynamic numReviews;

- (int32_t)numReviewsValue {
	NSNumber *result = [self numReviews];
	return [result intValue];
}

- (void)setNumReviewsValue:(int32_t)value_ {
	[self setNumReviews:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveNumReviewsValue {
	NSNumber *result = [self primitiveNumReviews];
	return [result intValue];
}

- (void)setPrimitiveNumReviewsValue:(int32_t)value_ {
	[self setPrimitiveNumReviews:[NSNumber numberWithInt:value_]];
}

@dynamic numSpecialities;

- (int16_t)numSpecialitiesValue {
	NSNumber *result = [self numSpecialities];
	return [result shortValue];
}

- (void)setNumSpecialitiesValue:(int16_t)value_ {
	[self setNumSpecialities:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveNumSpecialitiesValue {
	NSNumber *result = [self primitiveNumSpecialities];
	return [result shortValue];
}

- (void)setPrimitiveNumSpecialitiesValue:(int16_t)value_ {
	[self setPrimitiveNumSpecialities:[NSNumber numberWithShort:value_]];
}

@dynamic numVideos;

- (int32_t)numVideosValue {
	NSNumber *result = [self numVideos];
	return [result intValue];
}

- (void)setNumVideosValue:(int32_t)value_ {
	[self setNumVideos:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveNumVideosValue {
	NSNumber *result = [self primitiveNumVideos];
	return [result intValue];
}

- (void)setPrimitiveNumVideosValue:(int32_t)value_ {
	[self setPrimitiveNumVideos:[NSNumber numberWithInt:value_]];
}

@dynamic phoneCode;

@dynamic phoneRawNumber;

@dynamic pricePerMinuteText;

@dynamic profileId;

- (int32_t)profileIdValue {
	NSNumber *result = [self profileId];
	return [result intValue];
}

- (void)setProfileIdValue:(int32_t)value_ {
	[self setProfileId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveProfileIdValue {
	NSNumber *result = [self primitiveProfileId];
	return [result intValue];
}

- (void)setPrimitiveProfileIdValue:(int32_t)value_ {
	[self setPrimitiveProfileId:[NSNumber numberWithInt:value_]];
}

@dynamic promotionalCode;

@dynamic rating;

- (float)ratingValue {
	NSNumber *result = [self rating];
	return [result floatValue];
}

- (void)setRatingValue:(float)value_ {
	[self setRating:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveRatingValue {
	NSNumber *result = [self primitiveRating];
	return [result floatValue];
}

- (void)setPrimitiveRatingValue:(float)value_ {
	[self setPrimitiveRating:[NSNumber numberWithFloat:value_]];
}

@dynamic role;

@dynamic type;

- (int16_t)typeValue {
	NSNumber *result = [self type];
	return [result shortValue];
}

- (void)setTypeValue:(int16_t)value_ {
	[self setType:[NSNumber numberWithShort:value_]];
}

@dynamic userId;

- (int32_t)userIdValue {
	NSNumber *result = [self userId];
	return [result intValue];
}

- (void)setUserIdValue:(int32_t)value_ {
	[self setUserId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveUserIdValue {
	NSNumber *result = [self primitiveUserId];
	return [result intValue];
}

- (void)setPrimitiveUserIdValue:(int32_t)value_ {
	[self setPrimitiveUserId:[NSNumber numberWithInt:value_]];
}

@dynamic businessHours;

- (NSMutableSet*)businessHoursSet {
	[self willAccessValueForKey:@"businessHours"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"businessHours"];

	[self didAccessValueForKey:@"businessHours"];
	return result;
}

@dynamic busyHours;

- (NSMutableSet*)busyHoursSet {
	[self willAccessValueForKey:@"busyHours"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"busyHours"];

	[self didAccessValueForKey:@"busyHours"];
	return result;
}

@dynamic callRequests;

- (NSMutableSet*)callRequestsSet {
	[self willAccessValueForKey:@"callRequests"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"callRequests"];

	[self didAccessValueForKey:@"callRequests"];
	return result;
}

@dynamic conversations;

- (NSMutableSet*)conversationsSet {
	[self willAccessValueForKey:@"conversations"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"conversations"];

	[self didAccessValueForKey:@"conversations"];
	return result;
}

@dynamic favorites;

- (NSMutableOrderedSet*)favoritesSet {
	[self willAccessValueForKey:@"favorites"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"favorites"];

	[self didAccessValueForKey:@"favorites"];
	return result;
}

@dynamic notifications;

- (NSMutableSet*)notificationsSet {
	[self willAccessValueForKey:@"notifications"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"notifications"];

	[self didAccessValueForKey:@"notifications"];
	return result;
}

@dynamic patientAnswers;

- (NSMutableSet*)patientAnswersSet {
	[self willAccessValueForKey:@"patientAnswers"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"patientAnswers"];

	[self didAccessValueForKey:@"patientAnswers"];
	return result;
}

@dynamic receiveMessages;

- (NSMutableSet*)receiveMessagesSet {
	[self willAccessValueForKey:@"receiveMessages"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"receiveMessages"];

	[self didAccessValueForKey:@"receiveMessages"];
	return result;
}

@dynamic receiveRequests;

- (NSMutableSet*)receiveRequestsSet {
	[self willAccessValueForKey:@"receiveRequests"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"receiveRequests"];

	[self didAccessValueForKey:@"receiveRequests"];
	return result;
}

@dynamic sentMessages;

- (NSMutableSet*)sentMessagesSet {
	[self willAccessValueForKey:@"sentMessages"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"sentMessages"];

	[self didAccessValueForKey:@"sentMessages"];
	return result;
}

@dynamic specialities;

- (NSMutableSet*)specialitiesSet {
	[self willAccessValueForKey:@"specialities"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"specialities"];

	[self didAccessValueForKey:@"specialities"];
	return result;
}

@dynamic userFavorite;

@end

@implementation _RingUser (FavoritesCoreDataGeneratedAccessors)
- (void)addFavorites:(NSOrderedSet*)value_ {
	[self.favoritesSet unionOrderedSet:value_];
}
- (void)removeFavorites:(NSOrderedSet*)value_ {
	[self.favoritesSet minusOrderedSet:value_];
}
- (void)addFavoritesObject:(RingUser*)value_ {
	[self.favoritesSet addObject:value_];
}
- (void)removeFavoritesObject:(RingUser*)value_ {
	[self.favoritesSet removeObject:value_];
}
- (void)insertObject:(RingUser*)value inFavoritesAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"favorites"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self favorites]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"favorites"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"favorites"];
}
- (void)removeObjectFromFavoritesAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"favorites"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self favorites]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"favorites"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"favorites"];
}
- (void)insertFavorites:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"favorites"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self favorites]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"favorites"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"favorites"];
}
- (void)removeFavoritesAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"favorites"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self favorites]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"favorites"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"favorites"];
}
- (void)replaceObjectInFavoritesAtIndex:(NSUInteger)idx withObject:(RingUser*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"favorites"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self favorites]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"favorites"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"favorites"];
}
- (void)replaceFavoritesAtIndexes:(NSIndexSet *)indexes withFavorites:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"favorites"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self favorites]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"favorites"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"favorites"];
}
@end

