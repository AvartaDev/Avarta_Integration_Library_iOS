//
//  AvartaActivities.m
//  Avarta
//
//  Created by Dmitrii Babii on 30.06.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "AvartaActivities.h"
#import "AvartaInternalConstants.h"
#import "AvartaLibraryHelper.h"

@implementation AvartaActivities

+(NSDictionary *)mapProperties {
    return @{
             @"Type" : [AvartaActivityType class],
             @"name": @"Name",
             @"code": @"Code"
             };
}

+(NSString *)keyName {
    return @"PendingActivities";
}

-(AvartaActivitiesE)activityType{
    return [AvartaLibraryHelper activityTypeForCode:self.code];
}




@end
