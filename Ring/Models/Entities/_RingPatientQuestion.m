// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingPatientQuestion.m instead.

#import "_RingPatientQuestion.h"

const struct RingPatientQuestionAttributes RingPatientQuestionAttributes = {
	.patientQuestionId = @"patientQuestionId",
	.question = @"question",
	.type = @"type",
};

const struct RingPatientQuestionRelationships RingPatientQuestionRelationships = {
	.extraQuestion = @"extraQuestion",
};

@implementation RingPatientQuestionID
@end

@implementation _RingPatientQuestion

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingPatientQuestion" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingPatientQuestion";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingPatientQuestion" inManagedObjectContext:moc_];
}

- (RingPatientQuestionID*)objectID {
	return (RingPatientQuestionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"patientQuestionIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"patientQuestionId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic patientQuestionId;

- (int32_t)patientQuestionIdValue {
	NSNumber *result = [self patientQuestionId];
	return [result intValue];
}

- (void)setPatientQuestionIdValue:(int32_t)value_ {
	[self setPatientQuestionId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePatientQuestionIdValue {
	NSNumber *result = [self primitivePatientQuestionId];
	return [result intValue];
}

- (void)setPrimitivePatientQuestionIdValue:(int32_t)value_ {
	[self setPrimitivePatientQuestionId:[NSNumber numberWithInt:value_]];
}

@dynamic question;

@dynamic type;

@dynamic extraQuestion;

@end

