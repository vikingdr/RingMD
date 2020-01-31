// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingCreditCard.m instead.

#import "_RingCreditCard.h"

const struct RingCreditCardAttributes RingCreditCardAttributes = {
	.brandType = @"brandType",
	.code = @"code",
	.creditCardId = @"creditCardId",
	.expireMonth = @"expireMonth",
	.expireYear = @"expireYear",
	.holder = @"holder",
	.memberId = @"memberId",
	.number = @"number",
	.showNumber = @"showNumber",
};

@implementation RingCreditCardID
@end

@implementation _RingCreditCard

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingCreditCard" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingCreditCard";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingCreditCard" inManagedObjectContext:moc_];
}

- (RingCreditCardID*)objectID {
	return (RingCreditCardID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"brandTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"brandType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"codeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"code"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"creditCardIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"creditCardId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"expireMonthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"expireMonth"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"expireYearValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"expireYear"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic brandType;

- (int16_t)brandTypeValue {
	NSNumber *result = [self brandType];
	return [result shortValue];
}

- (void)setBrandTypeValue:(int16_t)value_ {
	[self setBrandType:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveBrandTypeValue {
	NSNumber *result = [self primitiveBrandType];
	return [result shortValue];
}

- (void)setPrimitiveBrandTypeValue:(int16_t)value_ {
	[self setPrimitiveBrandType:[NSNumber numberWithShort:value_]];
}

@dynamic code;

- (int16_t)codeValue {
	NSNumber *result = [self code];
	return [result shortValue];
}

- (void)setCodeValue:(int16_t)value_ {
	[self setCode:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveCodeValue {
	NSNumber *result = [self primitiveCode];
	return [result shortValue];
}

- (void)setPrimitiveCodeValue:(int16_t)value_ {
	[self setPrimitiveCode:[NSNumber numberWithShort:value_]];
}

@dynamic creditCardId;

- (int32_t)creditCardIdValue {
	NSNumber *result = [self creditCardId];
	return [result intValue];
}

- (void)setCreditCardIdValue:(int32_t)value_ {
	[self setCreditCardId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveCreditCardIdValue {
	NSNumber *result = [self primitiveCreditCardId];
	return [result intValue];
}

- (void)setPrimitiveCreditCardIdValue:(int32_t)value_ {
	[self setPrimitiveCreditCardId:[NSNumber numberWithInt:value_]];
}

@dynamic expireMonth;

- (int16_t)expireMonthValue {
	NSNumber *result = [self expireMonth];
	return [result shortValue];
}

- (void)setExpireMonthValue:(int16_t)value_ {
	[self setExpireMonth:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveExpireMonthValue {
	NSNumber *result = [self primitiveExpireMonth];
	return [result shortValue];
}

- (void)setPrimitiveExpireMonthValue:(int16_t)value_ {
	[self setPrimitiveExpireMonth:[NSNumber numberWithShort:value_]];
}

@dynamic expireYear;

- (int16_t)expireYearValue {
	NSNumber *result = [self expireYear];
	return [result shortValue];
}

- (void)setExpireYearValue:(int16_t)value_ {
	[self setExpireYear:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveExpireYearValue {
	NSNumber *result = [self primitiveExpireYear];
	return [result shortValue];
}

- (void)setPrimitiveExpireYearValue:(int16_t)value_ {
	[self setPrimitiveExpireYear:[NSNumber numberWithShort:value_]];
}

@dynamic holder;

@dynamic memberId;

@dynamic number;

@dynamic showNumber;

@end

