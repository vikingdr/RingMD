// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingPatientQuestion.h instead.

#import <CoreData/CoreData.h>

extern const struct RingPatientQuestionAttributes {
	__unsafe_unretained NSString *patientQuestionId;
	__unsafe_unretained NSString *question;
	__unsafe_unretained NSString *type;
} RingPatientQuestionAttributes;

extern const struct RingPatientQuestionRelationships {
	__unsafe_unretained NSString *extraQuestion;
} RingPatientQuestionRelationships;

@class RingExtraPatientQuestion;

@interface RingPatientQuestionID : NSManagedObjectID {}
@end

@interface _RingPatientQuestion : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingPatientQuestionID* objectID;

@property (nonatomic, strong) NSNumber* patientQuestionId;

@property (atomic) int32_t patientQuestionIdValue;
- (int32_t)patientQuestionIdValue;
- (void)setPatientQuestionIdValue:(int32_t)value_;

//- (BOOL)validatePatientQuestionId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* question;

//- (BOOL)validateQuestion:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RingExtraPatientQuestion *extraQuestion;

//- (BOOL)validateExtraQuestion:(id*)value_ error:(NSError**)error_;

@end

@interface _RingPatientQuestion (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitivePatientQuestionId;
- (void)setPrimitivePatientQuestionId:(NSNumber*)value;

- (int32_t)primitivePatientQuestionIdValue;
- (void)setPrimitivePatientQuestionIdValue:(int32_t)value_;

- (NSString*)primitiveQuestion;
- (void)setPrimitiveQuestion:(NSString*)value;

- (RingExtraPatientQuestion*)primitiveExtraQuestion;
- (void)setPrimitiveExtraQuestion:(RingExtraPatientQuestion*)value;

@end
