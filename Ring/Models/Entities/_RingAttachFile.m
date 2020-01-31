// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingAttachFile.m instead.

#import "_RingAttachFile.h"

const struct RingAttachFileAttributes RingAttachFileAttributes = {
	.attachFileId = @"attachFileId",
	.contentType = @"contentType",
	.name = @"name",
	.tempFilePath = @"tempFilePath",
};

const struct RingAttachFileRelationships RingAttachFileRelationships = {
	.message = @"message",
};

@implementation RingAttachFileID
@end

@implementation _RingAttachFile

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingAttachFile" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingAttachFile";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingAttachFile" inManagedObjectContext:moc_];
}

- (RingAttachFileID*)objectID {
	return (RingAttachFileID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"attachFileIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"attachFileId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic attachFileId;

- (int32_t)attachFileIdValue {
	NSNumber *result = [self attachFileId];
	return [result intValue];
}

- (void)setAttachFileIdValue:(int32_t)value_ {
	[self setAttachFileId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveAttachFileIdValue {
	NSNumber *result = [self primitiveAttachFileId];
	return [result intValue];
}

- (void)setPrimitiveAttachFileIdValue:(int32_t)value_ {
	[self setPrimitiveAttachFileId:[NSNumber numberWithInt:value_]];
}

@dynamic contentType;

@dynamic name;

@dynamic tempFilePath;

@dynamic message;

@end

