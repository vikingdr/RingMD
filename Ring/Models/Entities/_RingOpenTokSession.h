// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingOpenTokSession.h instead.

#import <CoreData/CoreData.h>

extern const struct RingOpenTokSessionAttributes {
	__unsafe_unretained NSString *sessionId;
	__unsafe_unretained NSString *token;
} RingOpenTokSessionAttributes;

extern const struct RingOpenTokSessionRelationships {
	__unsafe_unretained NSString *callRequest;
} RingOpenTokSessionRelationships;

@class RingCallRequest;

@interface RingOpenTokSessionID : NSManagedObjectID {}
@end

@interface _RingOpenTokSession : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingOpenTokSessionID* objectID;

@property (nonatomic, strong) NSString* sessionId;

//- (BOOL)validateSessionId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* token;

//- (BOOL)validateToken:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RingCallRequest *callRequest;

//- (BOOL)validateCallRequest:(id*)value_ error:(NSError**)error_;

@end

@interface _RingOpenTokSession (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveSessionId;
- (void)setPrimitiveSessionId:(NSString*)value;

- (NSString*)primitiveToken;
- (void)setPrimitiveToken:(NSString*)value;

- (RingCallRequest*)primitiveCallRequest;
- (void)setPrimitiveCallRequest:(RingCallRequest*)value;

@end
