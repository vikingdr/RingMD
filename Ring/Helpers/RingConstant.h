//
//  RingConstant.h
//  Ring
//
// Created by Medpats Global Pte. Ltd. on 05/09/13
// Copyright ( c ) 2013 Medpats Global Pte. Ltd.. All rights reserved.
//

#define STAGING 1

FOUNDATION_EXPORT NSString *serverAddress;
FOUNDATION_EXPORT NSString *openTokAPIKEY;
FOUNDATION_EXPORT NSString *pusherApiKey;
//CONFIG
FOUNDATION_EXPORT NSInteger perPage;

//PATHS
FOUNDATION_EXPORT const NSInteger apiVersion;
FOUNDATION_EXPORT NSString *apiVersionPath;

//Use the system controller
FOUNDATION_EXPORT NSString *userPasswordPath;
FOUNDATION_EXPORT NSString *usersPath;
FOUNDATION_EXPORT NSString *countriesPath;
FOUNDATION_EXPORT NSString *medicalSchoolsPath;
//speciality
FOUNDATION_EXPORT NSString *specialitiesPath;
//patient_question
FOUNDATION_EXPORT NSString *patientProfileAnswerPath;
FOUNDATION_EXPORT NSString *patientQuestionPath;
//user
FOUNDATION_EXPORT NSString *loginPath;
FOUNDATION_EXPORT NSString *changePasswordPath;
FOUNDATION_EXPORT NSString *changeAvatarPath;
//patient
FOUNDATION_EXPORT NSString *patientProfilePath;
//doctor
FOUNDATION_EXPORT NSString *doctorProfilePath;
FOUNDATION_EXPORT NSString *doctorsPath;
FOUNDATION_EXPORT NSString *expertDoctorsPath;
FOUNDATION_EXPORT NSString *profileUnavailablesDatesPath;
FOUNDATION_EXPORT NSString *availableTimeProfilePath;
FOUNDATION_EXPORT NSString *profileSugestedSlotsPath;
//request
FOUNDATION_EXPORT NSString *callRequestsPath;
FOUNDATION_EXPORT NSString *cancelRequestPath;
FOUNDATION_EXPORT NSString *requestShowPath;
FOUNDATION_EXPORT NSString *requestsPath;
FOUNDATION_EXPORT NSString *requestStatusPath;
FOUNDATION_EXPORT NSString *doctorRatePath;
FOUNDATION_EXPORT NSString *requestsInDatePath;
//time slot
FOUNDATION_EXPORT NSString *approveTimeslotPath;
//BusyHour
FOUNDATION_EXPORT NSString *busyDateInMonthPath;
FOUNDATION_EXPORT NSString *busyHourPath;
FOUNDATION_EXPORT NSString *busyHourDeletePath;
FOUNDATION_EXPORT NSString *businessHoursPath;
FOUNDATION_EXPORT NSString *businessHoursUpdatePath;
//video request
FOUNDATION_EXPORT NSString *chatroomVideoCallPath;
FOUNDATION_EXPORT NSString *finishSessionRequestPath;
//credit card
FOUNDATION_EXPORT NSString *creditCardTokensPath;
FOUNDATION_EXPORT NSString *memberCreditCardTokensPath;
FOUNDATION_EXPORT NSString *creditCardGenerateTokenPath;
//favorite
FOUNDATION_EXPORT NSString *favoritesPath;
FOUNDATION_EXPORT NSString *removeFavoritePath;
//notification
FOUNDATION_EXPORT NSString *notificationsPath;
//messaege
FOUNDATION_EXPORT NSString *messagesPath;
FOUNDATION_EXPORT NSString *messageToPath;
FOUNDATION_EXPORT NSString *attachFilePath;
FOUNDATION_EXPORT NSString *attachFileNotifyUploadedPath;

//PUSHER
FOUNDATION_EXPORT NSString *userEvents;
FOUNDATION_EXPORT NSString *PE_userNotification;
FOUNDATION_EXPORT NSString *PE_messageAdded;
FOUNDATION_EXPORT NSString *PE_cancelRequest;

//MODEL EVENT
FOUNDATION_EXPORT NSString *ME_userNotification;
FOUNDATION_EXPORT NSString *ME_messageUpdated;
FOUNDATION_EXPORT NSString *ME_requestRemoved;
FOUNDATION_EXPORT NSString *ME_requestUpdated;
FOUNDATION_EXPORT NSString *ME_userAvatarUpdated;
FOUNDATION_EXPORT NSString *ME_userStatusChanged;
FOUNDATION_EXPORT NSString *ME_moreDoctorInfoLoaded;

//CONTROLLER EVENT
FOUNDATION_EXPORT NSString *CE_gotoCallDetail;
FOUNDATION_EXPORT NSString *CE_gotoMessageDetail;
FOUNDATION_EXPORT NSString *CE_searchText;
FOUNDATION_EXPORT NSString *CE_onlinechanged;