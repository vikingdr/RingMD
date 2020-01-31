// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingAttachFile.h instead.

#import <CoreData/CoreData.h>

extern const struct RingAttachFileAttributes {
	__unsafe_unretained NSString *attachFileId;
	__unsafe_unretained NSString *contentType;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *tempFilePath;
} RingAttachFileAttributes;

extern const struct RingAttachFileRelationships {
	__unsafe_unretained NSString *message;
} RingAttachFileRelationships;

@class RingMessage;

@interface RingAttachFileID : NSManagedObjectID {}
@end

@interface _RingAttachFile : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingAttachFileID* objectID;

@property (nonatomic, strong) NSNumber* attachFileId;

@property (atomic) int32_t attachFileIdValue;
- (int32_t)attachFileIdValue;
- (void)setAttachFileIdValue:(int32_t)value_;

//- (BOOL)validateAttachFileId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* contentType;

//- (BOOL)validateContentType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* tempFilePath;

//- (BOOL)validateTempFilePath:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RingMessage *message;

//- (BOOL)validateMessage:(id*)value_ error:(NSError**)error_;

@end

@interface _RingAttachFile (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveAttachFileId;
- (void)setPrimitiveAttachFileId:(NSNumber*)value;

- (int32_t)primitiveAttachFileIdValue;
- (void)setPrimitiveAttachFileIdValue:(int32_t)value_;

- (NSString*)primitiveContentType;
- (void)setPrimitiveContentType:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveTempFilePath;
- (void)setPrimitiveTempFilePath:(NSString*)value;

- (RingMessage*)primitiveMessage;
- (void)setPrimitiveMessage:(RingMessage*)value;

@end
