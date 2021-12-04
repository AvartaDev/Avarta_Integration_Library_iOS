//
//  AvartaActivityType.m
//  Avarta
//
//  Created by Dmitrii Babii on 03.07.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "AvartaActivityType.h"
#import "AvartaInternalConstants.h"

@implementation AvartaActivityType

+(NSDictionary *)mapProperties {
    return @{
             @"code" : @"Code",
             @"name" : @"Name"
             };
}

+(NSString *)keyName
{
    return  @"Type";
}

@end
