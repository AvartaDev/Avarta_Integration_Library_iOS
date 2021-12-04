//
//  AvartaWorkflow.m
//  Avarta
//
//  Created by Dmitrii Babii on 30.06.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "AvartaWorkflow.h"
#import "AvartaActivities.h"

@implementation AvartaWorkflow

+(NSDictionary *)mapProperties
{
    return  @{
              @"key": @"Key",
              @"deviceBasedFlag" : @"DeviceBasedFlag",
              @"PendingActivities": [AvartaActivities class],
              @"score" : @"Score",
              @"source" : @"Source",
              @"salt" : @"Salt",
              @"status" : @"Status",
              @"dateCreated" : @"DateCreated",
              @"dateUpdated" : @"DateUpdated"
              };
}

-(AvartaActivities*)activityWithCode:(NSString*)activityCode
{
    if(self.pendingActivities.count > 0){
        for(AvartaActivities *activity in self.pendingActivities){
            if([activity.code isEqualToString:activityCode]){
                return activity;
            }
        }
    }
    
    return nil;
}


@end
