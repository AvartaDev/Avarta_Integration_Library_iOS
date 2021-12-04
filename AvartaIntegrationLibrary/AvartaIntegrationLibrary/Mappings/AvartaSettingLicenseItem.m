//
//  AvartaSettingLicenseItem.m
//  Avarta
//
//  Created by Dmitrii Babii on 13.09.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "AvartaSettingLicenseItem.h"

@implementation AvartaSettingLicenseItem

+(NSDictionary *)mapProperties
{
    return @{
             @"Provider": [AvartaLicenseProvider class],
             @"OperatingSystem" : [AvartaLicenseOperatingSystem class],
             @"key" : @"Key",
             @"startDate" : @"StartDate",
             @"endDate" : @"EndDate"
             };
}

+(NSString *)keyName
{
    return @"Licences";
}

@end
