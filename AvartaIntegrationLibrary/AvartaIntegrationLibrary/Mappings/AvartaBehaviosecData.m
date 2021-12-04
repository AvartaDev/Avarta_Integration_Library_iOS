//
//  AvartaBehaviosecData.m
//  Avarta
//
//  Created by Dmitrii Babii on 08.08.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "AvartaBehaviosecData.h"

@implementation AvartaBehaviosecData

+(NSDictionary *)mapProperties{
    return @{
             @"botDesc" : @"botDesc",
             @"confidence" : @"confidence",
             @"date" : @"date",
             @"device" : @"device",
             @"deviceChanged" : @"deviceChanged",
             @"deviceDesc" :  @"deviceDesc",
             @"deviceScore" : @"deviceScore",
             @"diDesc" : @"diDesc",
             @"diError" :  @"diError",
             @"finalizeTimestamp" : @"finalizeTimestamp",
             @"finalized" : @"finalized",
             @"ip" : @"ip",
             @"isBot" : @"isBot",
             @"isDataCorrupted" : @"isDataCorrupted",
             @"isReplay" : @"isReplay",
             @"isTrained" : @"isTrained",
             @"notes" : @"notes",
             @"numpadAnomaly" : @"numpadAnomaly",
             @"pdDesc" : @"pdDesc",
             @"pdError" : @"pdError",
             @"pocAnomaly" : @"pocAnomaly",
             @"policy" : @"policy",
             @"policyId" : @"policyId",
             @"recognitionRatio" : @"recognitionRatio",
             @"score" : @"score",
             @"tabAnomaly" : @"tabAnomaly",
             @"targets" : [AvartaBehaviosecTarget class],
             @"useragent" : @"useragent"
             };
}

+(NSString *)keyName {
    return @"data";
}


@end
