//
//  AvartaDeviceConfigurationModel.m
//  Avarta
//
//  Created by Dmitrii Babii on 13.09.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "AvartaDeviceConfigurationModel.h"

@implementation AvartaDeviceConfigurationModel

+(NSDictionary *)mapProperties
{
    return @{
             @"version" : @"Version",
             @"location" : @"Location",
             @"pinLength" : @"PINLength"
             };
}

+(NSString *)keyName
{
    return @"DeviceConfiguration";
}

@end
