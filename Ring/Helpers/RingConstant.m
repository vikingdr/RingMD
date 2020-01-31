//
//  RingConstant.m
//  Ring
//
// Created by Medpats Global Pte. Ltd. on 05/09/13
// Copyright ( c ) 2013 Medpats Global Pte. Ltd.. All rights reserved.
//

#import "RingConstant.h"

NSInteger timeAfterDisplayCallButton = 0;
NSInteger timeBeforeDisplayCallButton = 0;

NSString *openTokAPIKEY = nil;
NSString *pusherApiKey = nil;

#ifdef STAGING
NSString *serverAddress = @"https://staging.ring.md";
#else
NSString *serverAddress = @"https://www.ring.md";
#endif

//Config
NSInteger perPage = 10;

//API PATHS
const NSInteger apiVersion = 4;
NSString *apiVersionPath = @"/api/v4";

//Use the system controller
NSString *userPasswordPath = @"/users/password";
NSString *countriesPath = @"/countries";
NSString *medicalSchoolsPath = @"/medical_schools";
//speciality
NSString *specialitiesPath = @"/specialities";
//patientQuestion
NSString *patientProfileAnswerPath = @"/patient_profile/update_patient_answers";
NSString *patientQuestionPath = @"/patient_questions";
//user
NSString *usersPath = @"/users";
NSString *loginPath = @"/tokens";
NSString *changePasswordPath = @"/users/change_password";
NSString *changeAvatarPath = @"/users/change_avatar";
//patient
NSString *patientProfilePath = @"/patient_profile/%@";
//doctor
NSString *doctorProfilePath = @"/doctor_profile/%@";
NSString *doctorsPath = @"/doctor_profile";
NSString *expertDoctorsPath = @"/doctor_profile/featured_doctors";
NSString *profileUnavailablesDatesPath = @"/doctor_profile/%@/unavailable_dates";
NSString *profileSugestedSlotsPath = @"/doctor_profile/%@/suggested_slots";
NSString *availableTimeProfilePath = @"/doctor_profile/%@/available_time";
//BusyHour
NSString *busyDateInMonthPath = @"/busy_times/status_in_month";
NSString *busyHourPath = @"/busy_times";
NSString *busyHourDeletePath = @"/busy_times/%@";
NSString *businessHoursPath = @"/weekly_schedules";
NSString *businessHoursUpdatePath = @"/weekly_schedules/set_business_hour";
//request
NSString *callRequestsPath = @"/requests";
NSString *cancelRequestPath = @"/requests/%@/cancel";
NSString *requestShowPath = @"/requests/%@";
NSString *requestsPath = @"/requests";
NSString *requestStatusPath = @"/requests/requests_status";
NSString *doctorRatePath = @"/requests/%@/rate";
NSString *requestsInDatePath = @"/requests/request_in_date";
//time slot
NSString *approveTimeslotPath = @"/requests/%@/accept";
//video request
NSString *chatroomVideoCallPath = @"/video_requests/%@/chatroom";
NSString *finishSessionRequestPath = @"/video_requests/%@/finish_session";
//credit card
NSString *creditCardTokensPath = @"/credit_card_tokens";
NSString *memberCreditCardTokensPath = @"/credit_card_tokens/%@";
NSString *creditCardGenerateTokenPath = @"/credit_card_tokens/%@/generate_one_time_token";
//notification
NSString *notificationsPath = @"/notifications/current_unread";
//favorite
NSString *favoritesPath = @"/favorites";
NSString *removeFavoritePath = @"/favorites/remove";
//messaege
NSString *messagesPath = @"/messages";
NSString *messageToPath = @"/messages/to";
NSString *attachFilePath = @"/attach_files/%@";
NSString *attachFileNotifyUploadedPath = @"/attach_files/%@/notify_uploaded";


//PUSHER
NSString *userEvents = @"notification, new_message";
NSString *PE_userNotification = @"notification";
NSString *PE_messageAdded = @"new_message";
NSString *PE_cancelRequest = @"cancelRequest";

//MODEL EVENT
NSString *ME_userNotification = @"userNotification";
NSString *ME_messageUpdated = @"messageUpdates";
NSString *ME_requestRemoved = @"requestRemoved";
NSString *ME_requestUpdated = @"requestUpdated";
NSString *ME_userAvatarUpdated = @"avatarUpdated";
NSString *ME_userStatusChanged = @"userStatusChange";
NSString *ME_moreDoctorInfoLoaded = @"MoreDoctorInfoLoaded";

//CONTROLLER EVENT
NSString *CE_gotoCallDetail = @"CE_gotoCallDetail";
NSString *CE_gotoMessageDetail = @"CE_gotoMessageDetail";
NSString *CE_searchText = @"CE_searchText";
NSString *CE_onlinechanged = @"CE_onlinechanged";