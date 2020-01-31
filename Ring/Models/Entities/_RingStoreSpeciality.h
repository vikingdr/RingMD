// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingStoreSpeciality.h instead.

#import <CoreData/CoreData.h>

extern const struct RingStoreSpecialityAttributes {
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *numDoctors;
	__unsafe_unretained NSString *specialityId;
} RingStoreSpecialityAttributes;

@interface RingStoreSpecialityID : NSManagedObjectID {}
@end

@interface _RingStoreSpeciality : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingStoreSpecialityID* objectID;

@property (nonatomic, strong) NSString* image;

//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* numDoctors;

@property (atomic) int32_t numDoctorsValue;
- (int32_t)numDoctorsValue;
- (void)setNumDoctorsValue:(int32_t)value_;

//- (BOOL)validateNumDoctors:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* specialityId;

@property (atomic) int16_t specialityIdValue;
- (int16_t)specialityIdValue;
- (void)setSpecialityIdValue:(int16_t)value_;

//- (BOOL)validateSpecialityId:(id*)value_ error:(NSError**)error_;

@end

@interface _RingStoreSpeciality (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveImage;
- (void)setPrimitiveImage:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveNumDoctors;
- (void)setPrimitiveNumDoctors:(NSNumber*)value;

- (int32_t)primitiveNumDoctorsValue;
- (void)setPrimitiveNumDoctorsValue:(int32_t)value_;

- (NSNumber*)primitiveSpecialityId;
- (void)setPrimitiveSpecialityId:(NSNumber*)value;

- (int16_t)primitiveSpecialityIdValue;
- (void)setPrimitiveSpecialityIdValue:(int16_t)value_;

@end
