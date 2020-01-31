// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingCountry.h instead.

#import <CoreData/CoreData.h>

extern const struct RingCountryAttributes {
	__unsafe_unretained NSString *countryId;
	__unsafe_unretained NSString *name;
} RingCountryAttributes;

@interface RingCountryID : NSManagedObjectID {}
@end

@interface _RingCountry : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingCountryID* objectID;

@property (nonatomic, strong) NSNumber* countryId;

@property (atomic) int16_t countryIdValue;
- (int16_t)countryIdValue;
- (void)setCountryIdValue:(int16_t)value_;

//- (BOOL)validateCountryId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@end

@interface _RingCountry (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveCountryId;
- (void)setPrimitiveCountryId:(NSNumber*)value;

- (int16_t)primitiveCountryIdValue;
- (void)setPrimitiveCountryIdValue:(int16_t)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

@end
