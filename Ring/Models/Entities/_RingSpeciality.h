// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingSpeciality.h instead.

#import <CoreData/CoreData.h>

extern const struct RingSpecialityAttributes {
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *numDoctors;
	__unsafe_unretained NSString *parentId;
	__unsafe_unretained NSString *specialityId;
} RingSpecialityAttributes;

extern const struct RingSpecialityRelationships {
	__unsafe_unretained NSString *children;
	__unsafe_unretained NSString *doctors;
	__unsafe_unretained NSString *parent;
} RingSpecialityRelationships;

@class RingSpeciality;
@class RingUser;
@class RingSpeciality;

@interface RingSpecialityID : NSManagedObjectID {}
@end

@interface _RingSpeciality : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingSpecialityID* objectID;

@property (nonatomic, strong) NSString* displayName;

//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* image;

//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* numDoctors;

@property (atomic) int32_t numDoctorsValue;
- (int32_t)numDoctorsValue;
- (void)setNumDoctorsValue:(int32_t)value_;

//- (BOOL)validateNumDoctors:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* parentId;

@property (atomic) int32_t parentIdValue;
- (int32_t)parentIdValue;
- (void)setParentIdValue:(int32_t)value_;

//- (BOOL)validateParentId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* specialityId;

@property (atomic) int16_t specialityIdValue;
- (int16_t)specialityIdValue;
- (void)setSpecialityIdValue:(int16_t)value_;

//- (BOOL)validateSpecialityId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSOrderedSet *children;

- (NSMutableOrderedSet*)childrenSet;

@property (nonatomic, strong) NSOrderedSet *doctors;

- (NSMutableOrderedSet*)doctorsSet;

@property (nonatomic, strong) RingSpeciality *parent;

//- (BOOL)validateParent:(id*)value_ error:(NSError**)error_;

@end

@interface _RingSpeciality (ChildrenCoreDataGeneratedAccessors)
- (void)addChildren:(NSOrderedSet*)value_;
- (void)removeChildren:(NSOrderedSet*)value_;
- (void)addChildrenObject:(RingSpeciality*)value_;
- (void)removeChildrenObject:(RingSpeciality*)value_;

- (void)insertObject:(RingSpeciality*)value inChildrenAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)idx;
- (void)insertChildren:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChildrenAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChildrenAtIndex:(NSUInteger)idx withObject:(RingSpeciality*)value;
- (void)replaceChildrenAtIndexes:(NSIndexSet *)indexes withChildren:(NSArray *)values;

@end

@interface _RingSpeciality (DoctorsCoreDataGeneratedAccessors)
- (void)addDoctors:(NSOrderedSet*)value_;
- (void)removeDoctors:(NSOrderedSet*)value_;
- (void)addDoctorsObject:(RingUser*)value_;
- (void)removeDoctorsObject:(RingUser*)value_;

- (void)insertObject:(RingUser*)value inDoctorsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDoctorsAtIndex:(NSUInteger)idx;
- (void)insertDoctors:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDoctorsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDoctorsAtIndex:(NSUInteger)idx withObject:(RingUser*)value;
- (void)replaceDoctorsAtIndexes:(NSIndexSet *)indexes withDoctors:(NSArray *)values;

@end

@interface _RingSpeciality (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;

- (NSString*)primitiveImage;
- (void)setPrimitiveImage:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveNumDoctors;
- (void)setPrimitiveNumDoctors:(NSNumber*)value;

- (int32_t)primitiveNumDoctorsValue;
- (void)setPrimitiveNumDoctorsValue:(int32_t)value_;

- (NSNumber*)primitiveParentId;
- (void)setPrimitiveParentId:(NSNumber*)value;

- (int32_t)primitiveParentIdValue;
- (void)setPrimitiveParentIdValue:(int32_t)value_;

- (NSNumber*)primitiveSpecialityId;
- (void)setPrimitiveSpecialityId:(NSNumber*)value;

- (int16_t)primitiveSpecialityIdValue;
- (void)setPrimitiveSpecialityIdValue:(int16_t)value_;

- (NSMutableOrderedSet*)primitiveChildren;
- (void)setPrimitiveChildren:(NSMutableOrderedSet*)value;

- (NSMutableOrderedSet*)primitiveDoctors;
- (void)setPrimitiveDoctors:(NSMutableOrderedSet*)value;

- (RingSpeciality*)primitiveParent;
- (void)setPrimitiveParent:(RingSpeciality*)value;

@end
