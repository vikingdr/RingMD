// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingTimeSlot.h instead.

#import <CoreData/CoreData.h>

extern const struct RingTimeSlotAttributes {
	__unsafe_unretained NSString *callTime;
	__unsafe_unretained NSString *state;
	__unsafe_unretained NSString *timeSlotId;
} RingTimeSlotAttributes;

extern const struct RingTimeSlotRelationships {
	__unsafe_unretained NSString *callRequest;
} RingTimeSlotRelationships;

@class RingCallRequest;

@interface RingTimeSlotID : NSManagedObjectID {}
@end

@interface _RingTimeSlot : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingTimeSlotID* objectID;

@property (nonatomic, strong) NSDate* callTime;

//- (BOOL)validateCallTime:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* state;

//- (BOOL)validateState:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* timeSlotId;

@property (atomic) int32_t timeSlotIdValue;
- (int32_t)timeSlotIdValue;
- (void)setTimeSlotIdValue:(int32_t)value_;

//- (BOOL)validateTimeSlotId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RingCallRequest *callRequest;

//- (BOOL)validateCallRequest:(id*)value_ error:(NSError**)error_;

@end

@interface _RingTimeSlot (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCallTime;
- (void)setPrimitiveCallTime:(NSDate*)value;

- (NSString*)primitiveState;
- (void)setPrimitiveState:(NSString*)value;

- (NSNumber*)primitiveTimeSlotId;
- (void)setPrimitiveTimeSlotId:(NSNumber*)value;

- (int32_t)primitiveTimeSlotIdValue;
- (void)setPrimitiveTimeSlotIdValue:(int32_t)value_;

- (RingCallRequest*)primitiveCallRequest;
- (void)setPrimitiveCallRequest:(RingCallRequest*)value;

@end
