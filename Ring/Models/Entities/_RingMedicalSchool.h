// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingMedicalSchool.h instead.

#import <CoreData/CoreData.h>

extern const struct RingMedicalSchoolAttributes {
	__unsafe_unretained NSString *medicalSchoolId;
	__unsafe_unretained NSString *name;
} RingMedicalSchoolAttributes;

@interface RingMedicalSchoolID : NSManagedObjectID {}
@end

@interface _RingMedicalSchool : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingMedicalSchoolID* objectID;

@property (nonatomic, strong) NSNumber* medicalSchoolId;

@property (atomic) int16_t medicalSchoolIdValue;
- (int16_t)medicalSchoolIdValue;
- (void)setMedicalSchoolIdValue:(int16_t)value_;

//- (BOOL)validateMedicalSchoolId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@end

@interface _RingMedicalSchool (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveMedicalSchoolId;
- (void)setPrimitiveMedicalSchoolId:(NSNumber*)value;

- (int16_t)primitiveMedicalSchoolIdValue;
- (void)setPrimitiveMedicalSchoolIdValue:(int16_t)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

@end
