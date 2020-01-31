// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RingUser.h instead.

#import <CoreData/CoreData.h>

extern const struct RingUserAttributes {
	__unsafe_unretained NSString *about;
	__unsafe_unretained NSString *authToken;
	__unsafe_unretained NSString *avatar;
	__unsafe_unretained NSString *avatarFull;
	__unsafe_unretained NSString *canReview;
	__unsafe_unretained NSString *currentSymptoms;
	__unsafe_unretained NSString *currentTreatment;
	__unsafe_unretained NSString *featuredRank;
	__unsafe_unretained NSString *licenseNumber;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *numCalls;
	__unsafe_unretained NSString *numReviews;
	__unsafe_unretained NSString *numSpecialities;
	__unsafe_unretained NSString *numVideos;
	__unsafe_unretained NSString *phoneCode;
	__unsafe_unretained NSString *phoneRawNumber;
	__unsafe_unretained NSString *pricePerMinuteText;
	__unsafe_unretained NSString *profileId;
	__unsafe_unretained NSString *promotionalCode;
	__unsafe_unretained NSString *rating;
	__unsafe_unretained NSString *role;
	__unsafe_unretained NSString *type;
	__unsafe_unretained NSString *userId;
} RingUserAttributes;

extern const struct RingUserRelationships {
	__unsafe_unretained NSString *businessHours;
	__unsafe_unretained NSString *busyHours;
	__unsafe_unretained NSString *callRequests;
	__unsafe_unretained NSString *conversations;
	__unsafe_unretained NSString *favorites;
	__unsafe_unretained NSString *notifications;
	__unsafe_unretained NSString *patientAnswers;
	__unsafe_unretained NSString *receiveMessages;
	__unsafe_unretained NSString *receiveRequests;
	__unsafe_unretained NSString *sentMessages;
	__unsafe_unretained NSString *specialities;
	__unsafe_unretained NSString *userFavorite;
} RingUserRelationships;

@class RingBusinessHour;
@class RingBusyHour;
@class RingCallRequest;
@class RingConversation;
@class RingUser;
@class RingNotification;
@class RingPatientAnswer;
@class RingMessage;
@class RingCallRequest;
@class RingMessage;
@class RingSpeciality;
@class RingUser;

@interface RingUserID : NSManagedObjectID {}
@end

@interface _RingUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RingUserID* objectID;

@property (nonatomic, strong) NSString* about;

//- (BOOL)validateAbout:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* authToken;

//- (BOOL)validateAuthToken:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* avatar;

//- (BOOL)validateAvatar:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* avatarFull;

//- (BOOL)validateAvatarFull:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* canReview;

@property (atomic) BOOL canReviewValue;
- (BOOL)canReviewValue;
- (void)setCanReviewValue:(BOOL)value_;

//- (BOOL)validateCanReview:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* currentSymptoms;

//- (BOOL)validateCurrentSymptoms:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* currentTreatment;

//- (BOOL)validateCurrentTreatment:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* featuredRank;

@property (atomic) int16_t featuredRankValue;
- (int16_t)featuredRankValue;
- (void)setFeaturedRankValue:(int16_t)value_;

//- (BOOL)validateFeaturedRank:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* licenseNumber;

//- (BOOL)validateLicenseNumber:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* location;

//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* numCalls;

@property (atomic) int32_t numCallsValue;
- (int32_t)numCallsValue;
- (void)setNumCallsValue:(int32_t)value_;

//- (BOOL)validateNumCalls:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* numReviews;

@property (atomic) int32_t numReviewsValue;
- (int32_t)numReviewsValue;
- (void)setNumReviewsValue:(int32_t)value_;

//- (BOOL)validateNumReviews:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* numSpecialities;

@property (atomic) int16_t numSpecialitiesValue;
- (int16_t)numSpecialitiesValue;
- (void)setNumSpecialitiesValue:(int16_t)value_;

//- (BOOL)validateNumSpecialities:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* numVideos;

@property (atomic) int32_t numVideosValue;
- (int32_t)numVideosValue;
- (void)setNumVideosValue:(int32_t)value_;

//- (BOOL)validateNumVideos:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* phoneCode;

//- (BOOL)validatePhoneCode:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* phoneRawNumber;

//- (BOOL)validatePhoneRawNumber:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* pricePerMinuteText;

//- (BOOL)validatePricePerMinuteText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* profileId;

@property (atomic) int32_t profileIdValue;
- (int32_t)profileIdValue;
- (void)setProfileIdValue:(int32_t)value_;

//- (BOOL)validateProfileId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* promotionalCode;

//- (BOOL)validatePromotionalCode:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* rating;

@property (atomic) float ratingValue;
- (float)ratingValue;
- (void)setRatingValue:(float)value_;

//- (BOOL)validateRating:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* role;

//- (BOOL)validateRole:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* type;

@property (atomic) int16_t typeValue;
- (int16_t)typeValue;
- (void)setTypeValue:(int16_t)value_;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* userId;

@property (atomic) int32_t userIdValue;
- (int32_t)userIdValue;
- (void)setUserIdValue:(int32_t)value_;

//- (BOOL)validateUserId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *businessHours;

- (NSMutableSet*)businessHoursSet;

@property (nonatomic, strong) NSSet *busyHours;

- (NSMutableSet*)busyHoursSet;

@property (nonatomic, strong) NSSet *callRequests;

- (NSMutableSet*)callRequestsSet;

@property (nonatomic, strong) NSSet *conversations;

- (NSMutableSet*)conversationsSet;

@property (nonatomic, strong) NSOrderedSet *favorites;

- (NSMutableOrderedSet*)favoritesSet;

@property (nonatomic, strong) NSSet *notifications;

- (NSMutableSet*)notificationsSet;

@property (nonatomic, strong) NSSet *patientAnswers;

- (NSMutableSet*)patientAnswersSet;

@property (nonatomic, strong) NSSet *receiveMessages;

- (NSMutableSet*)receiveMessagesSet;

@property (nonatomic, strong) NSSet *receiveRequests;

- (NSMutableSet*)receiveRequestsSet;

@property (nonatomic, strong) NSSet *sentMessages;

- (NSMutableSet*)sentMessagesSet;

@property (nonatomic, strong) NSSet *specialities;

- (NSMutableSet*)specialitiesSet;

@property (nonatomic, strong) RingUser *userFavorite;

//- (BOOL)validateUserFavorite:(id*)value_ error:(NSError**)error_;

@end

@interface _RingUser (BusinessHoursCoreDataGeneratedAccessors)
- (void)addBusinessHours:(NSSet*)value_;
- (void)removeBusinessHours:(NSSet*)value_;
- (void)addBusinessHoursObject:(RingBusinessHour*)value_;
- (void)removeBusinessHoursObject:(RingBusinessHour*)value_;

@end

@interface _RingUser (BusyHoursCoreDataGeneratedAccessors)
- (void)addBusyHours:(NSSet*)value_;
- (void)removeBusyHours:(NSSet*)value_;
- (void)addBusyHoursObject:(RingBusyHour*)value_;
- (void)removeBusyHoursObject:(RingBusyHour*)value_;

@end

@interface _RingUser (CallRequestsCoreDataGeneratedAccessors)
- (void)addCallRequests:(NSSet*)value_;
- (void)removeCallRequests:(NSSet*)value_;
- (void)addCallRequestsObject:(RingCallRequest*)value_;
- (void)removeCallRequestsObject:(RingCallRequest*)value_;

@end

@interface _RingUser (ConversationsCoreDataGeneratedAccessors)
- (void)addConversations:(NSSet*)value_;
- (void)removeConversations:(NSSet*)value_;
- (void)addConversationsObject:(RingConversation*)value_;
- (void)removeConversationsObject:(RingConversation*)value_;

@end

@interface _RingUser (FavoritesCoreDataGeneratedAccessors)
- (void)addFavorites:(NSOrderedSet*)value_;
- (void)removeFavorites:(NSOrderedSet*)value_;
- (void)addFavoritesObject:(RingUser*)value_;
- (void)removeFavoritesObject:(RingUser*)value_;

- (void)insertObject:(RingUser*)value inFavoritesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFavoritesAtIndex:(NSUInteger)idx;
- (void)insertFavorites:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFavoritesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFavoritesAtIndex:(NSUInteger)idx withObject:(RingUser*)value;
- (void)replaceFavoritesAtIndexes:(NSIndexSet *)indexes withFavorites:(NSArray *)values;

@end

@interface _RingUser (NotificationsCoreDataGeneratedAccessors)
- (void)addNotifications:(NSSet*)value_;
- (void)removeNotifications:(NSSet*)value_;
- (void)addNotificationsObject:(RingNotification*)value_;
- (void)removeNotificationsObject:(RingNotification*)value_;

@end

@interface _RingUser (PatientAnswersCoreDataGeneratedAccessors)
- (void)addPatientAnswers:(NSSet*)value_;
- (void)removePatientAnswers:(NSSet*)value_;
- (void)addPatientAnswersObject:(RingPatientAnswer*)value_;
- (void)removePatientAnswersObject:(RingPatientAnswer*)value_;

@end

@interface _RingUser (ReceiveMessagesCoreDataGeneratedAccessors)
- (void)addReceiveMessages:(NSSet*)value_;
- (void)removeReceiveMessages:(NSSet*)value_;
- (void)addReceiveMessagesObject:(RingMessage*)value_;
- (void)removeReceiveMessagesObject:(RingMessage*)value_;

@end

@interface _RingUser (ReceiveRequestsCoreDataGeneratedAccessors)
- (void)addReceiveRequests:(NSSet*)value_;
- (void)removeReceiveRequests:(NSSet*)value_;
- (void)addReceiveRequestsObject:(RingCallRequest*)value_;
- (void)removeReceiveRequestsObject:(RingCallRequest*)value_;

@end

@interface _RingUser (SentMessagesCoreDataGeneratedAccessors)
- (void)addSentMessages:(NSSet*)value_;
- (void)removeSentMessages:(NSSet*)value_;
- (void)addSentMessagesObject:(RingMessage*)value_;
- (void)removeSentMessagesObject:(RingMessage*)value_;

@end

@interface _RingUser (SpecialitiesCoreDataGeneratedAccessors)
- (void)addSpecialities:(NSSet*)value_;
- (void)removeSpecialities:(NSSet*)value_;
- (void)addSpecialitiesObject:(RingSpeciality*)value_;
- (void)removeSpecialitiesObject:(RingSpeciality*)value_;

@end

@interface _RingUser (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAbout;
- (void)setPrimitiveAbout:(NSString*)value;

- (NSString*)primitiveAuthToken;
- (void)setPrimitiveAuthToken:(NSString*)value;

- (NSString*)primitiveAvatar;
- (void)setPrimitiveAvatar:(NSString*)value;

- (NSString*)primitiveAvatarFull;
- (void)setPrimitiveAvatarFull:(NSString*)value;

- (NSNumber*)primitiveCanReview;
- (void)setPrimitiveCanReview:(NSNumber*)value;

- (BOOL)primitiveCanReviewValue;
- (void)setPrimitiveCanReviewValue:(BOOL)value_;

- (NSString*)primitiveCurrentSymptoms;
- (void)setPrimitiveCurrentSymptoms:(NSString*)value;

- (NSString*)primitiveCurrentTreatment;
- (void)setPrimitiveCurrentTreatment:(NSString*)value;

- (NSNumber*)primitiveFeaturedRank;
- (void)setPrimitiveFeaturedRank:(NSNumber*)value;

- (int16_t)primitiveFeaturedRankValue;
- (void)setPrimitiveFeaturedRankValue:(int16_t)value_;

- (NSString*)primitiveLicenseNumber;
- (void)setPrimitiveLicenseNumber:(NSString*)value;

- (NSString*)primitiveLocation;
- (void)setPrimitiveLocation:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveNumCalls;
- (void)setPrimitiveNumCalls:(NSNumber*)value;

- (int32_t)primitiveNumCallsValue;
- (void)setPrimitiveNumCallsValue:(int32_t)value_;

- (NSNumber*)primitiveNumReviews;
- (void)setPrimitiveNumReviews:(NSNumber*)value;

- (int32_t)primitiveNumReviewsValue;
- (void)setPrimitiveNumReviewsValue:(int32_t)value_;

- (NSNumber*)primitiveNumSpecialities;
- (void)setPrimitiveNumSpecialities:(NSNumber*)value;

- (int16_t)primitiveNumSpecialitiesValue;
- (void)setPrimitiveNumSpecialitiesValue:(int16_t)value_;

- (NSNumber*)primitiveNumVideos;
- (void)setPrimitiveNumVideos:(NSNumber*)value;

- (int32_t)primitiveNumVideosValue;
- (void)setPrimitiveNumVideosValue:(int32_t)value_;

- (NSString*)primitivePhoneCode;
- (void)setPrimitivePhoneCode:(NSString*)value;

- (NSString*)primitivePhoneRawNumber;
- (void)setPrimitivePhoneRawNumber:(NSString*)value;

- (NSString*)primitivePricePerMinuteText;
- (void)setPrimitivePricePerMinuteText:(NSString*)value;

- (NSNumber*)primitiveProfileId;
- (void)setPrimitiveProfileId:(NSNumber*)value;

- (int32_t)primitiveProfileIdValue;
- (void)setPrimitiveProfileIdValue:(int32_t)value_;

- (NSString*)primitivePromotionalCode;
- (void)setPrimitivePromotionalCode:(NSString*)value;

- (NSNumber*)primitiveRating;
- (void)setPrimitiveRating:(NSNumber*)value;

- (float)primitiveRatingValue;
- (void)setPrimitiveRatingValue:(float)value_;

- (NSString*)primitiveRole;
- (void)setPrimitiveRole:(NSString*)value;

- (NSNumber*)primitiveUserId;
- (void)setPrimitiveUserId:(NSNumber*)value;

- (int32_t)primitiveUserIdValue;
- (void)setPrimitiveUserIdValue:(int32_t)value_;

- (NSMutableSet*)primitiveBusinessHours;
- (void)setPrimitiveBusinessHours:(NSMutableSet*)value;

- (NSMutableSet*)primitiveBusyHours;
- (void)setPrimitiveBusyHours:(NSMutableSet*)value;

- (NSMutableSet*)primitiveCallRequests;
- (void)setPrimitiveCallRequests:(NSMutableSet*)value;

- (NSMutableSet*)primitiveConversations;
- (void)setPrimitiveConversations:(NSMutableSet*)value;

- (NSMutableOrderedSet*)primitiveFavorites;
- (void)setPrimitiveFavorites:(NSMutableOrderedSet*)value;

- (NSMutableSet*)primitiveNotifications;
- (void)setPrimitiveNotifications:(NSMutableSet*)value;

- (NSMutableSet*)primitivePatientAnswers;
- (void)setPrimitivePatientAnswers:(NSMutableSet*)value;

- (NSMutableSet*)primitiveReceiveMessages;
- (void)setPrimitiveReceiveMessages:(NSMutableSet*)value;

- (NSMutableSet*)primitiveReceiveRequests;
- (void)setPrimitiveReceiveRequests:(NSMutableSet*)value;

- (NSMutableSet*)primitiveSentMessages;
- (void)setPrimitiveSentMessages:(NSMutableSet*)value;

- (NSMutableSet*)primitiveSpecialities;
- (void)setPrimitiveSpecialities:(NSMutableSet*)value;

- (RingUser*)primitiveUserFavorite;
- (void)setPrimitiveUserFavorite:(RingUser*)value;

@end
