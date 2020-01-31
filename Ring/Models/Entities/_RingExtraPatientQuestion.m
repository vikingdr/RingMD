// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingExtraPatientQuestion.m instead.

#import "_RingExtraPatientQuestion.h"

const struct RingExtraPatientQuestionAttributes RingExtraPatientQuestionAttributes = {
	.extraPatientQuestionId = @"extraPatientQuestionId",
	.options = @"options",
	.question = @"question",
	.type = @"type",
};

const struct RingExtraPatientQuestionRelationships RingExtraPatientQuestionRelationships = {
	.parent = @"parent",
};

@implementation RingExtraPatientQuestionID
@end

@implementation _RingExtraPatientQuestion

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingExtraPatientQuestion" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingExtraPatientQuestion";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingExtraPatientQuestion" inManagedObjectContext:moc_];
}

- (RingExtraPatientQuestionID*)objectID {
	return (RingExtraPatientQuestionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"extraPatientQuestionIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"extraPatientQuestionId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic extraPatientQuestionId;

- (int32_t)extraPatientQuestionIdValue {
	NSNumber *result = [self extraPatientQuestionId];
	return [result intValue];
}

- (void)setExtraPatientQuestionIdValue:(int32_t)value_ {
	[self setExtraPatientQuestionId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveExtraPatientQuestionIdValue {
	NSNumber *result = [self primitiveExtraPatientQuestionId];
	return [result intValue];
}

- (void)setPrimitiveExtraPatientQuestionIdValue:(int32_t)value_ {
	[self setPrimitiveExtraPatientQuestionId:[NSNumber numberWithInt:value_]];
}

@dynamic options;

@dynamic question;

@dynamic type;

@dynamic parent;

@end

