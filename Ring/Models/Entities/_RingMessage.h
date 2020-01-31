// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingMessage.h instead.

#import <CoreData/CoreData.h>

extern const struct RingMessageAttributes {
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *messageId;
} RingMessageAttributes;

extern const struct RingMessageRelationships {
	__unsafe_unretained NSString *attachFile;
	__unsafe_unretained NSString *conversation;
	__unsafe_unretained NSString *conversationLatest;
	__unsafe_unretained NSString *receiver;
	__unsafe_unretained NSString *sender;
} RingMessageRelationships;

@class RingAttachFile;
@class RingConversation;
@class RingConversation;
@class RingUser;
@class RingUser;

@interface RingMessageID : NSManagedObjectID {}
@end

@interface _RingMessage : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingMessageID* objectID;

@property (nonatomic, strong) NSString* content;

//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* createdAt;

//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* messageId;

@property (atomic) int32_t messageIdValue;
- (int32_t)messageIdValue;
- (void)setMessageIdValue:(int32_t)value_;

//- (BOOL)validateMessageId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RingAttachFile *attachFile;

//- (BOOL)validateAttachFile:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RingConversation *conversation;

//- (BOOL)validateConversation:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RingConversation *conversationLatest;

//- (BOOL)validateConversationLatest:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RingUser *receiver;

//- (BOOL)validateReceiver:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RingUser *sender;

//- (BOOL)validateSender:(id*)value_ error:(NSError**)error_;

@end

@interface _RingMessage (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveContent;
- (void)setPrimitiveContent:(NSString*)value;

- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;

- (NSNumber*)primitiveMessageId;
- (void)setPrimitiveMessageId:(NSNumber*)value;

- (int32_t)primitiveMessageIdValue;
- (void)setPrimitiveMessageIdValue:(int32_t)value_;

- (RingAttachFile*)primitiveAttachFile;
- (void)setPrimitiveAttachFile:(RingAttachFile*)value;

- (RingConversation*)primitiveConversation;
- (void)setPrimitiveConversation:(RingConversation*)value;

- (RingConversation*)primitiveConversationLatest;
- (void)setPrimitiveConversationLatest:(RingConversation*)value;

- (RingUser*)primitiveReceiver;
- (void)setPrimitiveReceiver:(RingUser*)value;

- (RingUser*)primitiveSender;
- (void)setPrimitiveSender:(RingUser*)value;

@end
