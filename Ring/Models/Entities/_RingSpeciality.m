// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingSpeciality.m instead.

#import "_RingSpeciality.h"

const struct RingSpecialityAttributes RingSpecialityAttributes = {
	.displayName = @"displayName",
	.image = @"image",
	.name = @"name",
	.numDoctors = @"numDoctors",
	.parentId = @"parentId",
	.specialityId = @"specialityId",
};

const struct RingSpecialityRelationships RingSpecialityRelationships = {
	.children = @"children",
	.doctors = @"doctors",
	.parent = @"parent",
};

@implementation RingSpecialityID
@end

@implementation _RingSpeciality

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RingSpeciality" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RingSpeciality";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RingSpeciality" inManagedObjectContext:moc_];
}

- (RingSpecialityID*)objectID {
	return (RingSpecialityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"numDoctorsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"numDoctors"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"parentIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"parentId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"specialityIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"specialityId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic displayName;

@dynamic image;

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

@dynamic parentId;

- (int32_t)parentIdValue {
	NSNumber *result = [self parentId];
	return [result intValue];
}

- (void)setParentIdValue:(int32_t)value_ {
	[self setParentId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveParentIdValue {
	NSNumber *result = [self primitiveParentId];
	return [result intValue];
}

- (void)setPrimitiveParentIdValue:(int32_t)value_ {
	[self setPrimitiveParentId:[NSNumber numberWithInt:value_]];
}

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

@dynamic children;

- (NSMutableOrderedSet*)childrenSet {
	[self willAccessValueForKey:@"children"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"children"];

	[self didAccessValueForKey:@"children"];
	return result;
}

@dynamic doctors;

- (NSMutableOrderedSet*)doctorsSet {
	[self willAccessValueForKey:@"doctors"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"doctors"];

	[self didAccessValueForKey:@"doctors"];
	return result;
}

@dynamic parent;

@end

@implementation _RingSpeciality (ChildrenCoreDataGeneratedAccessors)
- (void)addChildren:(NSOrderedSet*)value_ {
	[self.childrenSet unionOrderedSet:value_];
}
- (void)removeChildren:(NSOrderedSet*)value_ {
	[self.childrenSet minusOrderedSet:value_];
}
- (void)addChildrenObject:(RingSpeciality*)value_ {
	[self.childrenSet addObject:value_];
}
- (void)removeChildrenObject:(RingSpeciality*)value_ {
	[self.childrenSet removeObject:value_];
}
- (void)insertObject:(RingSpeciality*)value inChildrenAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"children"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self children]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"children"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"children"];
}
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"children"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self children]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"children"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"children"];
}
- (void)insertChildren:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"children"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self children]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"children"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"children"];
}
- (void)removeChildrenAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"children"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self children]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"children"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"children"];
}
- (void)replaceObjectInChildrenAtIndex:(NSUInteger)idx withObject:(RingSpeciality*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"children"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self children]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"children"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"children"];
}
- (void)replaceChildrenAtIndexes:(NSIndexSet *)indexes withChildren:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"children"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self children]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"children"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"children"];
}
@end

@implementation _RingSpeciality (DoctorsCoreDataGeneratedAccessors)
- (void)addDoctors:(NSOrderedSet*)value_ {
	[self.doctorsSet unionOrderedSet:value_];
}
- (void)removeDoctors:(NSOrderedSet*)value_ {
	[self.doctorsSet minusOrderedSet:value_];
}
- (void)addDoctorsObject:(RingUser*)value_ {
	[self.doctorsSet addObject:value_];
}
- (void)removeDoctorsObject:(RingUser*)value_ {
	[self.doctorsSet removeObject:value_];
}
- (void)insertObject:(RingUser*)value inDoctorsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"doctors"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self doctors]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"doctors"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"doctors"];
}
- (void)removeObjectFromDoctorsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"doctors"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self doctors]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"doctors"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"doctors"];
}
- (void)insertDoctors:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"doctors"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self doctors]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"doctors"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"doctors"];
}
- (void)removeDoctorsAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"doctors"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self doctors]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"doctors"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"doctors"];
}
- (void)replaceObjectInDoctorsAtIndex:(NSUInteger)idx withObject:(RingUser*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"doctors"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self doctors]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"doctors"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"doctors"];
}
- (void)replaceDoctorsAtIndexes:(NSIndexSet *)indexes withDoctors:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"doctors"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self doctors]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"doctors"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"doctors"];
}
@end

