// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingCallRequest.h instead.

#import <CoreData/CoreData.h>

extern const struct RingCallRequestAttributes {
	__unsafe_unretained NSString *callRequestId;
	__unsafe_unretained NSString *callTime;
	__unsafe_unretained NSString *currency;
	__unsafe_unretained NSString *doctorJoined;
	__unsafe_unretained NSString *durationEstimate;
	__unsafe_unretained NSString *numberPhone;
	__unsafe_unretained NSString *patientJoined;
	__unsafe_unretained NSString *price;
	__unsafe_unretained NSString *rate;
	__unsafe_unretained NSString *reason;
	__unsafe_unretained NSString *state;
	__unsafe_unretained NSString *type;
} RingCallRequestAttributes;

extern const struct RingCallRequestRelationships {
	__unsafe_unretained NSString *caller;
	__unsafe_unretained NSString *openTokSesion;
	__unsafe_unretained NSString *receiver;
	__unsafe_unretained NSString *timeSlots;
} RingCallRequestRelationships;

@class RingUser;
@class RingOpenTokSession;
@class RingUser;
@class RingTimeSlot;

@interface RingCallRequestID : NSManagedObjectID {}
@end

@interface _RingCallRequest : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingCallRequestID* objectID;

@property (nonatomic, strong) NSNumber* callRequestId;

@property (atomic) int32_t callRequestIdValue;
- (int32_t)callRequestIdValue;
- (void)setCallRequestIdValue:(int32_t)value_;

//- (BOOL)validateCallRequestId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* callTime;

//- (BOOL)validateCallTime:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* currency;

//- (BOOL)validateCurrency:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* doctorJoined;

@property (atomic) BOOL doctorJoinedValue;
- (BOOL)doctorJoinedValue;
- (void)setDoctorJoinedValue:(BOOL)value_;

//- (BOOL)validateDoctorJoined:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* durationEstimate;

@property (atomic) int32_t durationEstimateValue;
- (int32_t)durationEstimateValue;
- (void)setDurationEstimateValue:(int32_t)value_;

//- (BOOL)validateDurationEstimate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* numberPhone;

//- (BOOL)validateNumberPhone:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* patientJoined;

@property (atomic) BOOL patientJoinedValue;
- (BOOL)patientJoinedValue;
- (void)setPatientJoinedValue:(BOOL)value_;

//- (BOOL)validatePatientJoined:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* price;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* rate;

@property (atomic) float rateValue;
- (float)rateValue;
- (void)setRateValue:(float)value_;

//- (BOOL)validateRate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* reason;

//- (BOOL)validateReason:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* state;

//- (BOOL)validateState:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RingUser *caller;

//- (BOOL)validateCaller:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RingOpenTokSession *openTokSesion;

//- (BOOL)validateOpenTokSesion:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RingUser *receiver;

//- (BOOL)validateReceiver:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSOrderedSet *timeSlots;

- (NSMutableOrderedSet*)timeSlotsSet;

@end

@interface _RingCallRequest (TimeSlotsCoreDataGeneratedAccessors)
- (void)addTimeSlots:(NSOrderedSet*)value_;
- (void)removeTimeSlots:(NSOrderedSet*)value_;
- (void)addTimeSlotsObject:(RingTimeSlot*)value_;
- (void)removeTimeSlotsObject:(RingTimeSlot*)value_;

- (void)insertObject:(RingTimeSlot*)value inTimeSlotsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTimeSlotsAtIndex:(NSUInteger)idx;
- (void)insertTimeSlots:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTimeSlotsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTimeSlotsAtIndex:(NSUInteger)idx withObject:(RingTimeSlot*)value;
- (void)replaceTimeSlotsAtIndexes:(NSIndexSet *)indexes withTimeSlots:(NSArray *)values;

@end

@interface _RingCallRequest (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveCallRequestId;
- (void)setPrimitiveCallRequestId:(NSNumber*)value;

- (int32_t)primitiveCallRequestIdValue;
- (void)setPrimitiveCallRequestIdValue:(int32_t)value_;

- (NSDate*)primitiveCallTime;
- (void)setPrimitiveCallTime:(NSDate*)value;

- (NSString*)primitiveCurrency;
- (void)setPrimitiveCurrency:(NSString*)value;

- (NSNumber*)primitiveDoctorJoined;
- (void)setPrimitiveDoctorJoined:(NSNumber*)value;

- (BOOL)primitiveDoctorJoinedValue;
- (void)setPrimitiveDoctorJoinedValue:(BOOL)value_;

- (NSNumber*)primitiveDurationEstimate;
- (void)setPrimitiveDurationEstimate:(NSNumber*)value;

- (int32_t)primitiveDurationEstimateValue;
- (void)setPrimitiveDurationEstimateValue:(int32_t)value_;

- (NSString*)primitiveNumberPhone;
- (void)setPrimitiveNumberPhone:(NSString*)value;

- (NSNumber*)primitivePatientJoined;
- (void)setPrimitivePatientJoined:(NSNumber*)value;

- (BOOL)primitivePatientJoinedValue;
- (void)setPrimitivePatientJoinedValue:(BOOL)value_;

- (NSString*)primitivePrice;
- (void)setPrimitivePrice:(NSString*)value;

- (NSNumber*)primitiveRate;
- (void)setPrimitiveRate:(NSNumber*)value;

- (float)primitiveRateValue;
- (void)setPrimitiveRateValue:(float)value_;

- (NSString*)primitiveReason;
- (void)setPrimitiveReason:(NSString*)value;

- (NSString*)primitiveState;
- (void)setPrimitiveState:(NSString*)value;

- (RingUser*)primitiveCaller;
- (void)setPrimitiveCaller:(RingUser*)value;

- (RingOpenTokSession*)primitiveOpenTokSesion;
- (void)setPrimitiveOpenTokSesion:(RingOpenTokSession*)value;

- (RingUser*)primitiveReceiver;
- (void)setPrimitiveReceiver:(RingUser*)value;

- (NSMutableOrderedSet*)primitiveTimeSlots;
- (void)setPrimitiveTimeSlots:(NSMutableOrderedSet*)value;

@end
