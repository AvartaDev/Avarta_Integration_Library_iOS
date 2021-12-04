//
//  AvartaInternalConstants.h
//  Avarta
//
//  Created by Dmitrii Babii on 01.08.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AvartaInternalConstants : NSObject

typedef NS_ENUM(NSInteger, AvartaStatus) {
    AvartaStatusCreated,
    AvartaStatusCompleted,
    AvartaStatusFailed,
    AvartaStatusAborted
};

typedef enum {
    PROCESS_ENROLL,
    PROCESS_VERIFY,
    PROCESS_REMOVE
}PROCESS;

#define ACTIVITY_DYNAMICPIN @"DYNAMICPIN"
#define ACTIVITY_ENROLZOOMSECRET @"ENROLZOOMSECRET"
#define ACTIVITY_VALIDATEZOOMSECRET @"VALIDATEZOOMSECRET"
#define ACTIVITY_DEVICE @"DEVICE"
#define ACTIVITY_PUSH @"NOTIFICATIONPUSHID"
#define ACTIVITY_GEOLOCATION @"GEOLOCATION"
#define ACTIVITY_PASSWORD @"PASSWORD"
#define ACTIVITY_VERSION @"APPVERSION"
#define ACTIVICY_DEVICECAP @"DEVICECAP"
#define ACTIVITY_DELETE @"DELETEEVUSER"
#define ACTIVITY_VALIDATEENROLCODE @"VALIDATEENROLCODE"
#define ACTIVITY_REGISTERINAUTHDEVICE @"REGISTERINAUTHDEVICE"
#define ACTIVITY_CAPTUREINAUTHLOGS @"CAPTUREINAUTHLOGS"

#define kIsUserEnrolled @"/api/v1/user/isuserenrolled"
#define kStatusCheck @"/api/v1/workflow/status/"
#define kStatusTypeCheck @"/api/v1/workflow/statustype"
#define kVerificationCheck @"/api/v1/workflow/status/"
#define kProcessItem @"/api/v1/workflow/processitem"
#define kAbortEnrollment @"/api/v1/workflow/abort/"
#define kStartWorkFlow @"/api/v1/workflow/start"
#define kCompleteWorkFlow @"/api/v1/workflow/complete/"
#define kSessionCheck @"/api/v1/session/check"
#define kCurrentVersionCheck @"/api/v1/diagnostics/SupportedClientVersion"
#define kApplicationConfig @"/api/v1/organisation/applicationconfiguration"
#define kBehaviorEndpoint @"/api/v1/behaviour/logbehaviour/"
#define kCalculateUserScores @"/api/v1/userscore/calculateuserscores"
#define kInauthRegister @"/api/v1/inauthmanager/registerinauthdevicetouser"
#define kInauthSendLogs @"/api/v1/inauthmanager/loginauthresults"
#define kChangePassword @"/api/v1/userupdate/changeuserpassword"

#define AvartaCryptKey  @"$h#hudABEy54aPre2haKa+epr2huwRuR"
#define AvartaCryptVector @"pemgail9uzpgzl88"
#define AvartaCipher @"vuka@8SW"

@end
