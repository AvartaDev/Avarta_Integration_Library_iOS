//
//  AvartaLicenseOperatingSystem.m
//  Avarta
//
//  Created by Dmitrii Babii on 13.09.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "AvartaLicenseOperatingSystem.h"

@implementation AvartaLicenseOperatingSystem

+(NSDictionary *)mapProperties
{
    return @{
             @"code" : @"Code",
             @"name" : @"Name"
             };
}

+(NSString *)keyName
{
    return @"OperatingSystem";
}

@end
