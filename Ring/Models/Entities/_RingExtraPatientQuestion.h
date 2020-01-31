// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingExtraPatientQuestion.h instead.

#import <CoreData/CoreData.h>

extern const struct RingExtraPatientQuestionAttributes {
	__unsafe_unretained NSString *extraPatientQuestionId;
	__unsafe_unretained NSString *options;
	__unsafe_unretained NSString *question;
	__unsafe_unretained NSString *type;
} RingExtraPatientQuestionAttributes;

extern const struct RingExtraPatientQuestionRelationships {
	__unsafe_unretained NSString *parent;
} RingExtraPatientQuestionRelationships;

@class RingPatientQuestion;

@class NSObject;

@interface RingExtraPatientQuestionID : NSManagedObjectID {}
@end

@interface _RingExtraPatientQuestion : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingExtraPatientQuestionID* objectID;

@property (nonatomic, strong) NSNumber* extraPatientQuestionId;

@property (atomic) int32_t extraPatientQuestionIdValue;
- (int32_t)extraPatientQuestionIdValue;
- (void)setExtraPatientQuestionIdValue:(int32_t)value_;

//- (BOOL)validateExtraPatientQuestionId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) id options;

//- (BOOL)validateOptions:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* question;

//- (BOOL)validateQuestion:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RingPatientQuestion *parent;

//- (BOOL)validateParent:(id*)value_ error:(NSError**)error_;

@end

@interface _RingExtraPatientQuestion (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveExtraPatientQuestionId;
- (void)setPrimitiveExtraPatientQuestionId:(NSNumber*)value;

- (int32_t)primitiveExtraPatientQuestionIdValue;
- (void)setPrimitiveExtraPatientQuestionIdValue:(int32_t)value_;

- (id)primitiveOptions;
- (void)setPrimitiveOptions:(id)value;

- (NSString*)primitiveQuestion;
- (void)setPrimitiveQuestion:(NSString*)value;

- (RingPatientQuestion*)primitiveParent;
- (void)setPrimitiveParent:(RingPatientQuestion*)value;

@end
