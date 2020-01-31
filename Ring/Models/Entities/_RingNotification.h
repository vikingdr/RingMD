// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingNotification.h instead.

#import <CoreData/CoreData.h>

extern const struct RingNotificationAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *message;
	__unsafe_unretained NSString *notificationId;
	__unsafe_unretained NSString *notificationObjectId;
	__unsafe_unretained NSString *notificationType;
} RingNotificationAttributes;

extern const struct RingNotificationRelationships {
	__unsafe_unretained NSString *actionUser;
} RingNotificationRelationships;

@class RingUser;

@interface RingNotificationID : NSManagedObjectID {}
@end

@interface _RingNotification : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingNotificationID* objectID;

@property (nonatomic, strong) NSDate* createdAt;

//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* image;

//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* message;

//- (BOOL)validateMessage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* notificationId;

@property (atomic) int32_t notificationIdValue;
- (int32_t)notificationIdValue;
- (void)setNotificationIdValue:(int32_t)value_;

//- (BOOL)validateNotificationId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* notificationObjectId;

@property (atomic) int32_t notificationObjectIdValue;
- (int32_t)notificationObjectIdValue;
- (void)setNotificationObjectIdValue:(int32_t)value_;

//- (BOOL)validateNotificationObjectId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* notificationType;

//- (BOOL)validateNotificationType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RingUser *actionUser;

//- (BOOL)validateActionUser:(id*)value_ error:(NSError**)error_;

@end

@interface _RingNotification (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;

- (NSString*)primitiveImage;
- (void)setPrimitiveImage:(NSString*)value;

- (NSString*)primitiveMessage;
- (void)setPrimitiveMessage:(NSString*)value;

- (NSNumber*)primitiveNotificationId;
- (void)setPrimitiveNotificationId:(NSNumber*)value;

- (int32_t)primitiveNotificationIdValue;
- (void)setPrimitiveNotificationIdValue:(int32_t)value_;

- (NSNumber*)primitiveNotificationObjectId;
- (void)setPrimitiveNotificationObjectId:(NSNumber*)value;

- (int32_t)primitiveNotificationObjectIdValue;
- (void)setPrimitiveNotificationObjectIdValue:(int32_t)value_;

- (NSString*)primitiveNotificationType;
- (void)setPrimitiveNotificationType:(NSString*)value;

- (RingUser*)primitiveActionUser;
- (void)setPrimitiveActionUser:(RingUser*)value;

@end
