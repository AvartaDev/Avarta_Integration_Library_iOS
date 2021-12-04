//
//  AvartaSettingsWorkflowItem.m
//  Avarta
//
//  Created by Dmitrii Babii on 13.09.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "AvartaSettingsWorkflowItem.h"

@implementation AvartaSettingsWorkflowItem

+(NSDictionary *)mapProperties
{
    return @{
             @"code" : @"Code",
             @"key" : @"Key"
             };
}

+(NSString *)keyName
{
    return @"Workflows";
}

@end
