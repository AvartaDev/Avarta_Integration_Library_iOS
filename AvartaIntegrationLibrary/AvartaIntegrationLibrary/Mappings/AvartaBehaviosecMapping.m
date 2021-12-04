//
//  AvartaBehaviosecMapping.m
//  Avarta
//
//  Created by Dmitrii Babii on 08.08.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "AvartaBehaviosecMapping.h"
#import "AvartaBehaviosecData.h"

@implementation AvartaBehaviosecMapping

+(NSDictionary *)mapProperties{
    return @{
             @"botDesc" : @"botDesc",
             @"data" : [AvartaBehaviosecData class],
             @"confidence" : @"confidence",
             @"deviceChanged": @"deviceChanged",
             @"deviceDesc": @"deviceDesc",
             @"deviceScore": @"deviceScore",
             @"diDesc": @"diDesc",
             @"diError": @"diError",
             @"endDate": @"endDate",
             @"endTimestamp": @"endTimestamp",
             @"finalizeNotes": @"finalizeNotes",
             @"finalizeTimestamp": @"finalizeTimestamp",
             @"finalized": @"finalized",
             @"ipChanged": @"ipChanged",
             @"ipSeverity": @"ipSeverity",
             @"isBot": @"isBot",
             @"isDataCorrupted": @"isDataCorrupted",
             @"isReplay": @"isReplay",
             @"isSessionCorrupted": @"isSessionCorrupted",
             @"isSessionCorruptedDesc": @"isSessionCorruptedDesc",
             @"isTrained": @"isTrained",
             @"isWhitelisted": @"isWhitelisted",
             @"numpadAnomaly": @"numpadAnomaly",
             @"pdDesc": @"pdDesc",
             @"pdError": @"pdError",
             @"pocAnomaly": @"pocAnomaly",
             @"policy": @"policy",
             @"policyId": @"policyId",
             @"recognitionRatio": @"recognitionRatio",
             @"score": @"score",
             @"sessionId": @"sessionId",
             @"startDate": @"startDate",
             @"startTimestamp": @"startTimestamp",
             @"tabAnomaly": @"tabAnomaly",
             @"uiConfidence": @"uiConfidence",
             @"uiScore": @"uiScore",
             @"userid": @"userid"
             };
}

@end
