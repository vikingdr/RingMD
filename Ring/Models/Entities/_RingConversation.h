// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingConversation.h instead.

#import <CoreData/CoreData.h>

extern const struct RingConversationAttributes {
	__unsafe_unretained NSString *unreadCount;
} RingConversationAttributes;

extern const struct RingConversationRelationships {
	__unsafe_unretained NSString *latestMessage;
	__unsafe_unretained NSString *messages;
	__unsafe_unretained NSString *users;
} RingConversationRelationships;

@class RingMessage;
@class RingMessage;
@class RingUser;

@interface RingConversationID : NSManagedObjectID {}
@end

@interface _RingConversation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingConversationID* objectID;

@property (nonatomic, strong) NSNumber* unreadCount;

@property (atomic) int16_t unreadCountValue;
- (int16_t)unreadCountValue;
- (void)setUnreadCountValue:(int16_t)value_;

//- (BOOL)validateUnreadCount:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RingMessage *latestMessage;

//- (BOOL)validateLatestMessage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *messages;

- (NSMutableSet*)messagesSet;

@property (nonatomic, strong) NSSet *users;

- (NSMutableSet*)usersSet;

@end

@interface _RingConversation (MessagesCoreDataGeneratedAccessors)
- (void)addMessages:(NSSet*)value_;
- (void)removeMessages:(NSSet*)value_;
- (void)addMessagesObject:(RingMessage*)value_;
- (void)removeMessagesObject:(RingMessage*)value_;

@end

@interface _RingConversation (UsersCoreDataGeneratedAccessors)
- (void)addUsers:(NSSet*)value_;
- (void)removeUsers:(NSSet*)value_;
- (void)addUsersObject:(RingUser*)value_;
- (void)removeUsersObject:(RingUser*)value_;

@end

@interface _RingConversation (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveUnreadCount;
- (void)setPrimitiveUnreadCount:(NSNumber*)value;

- (int16_t)primitiveUnreadCountValue;
- (void)setPrimitiveUnreadCountValue:(int16_t)value_;

- (RingMessage*)primitiveLatestMessage;
- (void)setPrimitiveLatestMessage:(RingMessage*)value;

- (NSMutableSet*)primitiveMessages;
- (void)setPrimitiveMessages:(NSMutableSet*)value;

- (NSMutableSet*)primitiveUsers;
- (void)setPrimitiveUsers:(NSMutableSet*)value;

@end
