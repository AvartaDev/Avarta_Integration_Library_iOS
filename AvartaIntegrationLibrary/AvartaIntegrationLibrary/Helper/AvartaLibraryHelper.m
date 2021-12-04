//
//  AvartaLibraryHelper.m
//  Avarta
//
//  Created by Dmitrii Babii on 11.09.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "AvartaLibraryHelper.h"
#import "AvartaInternalConstants.h"


@implementation AvartaLibraryHelper

+(nullable NSString*)codeForActivity:(AvartaActivitiesE)type
{
    switch (type) {
        case ActivityEnrollZoom:
            return ACTIVITY_ENROLZOOMSECRET;
            break;
        case ActivityValidateZoom:
            return ACTIVITY_VALIDATEZOOMSECRET;
            break;
        case ActivityDynamicPin:
            return ACTIVITY_DYNAMICPIN;
            break;
        case ActivityDevice:
            return ACTIVITY_DEVICE;
            break;
        case ActivityPush:
            return ACTIVITY_PUSH;
            break;
        case ActivityGeolocation:
            return ACTIVITY_GEOLOCATION;
            break;
        case ActivityPassword:
            return ACTIVITY_PASSWORD;
            break;
        case ActivityVersion:
            return ACTIVITY_VERSION;
            break;
        case ActivityDeviceCap:
            return ACTIVICY_DEVICECAP;
            break;
        case ActivityDelete:
            return ACTIVITY_DELETE;
            break;
        case ActivityValidateEnrolCode:
            return ACTIVITY_VALIDATEENROLCODE;
            break;
        case ActivityUndefined:
            return nil;
            break;
    }
    return nil;
}

+(AvartaActivitiesE)activityTypeForCode:(NSString*)code
{
    if([code isEqualToString:ACTIVITY_ENROLZOOMSECRET]){
        return ActivityEnrollZoom;
    }else if([code isEqualToString:ACTIVITY_DYNAMICPIN]){
        return ActivityDynamicPin;
    }else if([code isEqualToString:ACTIVITY_DEVICE]){
        return ActivityDevice;
    }else if([code isEqualToString:ACTIVITY_PUSH]){
        return ActivityPush;
    }else if([code isEqualToString:ACTIVITY_GEOLOCATION]){
        return ActivityGeolocation;
    }else if([code isEqualToString:ACTIVITY_PASSWORD]){
        return ActivityPassword;
    }else if([code isEqualToString:ACTIVICY_DEVICECAP]){
        return ActivityDeviceCap;
    }else if([code isEqualToString:ACTIVITY_DELETE]){
        return ActivityDelete;
    }else if([code isEqualToString:ACTIVITY_VALIDATEENROLCODE]){
        return ActivityValidateEnrolCode;
    }else if([code isEqualToString:ACTIVITY_DELETE]){
        return ActivityDelete;
    }else if([code isEqualToString:ACTIVITY_VERSION]){
        return ActivityVersion;
    }else if([code isEqualToString:ACTIVITY_VALIDATEZOOMSECRET])
    {
        return ActivityValidateZoom;
    }
    return ActivityUndefined;
}

+(nullable NSString*)typeCodeForAvartaWorkflowtype:(AvartaWorkflowType)type
{
    switch (type) {
        case AvartaEnrollWorkflow:
            return @"ENROL";
            break;
        case AvartaVerifyWorkflow:
            return @"AUTH";
            break;
        case AvartaDeleteWorkflow:
            return @"DE-ENROL";
            break;
        case AvartaStepUpWorkflow:
            return @"STEP-UP";
            break;
        case AvartaStepUpElevatedWorkflow:
            return @"STEP-UP-ELEVATED";
            break;
    }
}

+(NSString*)serializeJSONToString:(NSDictionary*)json
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end
