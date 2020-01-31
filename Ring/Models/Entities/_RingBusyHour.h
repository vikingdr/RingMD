// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingBusyHour.h instead.

#import <CoreData/CoreData.h>

extern const struct RingBusyHourAttributes {
	__unsafe_unretained NSString *busyHourId;
	__unsafe_unretained NSString *from;
	__unsafe_unretained NSString *to;
} RingBusyHourAttributes;

extern const struct RingBusyHourRelationships {
	__unsafe_unretained NSString *user;
} RingBusyHourRelationships;

@class RingUser;

@interface RingBusyHourID : NSManagedObjectID {}
@end

@interface _RingBusyHour : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingBusyHourID* objectID;

@property (nonatomic, strong) NSNumber* busyHourId;

@property (atomic) int32_t busyHourIdValue;
- (int32_t)busyHourIdValue;
- (void)setBusyHourIdValue:(int32_t)value_;

//- (BOOL)validateBusyHourId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* from;

//- (BOOL)validateFrom:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* to;

//- (BOOL)validateTo:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RingUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _RingBusyHour (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveBusyHourId;
- (void)setPrimitiveBusyHourId:(NSNumber*)value;

- (int32_t)primitiveBusyHourIdValue;
- (void)setPrimitiveBusyHourIdValue:(int32_t)value_;

- (NSDate*)primitiveFrom;
- (void)setPrimitiveFrom:(NSDate*)value;

- (NSDate*)primitiveTo;
- (void)setPrimitiveTo:(NSDate*)value;

- (RingUser*)primitiveUser;
- (void)setPrimitiveUser:(RingUser*)value;

@end
