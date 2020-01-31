// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingBusinessHour.h instead.

#import <CoreData/CoreData.h>

extern const struct RingBusinessHourAttributes {
	__unsafe_unretained NSString *from;
	__unsafe_unretained NSString *to;
} RingBusinessHourAttributes;

extern const struct RingBusinessHourRelationships {
	__unsafe_unretained NSString *user;
} RingBusinessHourRelationships;

@class RingUser;

@interface RingBusinessHourID : NSManagedObjectID {}
@end

@interface _RingBusinessHour : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingBusinessHourID* objectID;

@property (nonatomic, strong) NSDate* from;

//- (BOOL)validateFrom:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* to;

//- (BOOL)validateTo:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RingUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _RingBusinessHour (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveFrom;
- (void)setPrimitiveFrom:(NSDate*)value;

- (NSDate*)primitiveTo;
- (void)setPrimitiveTo:(NSDate*)value;

- (RingUser*)primitiveUser;
- (void)setPrimitiveUser:(RingUser*)value;

@end
