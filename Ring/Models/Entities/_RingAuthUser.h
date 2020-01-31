// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingAuthUser.h instead.

#import <CoreData/CoreData.h>

extern const struct RingAuthUserAttributes {
	__unsafe_unretained NSString *about;
	__unsafe_unretained NSString *authToken;
	__unsafe_unretained NSString *avatar;
	__unsafe_unretained NSString *currency;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *isDoctor;
	__unsafe_unretained NSString *licenseNumber;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *numDoctors;
	__unsafe_unretained NSString *numMessageNotification;
	__unsafe_unretained NSString *numRequestNotification;
	__unsafe_unretained NSString *password;
	__unsafe_unretained NSString *phoneCode;
	__unsafe_unretained NSString *phoneRawNumber;
	__unsafe_unretained NSString *pricePerHour;
	__unsafe_unretained NSString *promotionalCode;
	__unsafe_unretained NSString *specialityId;
	__unsafe_unretained NSString *userId;
} RingAuthUserAttributes;

@interface RingAuthUserID : NSManagedObjectID {}
@end

@interface _RingAuthUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingAuthUserID* objectID;

@property (nonatomic, strong) NSString* about;

//- (BOOL)validateAbout:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* authToken;

//- (BOOL)validateAuthToken:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* avatar;

//- (BOOL)validateAvatar:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* currency;

//- (BOOL)validateCurrency:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* email;

//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* image;

//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* isDoctor;

@property (atomic) BOOL isDoctorValue;
- (BOOL)isDoctorValue;
- (void)setIsDoctorValue:(BOOL)value_;

//- (BOOL)validateIsDoctor:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* licenseNumber;

//- (BOOL)validateLicenseNumber:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* location;

//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* numDoctors;

@property (atomic) int32_t numDoctorsValue;
- (int32_t)numDoctorsValue;
- (void)setNumDoctorsValue:(int32_t)value_;

//- (BOOL)validateNumDoctors:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* numMessageNotification;

@property (atomic) int16_t numMessageNotificationValue;
- (int16_t)numMessageNotificationValue;
- (void)setNumMessageNotificationValue:(int16_t)value_;

//- (BOOL)validateNumMessageNotification:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* numRequestNotification;

@property (atomic) int16_t numRequestNotificationValue;
- (int16_t)numRequestNotificationValue;
- (void)setNumRequestNotificationValue:(int16_t)value_;

//- (BOOL)validateNumRequestNotification:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* password;

//- (BOOL)validatePassword:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* phoneCode;

//- (BOOL)validatePhoneCode:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* phoneRawNumber;

//- (BOOL)validatePhoneRawNumber:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* pricePerHour;

@property (atomic) float pricePerHourValue;
- (float)pricePerHourValue;
- (void)setPricePerHourValue:(float)value_;

//- (BOOL)validatePricePerHour:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* promotionalCode;

//- (BOOL)validatePromotionalCode:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* specialityId;

@property (atomic) int16_t specialityIdValue;
- (int16_t)specialityIdValue;
- (void)setSpecialityIdValue:(int16_t)value_;

//- (BOOL)validateSpecialityId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* userId;

@property (atomic) int32_t userIdValue;
- (int32_t)userIdValue;
- (void)setUserIdValue:(int32_t)value_;

//- (BOOL)validateUserId:(id*)value_ error:(NSError**)error_;

@end

@interface _RingAuthUser (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAbout;
- (void)setPrimitiveAbout:(NSString*)value;

- (NSString*)primitiveAuthToken;
- (void)setPrimitiveAuthToken:(NSString*)value;

- (NSString*)primitiveAvatar;
- (void)setPrimitiveAvatar:(NSString*)value;

- (NSString*)primitiveCurrency;
- (void)setPrimitiveCurrency:(NSString*)value;

- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;

- (NSString*)primitiveImage;
- (void)setPrimitiveImage:(NSString*)value;

- (NSNumber*)primitiveIsDoctor;
- (void)setPrimitiveIsDoctor:(NSNumber*)value;

- (BOOL)primitiveIsDoctorValue;
- (void)setPrimitiveIsDoctorValue:(BOOL)value_;

- (NSString*)primitiveLicenseNumber;
- (void)setPrimitiveLicenseNumber:(NSString*)value;

- (NSString*)primitiveLocation;
- (void)setPrimitiveLocation:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveNumDoctors;
- (void)setPrimitiveNumDoctors:(NSNumber*)value;

- (int32_t)primitiveNumDoctorsValue;
- (void)setPrimitiveNumDoctorsValue:(int32_t)value_;

- (NSNumber*)primitiveNumMessageNotification;
- (void)setPrimitiveNumMessageNotification:(NSNumber*)value;

- (int16_t)primitiveNumMessageNotificationValue;
- (void)setPrimitiveNumMessageNotificationValue:(int16_t)value_;

- (NSNumber*)primitiveNumRequestNotification;
- (void)setPrimitiveNumRequestNotification:(NSNumber*)value;

- (int16_t)primitiveNumRequestNotificationValue;
- (void)setPrimitiveNumRequestNotificationValue:(int16_t)value_;

- (NSString*)primitivePassword;
- (void)setPrimitivePassword:(NSString*)value;

- (NSString*)primitivePhoneCode;
- (void)setPrimitivePhoneCode:(NSString*)value;

- (NSString*)primitivePhoneRawNumber;
- (void)setPrimitivePhoneRawNumber:(NSString*)value;

- (NSNumber*)primitivePricePerHour;
- (void)setPrimitivePricePerHour:(NSNumber*)value;

- (float)primitivePricePerHourValue;
- (void)setPrimitivePricePerHourValue:(float)value_;

- (NSString*)primitivePromotionalCode;
- (void)setPrimitivePromotionalCode:(NSString*)value;

- (NSNumber*)primitiveSpecialityId;
- (void)setPrimitiveSpecialityId:(NSNumber*)value;

- (int16_t)primitiveSpecialityIdValue;
- (void)setPrimitiveSpecialityIdValue:(int16_t)value_;

- (NSNumber*)primitiveUserId;
- (void)setPrimitiveUserId:(NSNumber*)value;

- (int32_t)primitiveUserIdValue;
- (void)setPrimitiveUserIdValue:(int32_t)value_;

@end
