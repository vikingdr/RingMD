// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingPatientAnswer.h instead.

#import <CoreData/CoreData.h>

extern const struct RingPatientAnswerAttributes {
	__unsafe_unretained NSString *answer;
	__unsafe_unretained NSString *lastAnswer;
	__unsafe_unretained NSString *patientAnswerId;
	__unsafe_unretained NSString *patientQuestionId;
	__unsafe_unretained NSString *value;
} RingPatientAnswerAttributes;

extern const struct RingPatientAnswerRelationships {
	__unsafe_unretained NSString *user;
} RingPatientAnswerRelationships;

@class RingUser;

@interface RingPatientAnswerID : NSManagedObjectID {}
@end

@interface _RingPatientAnswer : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingPatientAnswerID* objectID;

@property (nonatomic, strong) NSString* answer;

//- (BOOL)validateAnswer:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* lastAnswer;

//- (BOOL)validateLastAnswer:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* patientAnswerId;

@property (atomic) int32_t patientAnswerIdValue;
- (int32_t)patientAnswerIdValue;
- (void)setPatientAnswerIdValue:(int32_t)value_;

//- (BOOL)validatePatientAnswerId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* patientQuestionId;

@property (atomic) int32_t patientQuestionIdValue;
- (int32_t)patientQuestionIdValue;
- (void)setPatientQuestionIdValue:(int32_t)value_;

//- (BOOL)validatePatientQuestionId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* value;

@property (atomic) BOOL valueValue;
- (BOOL)valueValue;
- (void)setValueValue:(BOOL)value_;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RingUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _RingPatientAnswer (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAnswer;
- (void)setPrimitiveAnswer:(NSString*)value;

- (NSString*)primitiveLastAnswer;
- (void)setPrimitiveLastAnswer:(NSString*)value;

- (NSNumber*)primitivePatientAnswerId;
- (void)setPrimitivePatientAnswerId:(NSNumber*)value;

- (int32_t)primitivePatientAnswerIdValue;
- (void)setPrimitivePatientAnswerIdValue:(int32_t)value_;

- (NSNumber*)primitivePatientQuestionId;
- (void)setPrimitivePatientQuestionId:(NSNumber*)value;

- (int32_t)primitivePatientQuestionIdValue;
- (void)setPrimitivePatientQuestionIdValue:(int32_t)value_;

- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (BOOL)primitiveValueValue;
- (void)setPrimitiveValueValue:(BOOL)value_;

- (RingUser*)primitiveUser;
- (void)setPrimitiveUser:(RingUser*)value;

@end
