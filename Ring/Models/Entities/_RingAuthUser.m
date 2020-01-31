// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingAuthUser.m instead.

#import "_RingAuthUser.h"

const struct RingAuthUserAttributes RingAuthUserAttributes = {
	.about = @"about",
	.authToken = @"authToken",
	.avatar = @"avatar",
	.currency = @"currency",
	.email = @"email",
	.image = @"image",
	.isDoctor = @"isDoctor",
	.licenseNumber = @"licenseNumber",
	.location = @"location",
	.name = @"name",
	.numDoctors = @"numDoctors",
	.numMessageNotification = @"numMessageNotification",
	.numRequestNotification = @"numRequestNotification",
	.password = @"password",
	.phoneCode = @"phoneCode",
	.phoneRawNumber = @"phoneRawNumber",
	.pricePerHour = @"pricePerHour",
	.promotionalCode = @"promotionalCode",
	.specialityId = @"specialityId",
	.userId = @"userId",
};

@implementation RingAuthUserID
@end

@implementation _RingAuthUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingAuthUser" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingAuthUser";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingAuthUser" inManagedObjectContext:moc_];
}

- (RingAuthUserID*)objectID {
	return (RingAuthUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"isDoctorValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isDoctor"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"numDoctorsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"numDoctors"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"numMessageNotificationValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"numMessageNotification"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"numRequestNotificationValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"numRequestNotification"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"pricePerHourValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"pricePerHour"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"specialityIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"specialityId"];
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

@dynamic currency;

@dynamic email;

@dynamic image;

@dynamic isDoctor;

- (BOOL)isDoctorValue {
	NSNumber *result = [self isDoctor];
	return [result boolValue];
}

- (void)setIsDoctorValue:(BOOL)value_ {
	[self setIsDoctor:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsDoctorValue {
	NSNumber *result = [self primitiveIsDoctor];
	return [result boolValue];
}

- (void)setPrimitiveIsDoctorValue:(BOOL)value_ {
	[self setPrimitiveIsDoctor:[NSNumber numberWithBool:value_]];
}

@dynamic licenseNumber;

@dynamic location;

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

@dynamic numMessageNotification;

- (int16_t)numMessageNotificationValue {
	NSNumber *result = [self numMessageNotification];
	return [result shortValue];
}

- (void)setNumMessageNotificationValue:(int16_t)value_ {
	[self setNumMessageNotification:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveNumMessageNotificationValue {
	NSNumber *result = [self primitiveNumMessageNotification];
	return [result shortValue];
}

- (void)setPrimitiveNumMessageNotificationValue:(int16_t)value_ {
	[self setPrimitiveNumMessageNotification:[NSNumber numberWithShort:value_]];
}

@dynamic numRequestNotification;

- (int16_t)numRequestNotificationValue {
	NSNumber *result = [self numRequestNotification];
	return [result shortValue];
}

- (void)setNumRequestNotificationValue:(int16_t)value_ {
	[self setNumRequestNotification:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveNumRequestNotificationValue {
	NSNumber *result = [self primitiveNumRequestNotification];
	return [result shortValue];
}

- (void)setPrimitiveNumRequestNotificationValue:(int16_t)value_ {
	[self setPrimitiveNumRequestNotification:[NSNumber numberWithShort:value_]];
}

@dynamic password;

@dynamic phoneCode;

@dynamic phoneRawNumber;

@dynamic pricePerHour;

- (float)pricePerHourValue {
	NSNumber *result = [self pricePerHour];
	return [result floatValue];
}

- (void)setPricePerHourValue:(float)value_ {
	[self setPricePerHour:[NSNumber numberWithFloat:value_]];
}

- (float)primitivePricePerHourValue {
	NSNumber *result = [self primitivePricePerHour];
	return [result floatValue];
}

- (void)setPrimitivePricePerHourValue:(float)value_ {
	[self setPrimitivePricePerHour:[NSNumber numberWithFloat:value_]];
}

@dynamic promotionalCode;

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

@end

