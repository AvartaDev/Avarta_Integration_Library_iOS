//
//  AvartaErrorManager.m
//  Avarta
//
//  Created by Dmitrii Babii on 19.08.16.
//  Copyright © 2016 Avarta Password Solutions. All rights reserved.
//

#import "AvartaErrorManager.h"
#import "IntegrationLibrary.h"
#import "AvartaInternalConstants.h"
#import "HTTPSessionManager.h"
#import <Bugsnag/Bugsnag.h>


@implementation AvartaErrorManager

NSInteger const kBadRequestCode = 400;
NSString *const AvartaErrorDomain = @"AvartaIntegrationLibrary";
NSInteger const kEmptyActivities = 2001;
NSInteger const kNoStartedWorkflow = 2002;

+(BOOL)checkNoWebInstance:(NSError*)error {
   [Bugsnag notifyError:error];
    NSString *errorCode = [AvartaErrorManager AvartaCodeFromError:error];
    if (errorCode){
        if([errorCode isEqualToString:@"4"]){
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}
+(NSString*)AvartaCodeFromError:(NSError*)error {
   [Bugsnag notifyError:error];
    
    NSDictionary *errorData = error.userInfo[kErrorJsonDataKey];
    if (errorData) {
        NSString *errorCode = errorData[@"Message"];
        return  errorCode;
    }
    return  nil;
}

+(NSError*)resolveError:(NSError*)error {
    NSString *AvartaCode = [self AvartaCodeFromError:error];
    NSError *resultError = [self errorFromAvartaCode:AvartaCode];
    [Bugsnag notifyError:resultError];
    return resultError;
}

+(NSError *)errorFromAvartaCode:(NSString*)code
{
    if(code)
    {
        NSInteger intCode = [code integerValue];
        
        switch (intCode) {
            case 0:
                return [NSError errorWithDomain:AvartaErrorDomain code:kBadRequestCode userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.org.record.err", @"Organisation Record Not Found.")}];
                break;
            case 1:
                return [NSError errorWithDomain:AvartaErrorDomain code:kBadRequestCode userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.user.not.found.err", @"User Record Not Found.")}];
    
                break;
            case 2:
                return [NSError errorWithDomain:AvartaErrorDomain code:kBadRequestCode userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.user.not.assoc.err", @"User Not Associated with Organisation.")}];
                break;
            case 3:
                return [NSError errorWithDomain:AvartaErrorDomain code:kBadRequestCode userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.workflow.not.assoc.err", @"Workflow Not Associated with Organisation.")}];
                break;
            case 4:
                return [NSError errorWithDomain:AvartaErrorDomain code:kBadRequestCode userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.platform.workflow.not.found.err", @"Platform Workflow Instance Not Found.")}];
                break;
            case 5:
                return [NSError errorWithDomain:AvartaErrorDomain code:kBadRequestCode userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.platform.workflow.not.complete.err", @"Platform Workflow Instance Not Complete.")}];
                break;
            case 6:
                return [NSError errorWithDomain:AvartaErrorDomain code:kBadRequestCode userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.platform.activity.type.err", @"Invalid Platform Activity Type.")}];
                break;
            case 7:
                return [NSError errorWithDomain:AvartaErrorDomain code:kBadRequestCode userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.no.workflows.found.err", @"No Workflows Found For Organisation.")}];
                break;
            case 8:
                return [NSError errorWithDomain:AvartaErrorDomain code:kBadRequestCode userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.missing.org.header.err", @"Missing Organisation Header.")}];
                break;
            case 9:
                return [NSError errorWithDomain:AvartaErrorDomain code:kBadRequestCode userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.attempt.sec.workflow.err", @"Attempt To Launch Secondary Workflow.")}];
                break;
            case 10:
                return [NSError errorWithDomain:AvartaErrorDomain code:kBadRequestCode userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.acc.locked.err", @"The user account is locked..")}];
                break;
            case 11:
                return [NSError errorWithDomain:AvartaErrorDomain code:kBadRequestCode userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.mafromed.activity.data.err", @"Malformed Activity Data  Exception.")}];
                break;
            case 14:
                return [NSError errorWithDomain:AvartaErrorDomain code:kBadRequestCode userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Message Body Invalid.", @"Message Body Invalid.")}];
                break;
            case 17:
                return [NSError errorWithDomain:AvartaErrorDomain code:kBadRequestCode userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.mafromed.activity.data.err", @"Malformed Activity Data.")}];
                break;
            case 18:
                return [NSError errorWithDomain:AvartaErrorDomain code:ERR_USER_NOT_ENROLLED_ON_SERVER userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.user.not.enrolled.data.err", @"User Is Not Enrolled.")}];
                break;
            case 19:
                return [NSError errorWithDomain:AvartaErrorDomain code:ERR_USER_NOT_ENROLLED_ON_DEVICE userInfo:@{NSLocalizedDescriptionKey :MyLocalizedString(@"Avarta.not.enrolled.device.err", @"User not enrolled on this device. Please de-enroll on the website before enrolling on this device.") }];
                break;
            default:
                return [NSError errorWithDomain:AvartaErrorDomain code:kBadRequestCode userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.bad.request.err", @"Bad Request.")}];
                break;
        }
    }
    
    return nil;
    
}

+(NSError*)formattedErrorForError:(NSError*)error forLogIn:(BOOL)logIn enableWorkflowKey:(BOOL)enableWorkflowKey andCurrentUserName:(NSString*)currentUserName
{
    
    NSError *result = error;
    NSString *AvartaCode = [AvartaErrorManager AvartaCodeFromError:error];
    if([AvartaCode isEqualToString:@"4"]){
        if(enableWorkflowKey){
            result =  [NSError errorWithDomain:AvartaErrorDomain code:ERR_WORKFLOW_INSTANCE_NOT_FOUND userInfo:@{NSLocalizedDescriptionKey: MyLocalizedString(@"Avarta.platform.workflow.not.found.err", @"Platform Workflow Instance Not Found")}];
        }else{
            if (logIn){
                result = [NSError errorWithDomain:AvartaErrorDomain code:ERR_NO_AUTHENTICATION_REQUEST userInfo:@{NSLocalizedDescriptionKey: MyLocalizedString(@"Avarta.no.auth.request.err", @"Error! No authentication request")}];
            }else{
                result = [NSError errorWithDomain:AvartaErrorDomain code:ERR_NO_ENROLL_REQUEST userInfo:@{NSLocalizedDescriptionKey: MyLocalizedString(@"Avarta.no.enroll.request.err", @"Error! No enroll request")}];
            }
        }
    }else if ([AvartaCode isEqualToString:@"1"]){
        result = [NSError errorWithDomain:AvartaErrorDomain code:ERR_USER_NOT_FOUND userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:MyLocalizedString(@"Avarta.user.not.found.err", @"User %@ not found"), currentUserName]}];
    }else{
        result = [AvartaErrorManager errorFromAvartaCode:AvartaCode];
        
        if(!result)
        {
            result = error;
        }
        
    }
    
    [Bugsnag notifyError:result];
    return result;
}



+(NSError*)errorFromCode:(NSInteger)errorCode userName:(NSString*)username
{
    NSError *error;
    switch (errorCode) {
        case ERR_USER_NOT_VERIFIED:
             error = [NSError errorWithDomain:AvartaErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.not.verified.err", @"Sorry.Not verified") }];
           [Bugsnag notifyError:error];
            return error;
            break;
        case ERR_WRONG_PASSWORD:
            error = [NSError errorWithDomain:AvartaErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.wrong.password.err", @"Sorry. Wrong Password") }];
           [Bugsnag notifyError:error];
            return error;
            break;
        case ERR_WORKFLOW_INSTANCE_NOT_FOUND:
            return [NSError errorWithDomain:AvartaErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.platform.workflow.not.found.err", @"Platform Workflow Instance Not Found") }];
            break;
        case ERR_NO_AUTHENTICATION_REQUEST:
            error = [NSError errorWithDomain:AvartaErrorDomain code:ERR_NO_AUTHENTICATION_REQUEST userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.no.auth.request.err", @"Error! No authentication request") }];
           [Bugsnag notifyError:error];
            return error;
            break;
        case ERR_NO_ENROLL_REQUEST:
            error = [NSError errorWithDomain:AvartaErrorDomain code:ERR_NO_ENROLL_REQUEST userInfo:@{NSLocalizedDescriptionKey: MyLocalizedString(@"Avarta.no.enroll.request.err", @"Error! No enroll request")}];
           [Bugsnag notifyError:error];
            return error;
            break;
        case ERR_USER_NOT_ENROLLED_ON_DEVICE:
            error = [NSError errorWithDomain:AvartaErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey: MyLocalizedString(@"Avarta.not.enrolled.device.err", @"User not enrolled on this device. Please de-enroll on the website before enrolling on this device.")}];
           [Bugsnag notifyError:error];
            return error;
            break;
        case ERR_USER_NOT_FOUND:
            error = [NSError errorWithDomain:AvartaErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:MyLocalizedString(@"Avarta.user.not.found.err", @"User %@ not found"), username]}];
           [Bugsnag notifyError:error];
            return error;
            break;
        case ERR_USER_NOT_ENROLLED:
            error = [NSError errorWithDomain:AvartaErrorDomain code:ERR_USER_NOT_ENROLLED userInfo:@{NSLocalizedDescriptionKey : MyLocalizedString(@"Avarta.not.enrolled.err", @"Sorry. Not Enrolled")}];
           [Bugsnag notifyError:error];
            return error;
            break;
        case kNoStartedWorkflow:
            error = [NSError errorWithDomain:AvartaErrorDomain code:kNoStartedWorkflow userInfo:@{NSLocalizedDescriptionKey :  MyLocalizedString(@"Avarta.scores.err", @"Can't calculate scores, workflow didn't started")}];
           [Bugsnag notifyError:error];
            return error;
            break;
        default:
            return nil;
            break;
    }
    return nil;
}


+(NSError*)checkBadRequestAndReturnError:(NSError*)error{
    
    if(error.code == kBadRequestCode){
        NSString *code = [AvartaErrorManager AvartaCodeFromError:error];
        error = [AvartaErrorManager errorFromAvartaCode:code];
    }
   [Bugsnag notifyError:error];
    return error;
}

@end
