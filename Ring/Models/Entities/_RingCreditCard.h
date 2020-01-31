// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingCreditCard.h instead.

#import <CoreData/CoreData.h>

extern const struct RingCreditCardAttributes {
	__unsafe_unretained NSString *brandType;
	__unsafe_unretained NSString *code;
	__unsafe_unretained NSString *creditCardId;
	__unsafe_unretained NSString *expireMonth;
	__unsafe_unretained NSString *expireYear;
	__unsafe_unretained NSString *holder;
	__unsafe_unretained NSString *memberId;
	__unsafe_unretained NSString *number;
	__unsafe_unretained NSString *showNumber;
} RingCreditCardAttributes;

@interface RingCreditCardID : NSManagedObjectID {}
@end

@interface _RingCreditCard : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingCreditCardID* objectID;

@property (nonatomic, strong) NSNumber* brandType;

@property (atomic) int16_t brandTypeValue;
- (int16_t)brandTypeValue;
- (void)setBrandTypeValue:(int16_t)value_;

//- (BOOL)validateBrandType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* code;

@property (atomic) int16_t codeValue;
- (int16_t)codeValue;
- (void)setCodeValue:(int16_t)value_;

//- (BOOL)validateCode:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* creditCardId;

@property (atomic) int32_t creditCardIdValue;
- (int32_t)creditCardIdValue;
- (void)setCreditCardIdValue:(int32_t)value_;

//- (BOOL)validateCreditCardId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* expireMonth;

@property (atomic) int16_t expireMonthValue;
- (int16_t)expireMonthValue;
- (void)setExpireMonthValue:(int16_t)value_;

//- (BOOL)validateExpireMonth:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* expireYear;

@property (atomic) int16_t expireYearValue;
- (int16_t)expireYearValue;
- (void)setExpireYearValue:(int16_t)value_;

//- (BOOL)validateExpireYear:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* holder;

//- (BOOL)validateHolder:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* memberId;

//- (BOOL)validateMemberId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* number;

//- (BOOL)validateNumber:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* showNumber;

//- (BOOL)validateShowNumber:(id*)value_ error:(NSError**)error_;

@end

@interface _RingCreditCard (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveBrandType;
- (void)setPrimitiveBrandType:(NSNumber*)value;

- (int16_t)primitiveBrandTypeValue;
- (void)setPrimitiveBrandTypeValue:(int16_t)value_;

- (NSNumber*)primitiveCode;
- (void)setPrimitiveCode:(NSNumber*)value;

- (int16_t)primitiveCodeValue;
- (void)setPrimitiveCodeValue:(int16_t)value_;

- (NSNumber*)primitiveCreditCardId;
- (void)setPrimitiveCreditCardId:(NSNumber*)value;

- (int32_t)primitiveCreditCardIdValue;
- (void)setPrimitiveCreditCardIdValue:(int32_t)value_;

- (NSNumber*)primitiveExpireMonth;
- (void)setPrimitiveExpireMonth:(NSNumber*)value;

- (int16_t)primitiveExpireMonthValue;
- (void)setPrimitiveExpireMonthValue:(int16_t)value_;

- (NSNumber*)primitiveExpireYear;
- (void)setPrimitiveExpireYear:(NSNumber*)value;

- (int16_t)primitiveExpireYearValue;
- (void)setPrimitiveExpireYearValue:(int16_t)value_;

- (NSString*)primitiveHolder;
- (void)setPrimitiveHolder:(NSString*)value;

- (NSString*)primitiveMemberId;
- (void)setPrimitiveMemberId:(NSString*)value;

- (NSString*)primitiveNumber;
- (void)setPrimitiveNumber:(NSString*)value;

- (NSString*)primitiveShowNumber;
- (void)setPrimitiveShowNumber:(NSString*)value;

@end
