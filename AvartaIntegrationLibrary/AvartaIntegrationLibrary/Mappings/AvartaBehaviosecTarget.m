//
//  AvartaBehaviosecTarget.m
//  Avarta
//
//  Created by Dmitrii Babii on 08.08.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "AvartaBehaviosecTarget.h"

@implementation AvartaBehaviosecTarget

+(NSDictionary *)mapProperties
{
    return @{
             @"botDesc" : @"botDesc",
             @"confidence" : @"confidence",
//             @"diDesc" : @"diDesc",
             @"diError" : @"diError",
             @"isBot" : @"isBot",
             @"isTrained" : @"isTrained",
             @"numpadAnomaly" : @"numpadAnomaly",
             @"numpadRatio" : @"numpadRatio",
             @"numpadUsed" : @"numpadUsed",
//             @"pdDesc" : @"pdDesc",
             @"pdError" : @"pdError",
             @"pocAnomaly" : @"pocAnomaly",
             @"pocRatio" : @"pocRatio",
             @"pocUsed" : @"pocUsed",
             @"recognitionRatio" : @"recognitionRatio",
             @"score" : @"score",
             @"tabAnomaly" : @"tabAnomaly",
             @"tabRatio" : @"tabRatio",
             @"tabUsed" : @"tabUsed",
             @"target" : @"target",
             @"training" : @"training",
             @"type" : @"type",
             @"updates" : @"updates"
             };
}

+(NSString *)keyName {
    return @"targets";
}

@end
