// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingTimeSlotInMonth.h instead.

#import <CoreData/CoreData.h>

extern const struct RingTimeSlotInMonthAttributes {
	__unsafe_unretained NSString *endTime;
	__unsafe_unretained NSString *startTime;
	__unsafe_unretained NSString *state;
	__unsafe_unretained NSString *status;
	__unsafe_unretained NSString *timeSlotInMonthId;
	__unsafe_unretained NSString *type;
} RingTimeSlotInMonthAttributes;

@interface RingTimeSlotInMonthID : NSManagedObjectID {}
@end

@interface _RingTimeSlotInMonth : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingTimeSlotInMonthID* objectID;

@property (nonatomic, strong) NSDate* endTime;

//- (BOOL)validateEndTime:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* startTime;

//- (BOOL)validateStartTime:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* state;

//- (BOOL)validateState:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* status;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* timeSlotInMonthId;

@property (atomic) int32_t timeSlotInMonthIdValue;
- (int32_t)timeSlotInMonthIdValue;
- (void)setTimeSlotInMonthIdValue:(int32_t)value_;

//- (BOOL)validateTimeSlotInMonthId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;

@end

@interface _RingTimeSlotInMonth (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveEndTime;
- (void)setPrimitiveEndTime:(NSDate*)value;

- (NSDate*)primitiveStartTime;
- (void)setPrimitiveStartTime:(NSDate*)value;

- (NSString*)primitiveState;
- (void)setPrimitiveState:(NSString*)value;

- (NSString*)primitiveStatus;
- (void)setPrimitiveStatus:(NSString*)value;

- (NSNumber*)primitiveTimeSlotInMonthId;
- (void)setPrimitiveTimeSlotInMonthId:(NSNumber*)value;

- (int32_t)primitiveTimeSlotInMonthIdValue;
- (void)setPrimitiveTimeSlotInMonthIdValue:(int32_t)value_;

@end
