// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingPatientAnswer.m instead.

#import "_RingPatientAnswer.h"

const struct RingPatientAnswerAttributes RingPatientAnswerAttributes = {
	.answer = @"answer",
	.lastAnswer = @"lastAnswer",
	.patientAnswerId = @"patientAnswerId",
	.patientQuestionId = @"patientQuestionId",
	.value = @"value",
};

const struct RingPatientAnswerRelationships RingPatientAnswerRelationships = {
	.user = @"user",
};

@implementation RingPatientAnswerID
@end

@implementation _RingPatientAnswer

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingPatientAnswer" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingPatientAnswer";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingPatientAnswer" inManagedObjectContext:moc_];
}

- (RingPatientAnswerID*)objectID {
	return (RingPatientAnswerID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"patientAnswerIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"patientAnswerId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"patientQuestionIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"patientQuestionId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"valueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"value"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic answer;

@dynamic lastAnswer;

@dynamic patientAnswerId;

- (int32_t)patientAnswerIdValue {
	NSNumber *result = [self patientAnswerId];
	return [result intValue];
}

- (void)setPatientAnswerIdValue:(int32_t)value_ {
	[self setPatientAnswerId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePatientAnswerIdValue {
	NSNumber *result = [self primitivePatientAnswerId];
	return [result intValue];
}

- (void)setPrimitivePatientAnswerIdValue:(int32_t)value_ {
	[self setPrimitivePatientAnswerId:[NSNumber numberWithInt:value_]];
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

@dynamic value;

- (BOOL)valueValue {
	NSNumber *result = [self value];
	return [result boolValue];
}

- (void)setValueValue:(BOOL)value_ {
	[self setValue:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveValueValue {
	NSNumber *result = [self primitiveValue];
	return [result boolValue];
}

- (void)setPrimitiveValueValue:(BOOL)value_ {
	[self setPrimitiveValue:[NSNumber numberWithBool:value_]];
}

@dynamic user;

@end

